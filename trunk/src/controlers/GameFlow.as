package controlers
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.IResourceManager;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	import com.norris.fuzzy.map.IMapItem;
	
	import models.*;
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.PlayerModel;
	import models.impl.RecordModel;
	
	import screens.BattleScreen;
	
	import server.IDataServer;
	import server.ProxyServer;
	import server.event.ServerEvent;
	import server.impl.FakeServer;
	import server.impl.SocketServer;
	
	import views.MapItem;
	
	public class GameFlow
	{
		public var world:MyWorld; 
		
		public function GameFlow( world:MyWorld )
		{
			this.world = world;
		}
		
		/**
		 * 1. 连接server
		 2. 下载人物信息
		 3. 获取场景信息
		 4. 获取场景资源
		 5. 绘制场景
		 6. done 
		 * 
		 */		
		public function start() :void
		{
			//--------------------------------------- 1 ---------------------------------
			world.showLoading();
			world.addLoadingText( "正在连接服务器..." );
			
			//			var serverObj:IDataServer = new SocketServer();
			var serverObj:IDataServer = new FakeServer();
			serverObj.config( "localhost", 8080 );
			serverObj.addEventListener( ServerEvent.Error, function( event:ServerEvent ):void{
				world.addLoadingText( "链接服务器失败" );
			} );
			serverObj.addEventListener( ServerEvent.Connect, function( event:ServerEvent ):void{
				world.addLoadingText( "成功链接服务器" );
				ProxyServer.server = serverObj;
				ProxyServer.master = "test";
				
				//------------------------------------------2-------------------------------
				world.addLoadingText( "下载人物信息..." );
				var player:PlayerModel = new PlayerModel( "test" );
				player.addEventListener( ModelEvent.COMPLETED, function( event:ModelEvent ) : void{
					world.addLoadingText( "成功下载人物信息" );
					
					//---------------------------------------3-----------------------------
					if ( player.screen == "battle" ){
						world.addLoadingText( "读取战场记录..." );
						
						var record:RecordModel = new RecordModel( player.data[ "record" ] );
						var battle:BattleScreen = new BattleScreen( record );
						record.addEventListener( ModelEvent.COMPLETED, function( event:ModelEvent ) : void{
							world.addLoadingText( "成功读取战场记录" );
							
							//---------------------------------------4-----------------------------
							var resourceMgr:IResourceManager = world.resourceMgr;
							var map:MapModel = record.mapModel;
							var resource:Array = [];
							
							//mapLayer接收返回
							resourceMgr.add( map.background.src );
							resource.push( map.background.src );
							
							for each( var define:Array in map.defines ){
								resourceMgr.add( define[0], define[1] );
								resource.push( define[0] );
							}
							
							//下载战场附件资源
							var battleSwf:IResource = resourceMgr.add( "battle", "assets/battle.swf" );
							resource.push( battleSwf );
							
							world.addLoadingText( "0/" + resource.length +"下载场景资源" );
							resourceMgr.load( resource, function( event:ResourceEvent ):void{
								//显示下载进度
								world.addLoadingText( event.success.length + "/" + event.resources.length +"下载场景资源" ); 
							} ,  function( event:ResourceEvent ):void{
								if ( event.ok ){
									world.addLoadingText( "成功下载场景资源" );
									
									for each ( var item:IMapItem in map.items ){
										if ( item is IDataSource ){
											( item as IDataSource ).dataSource = resourceMgr.getResource( item.define );
										}
									}
									
									//---------------------------------------5-----------------------------
									battle.mapLayer.dataSource = resourceMgr.getResource( map.background.src );
									battle.menuLayer.dataSource = battleSwf;
									battle.setup();
									
									world.screenMgr.add("battle", battle );
									world.screenMgr.goto( "battle" );
									
								}else{
									world.addLoadingText( "下载场景资源失败" );
								}
							} );
							
						});
						record.addEventListener( ModelEvent.ERROR, function( event:ModelEvent ) : void{
							world.addLoadingText( "读取战场记录失败" );
						});
						
						record.loadData();
						
					}else{
						//其他场景
					}
					
				});
				player.addEventListener( ModelEvent.ERROR, function( event:ModelEvent ) : void{
					world.addLoadingText( "下载人物信息失败" );
				});
				player.loadData();
				
			} );
			serverObj.connect();		
			
		}
				
	}
}