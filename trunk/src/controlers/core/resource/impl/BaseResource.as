package controlers.core.resource.impl
{
	import controlers.core.log.Logger;
	import controlers.core.resource.IResource;
	import controlers.core.resource.event.ResourceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class BaseResource extends EventDispatcher implements IResource
	{
		protected var _name:String;
		protected var _url:String;
		protected var _bytesLoaded :uint = 0;
		protected var _bytesTotal:uint = 0;
		protected var _lastTime:uint = 0;
		
		protected var _policy:*;
		protected var _isFailed:Boolean = false;
		protected var _isFinish:Boolean = false;
		protected var _isLoading:Boolean = false;
		protected var _msg:String;
		protected var _data:*;
		
		protected var _beginTime:uint = 0;
		protected var _loader:URLLoader;
		protected var _request:URLRequest;
		
		public function BaseResource( name:String, url:String, policy: * = null )
		{
			super( null );
			
			if ( url == null ){
				Logger.error( "BaseSource constructor : url is null." );
			}
			
			this._name = name;
			this._url  = url;
			this._policy = policy;
		}
		
		public function load():void
		{
			if ( _isLoading )
				return;
			
			//finish 不再加载，但仍然触发事件
			if ( _isFinish ){
				onCompleteHandler();
				return;
			}
			
			if ( _request == null )
				this.createRequest();
			
			if ( _loader == null )
				this.createLoader();
			
			_isFailed  = false;
			_isFinish  = false;
			_isLoading = true;
			
			try{
				// TODO: test for security error thown.
				_loader.load( _request );
			}catch( e : SecurityError){
				onSecurityErrorHandler( e );
			}	
		}
		
		protected function createRequest() : void
		{			
			_request = new URLRequest( this.url );
		}
		
		protected function createLoader() : void
		{
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.addEventListener(Event.COMPLETE, onCompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
//			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			_loader.addEventListener(Event.OPEN, onOpenHandler);
		}

		protected function onHttpStatusHandler(evt : HTTPStatusEvent) : void{
		}
		
		/**
		 * 只有当 bytesLoaded变动时才会触发process事件
		 * @param evt
		 * 
		 */		
		protected function onProgressHandler(evt : ProgressEvent ) : void {
			if ( _bytesLoaded == evt.bytesLoaded )
				return;
			
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_lastTime = getTimer() - this._beginTime;
			
			dispatchEvent( new ResourceEvent( ResourceEvent.PROCESS, this ) );
		}
		
		protected function onCompleteHandler(evt : Event = null, finish:Boolean = true ) : void {
			
			_isLoading = false;
			_isFinish  = finish;
			
			getContent( evt );
			
			dispatchEvent( new ResourceEvent( ResourceEvent.COMPLETE, this ) );
		}
		
		protected function getContent( evt:Event = null ) : void
		{
			if ( !_isFailed )
				this._data = this._loader.data;
			else
				this._data = null;
		}
		
		protected function onIOErrorHandler(evt : IOErrorEvent) : void{
			_msg = evt.toString();
			_isFailed = true;
			
			dispatchEvent( new ResourceEvent( ResourceEvent.ERROR, this ) );

			Logger.error( "load " + this.name + " ioerror url = " + this._url );
			
			onCompleteHandler();
		}
		
		protected function onSecurityErrorHandler(e : SecurityError , complete:Boolean = true ) : void{
			_msg = e.toString();
			_isFailed = true;
			
			dispatchEvent( new ResourceEvent( ResourceEvent.ERROR, this ) );
			
			Logger.error( "load " + this.name + " security error url = " + this._url );
			
			if ( complete )
				onCompleteHandler();
		}
		
		/**
		 * open时开始记录时间 
		 * @param evt
		 * 
		 */		
		protected function onOpenHandler(evt : Event) : void{
			_beginTime = getTimer();
			
			this.dispatchEvent( new ResourceEvent( ResourceEvent.OPEN, this ) );
		}
		
		public function reset():void
		{
			this.close();
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_lastTime = 0;
			_isFinish = false;
			_isFailed = false;
			_isLoading = false;
			_msg = "";
			_data = null;
		}

		public function close():void
		{
			if ( this._isLoading && this._loader != null ){
				this._loader.close();
				
				_isFailed = _bytesLoaded != _bytesTotal && _bytesTotal != 0;
				
				dispatchEvent( new ResourceEvent( ResourceEvent.STOP, this ) );
				
				//并未真正完成需要重新加载
				onCompleteHandler( null, false );
			}
		}

		public function destroy():void
		{
			clearListeners();
			
			this._data = null;
			this._request = null;
			this._loader = null;
			this._policy = null;
		}
		
		protected function clearListeners() : void
		{
			if ( _loader == null )
				return;
			
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler );
			_loader.removeEventListener(Event.COMPLETE, onCompleteHandler );
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
//			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler );
			_loader.removeEventListener(Event.OPEN, onOpenHandler );			
		}
		
		public function get content():*
		{
			return _data;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function set request(value:URLRequest):void
		{
			_request = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get lastTime():uint
		{
			return _lastTime;
		}
		
		public function get bytesLoaded():uint
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _bytesTotal;
		}
		
		public function set policy(value:*):void
		{
			_policy = value;
		}
		
		public function isFailed():Boolean
		{
			return _isFailed;
		}
		
		public function isFinish():Boolean
		{
			return _isFinish;
		}
		
		public function isLoading():Boolean
		{
			return _isLoading;
		}
	}
}