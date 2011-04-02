package
{
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.resource.IResourceManager;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import models.*;
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.PlayerModel;
	import models.impl.RecordModel;
	
	import screens.BattleScreen;
	import views.MapItem;
	
	import server.IDataServer;
	import server.ProxyServer;
	import server.event.ServerEvent;
	import server.impl.FakeServer;
	import server.impl.SocketServer;
	
	[SWF(frameRate="24", bgcolor="0x000000" )]
	public class index extends Sprite
	{
		public var  world:MyWorld;
		
		public static var aaa:uint = 0;
		
		public function index()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);		
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			if ( this.stage )
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			world = new MyWorld();
			world.init( this );
			
			start();
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
		private function start() :void
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
							
							var items:Object = map.items;
							for each( var item:MapItem in items ){
								//下载好后直接赋值给mapItem
								item.dataSource = resourceMgr.add( item.define, item.src );
								resource.push( item.define );
							}
							
							world.addLoadingText( "0/" + resource.length +"下载场景资源" );
							resourceMgr.load( resource, function( event:ResourceEvent ):void{
								//显示下载进度
								world.addLoadingText( event.success.length + "/" + event.resources.length +"下载场景资源" ); 
							} ,  function( event:ResourceEvent ):void{
								if ( event.ok ){
									world.addLoadingText( "成功下载场景资源" );
									
									//---------------------------------------5-----------------------------
									battle.mapLayer.dataSource = resourceMgr.getResource( map.background.src );
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