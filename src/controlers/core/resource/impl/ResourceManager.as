package controlers.core.resource.impl
{
	import controlers.core.log.Logger;
	import controlers.core.manager.impl.BaseManager;
	import controlers.core.resource.IResource;
	import controlers.core.resource.IResourceManager;
	import controlers.core.resource.event.ResourceEvent;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class ResourceManager extends BaseManager implements IResourceManager
	{
		private var _local:String = "zh";
		private var _running :Boolean = false;
		private var _waitingfor:Array = [];
		
		public var threads:uint = 5;
		
		
		public function ResourceManager()
		{
		}
		
		public function set local(value:String):void
		{
			_local = value;
		}
		
		public function add(name:String, url:String=null, policy:Boolean = false, type:Class=null ):IResource
		{
			if ( name == null || name == ""  ){
				Logger.error("ResourceManager add Resource fn : name is empty." );
				return null;
			}
		
			if ( this.has( name ) ){
				return this.get( name ) as IResource;
			}
			
			url = url || name;
			//自动替换{local}属性,不支持切换
			url = url.replace( "{local}", _local );
			
			var ret:IResource = null;		
			if ( type != null ){
				typeof type;
				var b :Boolean = type is IResource;
				try{
					ret = (new type( name, url, policy ) ) as IResource;	
				}catch( e:Error ){
					Logger.error("ResourceManager add Resource fn : wrong type." );
					ret = null;
				}
			}
			
			if ( ret == null ){
				type = guessType( url );
				ret = (new type( name, url, policy ) ) as IResource;	
			}
			
			this.reg( name, ret );
			
			return ret;
		}
		
		/**
		 * 根据后缀名判断资源类型 
		 * @param url
		 * @return 
		 * 
		 */		
		public function guessType( url:String ) :Class
		{
			var extension:String = url.replace( /.*[.](\w{1,5})$/i, "$1" );
			
			if ( /jpg|jpeg|gif|png|bmp|ico/i.test( extension )  )
				return ImageResource;
				
			else if ( /swf/i.test( extension ) )
				return ImageResource;
				
			else if ( /xml|mxml|xls/i.test( extension ) )
				return ImageResource;
				
			else if ( /mp3|f4a|f4b/i.test( extension ) )
				return ImageResource;
				
			else if ( /json/i.test( extension ) )
				return ImageResource;
				
			else if ( /flv|f4v|f4p|mp4/i.test( extension ) )
				return ImageResource;
				
			else if ( /txt|js|css|html|php|py|jsp|asp/i.test( extension ) )
				return ImageResource;
				
			else
				return BaseResource;
		}
		
		public function load(name:Object, onProcess:Function=null, onComplete:Function=null):void
		{
			//如果正在运行，则暂存
			if ( this._running ){
				_waitingfor.push( [name, onProcess, onComplete] );
				return;
			}
			
			this._running = true;
			
			var resources:Array = this.getResources( this.parseName( name ) );
			var count:int = 0, current:int = 0 ;
			
			// 当多个资源时用下面的事件对象
			var eventArray:ResourceEvent = new ResourceEvent( ResourceEvent.COMPLETE, null ),
				   single:Boolean = resources.length <= 1,
				   beginTime :uint = getTimer() ;
			
			var tempProcess:Function = function( event:ResourceEvent ) : void{
				if ( onProcess != null ){
					onProcess.call( null, single ? event : this.compositeEvent( eventArray, beginTime - getTimer(),  event ) );
				}
			};
			
			var tempComplete:Function = function( event:ResourceEvent ) : void{
				count++;
				trace( "count = " + count );
				
				event.resource.removeEventListener( ResourceEvent.COMPLETE, tempComplete );
				event.resource.removeEventListener( ResourceEvent.PROCESS, tempProcess );
				
				if ( count == resources.length ){
					Logger.debug( "ResourceManager load " + count + " resources." );
					
					//all done callback
					if ( onComplete != null )
						onProcess.call( null, single ? event : this.compositeEvent( eventArray, beginTime - getTimer(),  event ) );
					
					//go on loading _waitingfor
					if ( _waitingfor.length > 0 ){
						var w:Array = _waitingfor.shift() as Array;
						this.load.apply( null, w );
					}else{
						this._running = false;
					}
					
					return;
				}
				
				//go next
				if ( current < resources.length ){
					(resources[ current++ ] as IResource).load();
				}

			};
			
			for each ( var r :IResource in resources ){
				r.addEventListener( ResourceEvent.COMPLETE, tempComplete );
				r.addEventListener( ResourceEvent.PROCESS, tempProcess );
			}
			
			//start load
			current = Math.min( this.threads, resources.length );
			for( var i:int =0 ; i< current ; i++ ){
				(resources[ i ] as IResource).load();			
			}
		}
		
		/**
		 *  将后面的事件信息叠加到sum中 
		 * @param sum
		 * @param insition
		 * @return 
		 * 
		 */		
		private function compositeEvent( sum: ResourceEvent , last:uint, insition :ResourceEvent ) : ResourceEvent
		{
			sum.bytesTotal  	   += insition.bytesTotal;
			sum.lastTime			=  last;
			sum.bytesLoaded += insition.bytesLoaded;			
			
			if ( insition.ok )
				sum.success.push( insition );
			else
				sum.failed.push( insition );
			
			return sum;
		}
		
		protected function parseName( name:Object ) : Array
		{
			if ( name == null ){
				return [];
			}
			
			if ( name is String ){
				return [ name as String ];
			}
			
			if ( name is Array )
				return name as Array;
			else
				return [];
		}
		
		public function reload(name:Object, onProcess:Function=null, onComplete:Function=null):void
		{
			var resources:Array = this.getResources( this.parseName( name ) );
			
			for each ( var r :IResource in resources ){
				r.reset();
			}
			
			this.load.apply( null, arguments );
		}
		
		public function remove(name:Object):void
		{
			var names:Array = this.parseName( name );
			
			for each ( var key:String in names ){
				this.unreg( key );
			}
		}
		
		public function stop(name:Object):void
		{
			var resources:Array = this.getResources( this.parseName( name ) );
			
			for each ( var r :IResource in resources ){
				r.close();
			}			
		}
		
		public function destroyResource(name:Object):void
		{
			var resources:Array = this.getResources( this.parseName( name ) );
			
			for each ( var r :IResource in resources ){
				r.destroy();
			}
		}
		
		public function getResource(name:String):IResource
		{
			if ( name == null || name == "" )
				return null;
			
			return this.get( name ) as IResource;
		}

		public function getResources( names:Array ) : Array
		{
			//排重
			if ( names.length > 1 ){
				var tmp:Object = {};
				for each ( var keyName :String in names ){
					tmp[ keyName ] = keyName;
				}
				names = [];
				for each ( keyName  in tmp ){
					names.push( keyName );
				}
			}
			
			var ret:Array = [];
			
			for each ( var key :String in names ){
				var r:IResource = this.getResource( key );
				if ( r != null ){
					ret.push( r );
				}
			}
			
			return ret;
		}
		
		public function destroyAll():void
		{
			var obj:Object = this.getAll();
			
			for each ( var r :IResource in obj ){
				if ( r != null ) 
					r.destroy();
			}
			Logger.warning( " ResourceManager all resources is destroyed ." );
		}
		
		public function isRunning() :Boolean
		{
			return _running;
		}
	}
}