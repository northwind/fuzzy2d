package resource.impl
{
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import resource.BaseManager;
	import resource.IResource;
	import resource.IResourceManager;
	import resource.event.ResourceEvent;
	
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
				throw new Error( "ResourceManager createResource : name is empty." );
			}
		
			if ( this.has( name ) ){
				//TODO LOG
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
					//TODO log		
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
			
			//做为第一个参数传入onComplete
			var eventComplete:ResourceEvent = new ResourceEvent( ResourceEvent.COMPLETE, null );
			
			var tempProcess:Function = function( event:ResourceEvent ) : void{
				if ( onProcess != null )
					onProcess.call( null, event );
			};
			
			var tempComplete:Function = function( event:ResourceEvent ) : void{
				count++;
				trace( "count = " + count );
				
				event.resource.removeEventListener( ResourceEvent.COMPLETE, tempComplete );
				event.resource.removeEventListener( ResourceEvent.PROCESS, tempProcess );
				
				if ( count == resources.length ){
					trace( "before call onComplete" );
					//all done
					if ( onComplete != null )
						onComplete.call( null, eventComplete );
					
					//deal with _waitingfor
					if ( _waitingfor.length > 0 ){
						var w:Array = _waitingfor.shift() as Array;
						this.load.apply( null, w );
					}else{
						this._running = false;
					}
					
					return;
				}
				
				//go on load
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
		}
		
		public function get isRunning() :Boolean
		{
			return _running;
		}
	}
}