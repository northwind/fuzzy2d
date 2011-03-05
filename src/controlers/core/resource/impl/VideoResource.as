package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	import controlers.core.resource.event.ResourceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	
	public class VideoResource extends BaseResource implements IResource
	{
		public function VideoResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override public function get content():*
		{
			return getStream();
		}
		
		public function getStream() :NetStream
		{
			if ( _data == null )
				return null;
			
			return _data as NetStream;
		}
		
		override public function load():void
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
			
			if ( _soundLoader == null )
				this.createLoader();
			
			_isFailed  = false;
			_isFinish  = false;
			_isLoading = true;
			
			try{
				_soundLoader.load( _request, _policy );
			}catch( e : SecurityError){
				onSecurityErrorHandler( e );
			}	
			
		}
		
		override protected function createLoader() : void
		{
			_soundLoader = new Sound();
			_soundLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_soundLoader.addEventListener(Event.COMPLETE, onCompleteHandler);
			_soundLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
//			_soundLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			_soundLoader.addEventListener(Event.OPEN, onOpenHandler);
			_soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
		}
		
		override protected function getContent( evt:Event = null ) : void
		{
			if ( !_isFailed ){
				this._data = _soundLoader;
			}
			else
				this._data = null;
		}
		
		override public function reset():void
		{
			super.reset();
			_soundLoader = null;
		}
		
		override public function close() : void
		{
			if ( this._isLoading && this._soundLoader != null ){
				try{
					this._soundLoader.close();					
				}catch( e:Error ){
				}
				
				_isFailed = _bytesLoaded != _bytesTotal && _bytesTotal != 0;
				
				dispatchEvent( new ResourceEvent( ResourceEvent.STOP, this ) );
				
				//并未真正完成需要重新加载
				onCompleteHandler( null, false );
			}			
		}
		
		override public function destroy():void
		{
			super.destroy();
			_soundLoader = null;
		}
		
		override protected function clearListeners() : void
		{
			if ( _soundLoader == null )
				return;
			
			_soundLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler );
			_soundLoader.removeEventListener(Event.COMPLETE, onCompleteHandler );
			_soundLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
//			_soundLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler );
			_soundLoader.removeEventListener(Event.OPEN, onOpenHandler );
			_soundLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
		}
		
		/**
		 *  true / false 两种
		 */		
		override public function set policy(value:*):void
		{
			if ( value == true ){
				_policy = true;	
			}else			
				_policy = false;
		}				
	}
}