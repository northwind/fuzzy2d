package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	import controlers.core.resource.event.ResourceEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class ImageResource extends BaseResource implements IResource
	{
		private var _imageLoader:Loader;
		
		public function ImageResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
			this.policy = policy;
		}
		
		override public function get content():*
		{
			return getBitmap();
		}
		
		public function getBitmap() :Bitmap
		{
			if ( _data == null )
				return null;
			
			return _data as Bitmap;
		}
		
		public function getBitmapData() :BitmapData
		{
			if ( _data == null )
				return null;
			
			return (_data as Bitmap).bitmapData;
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
			
			if ( _imageLoader == null )
				this.createLoader();
			
			_isFailed  = false;
			_isFinish  = false;
			_isLoading = true;
			
			try{
				_imageLoader.load( _request, _policy );
			}catch( e : SecurityError){
				onSecurityErrorHandler( e );
			}	
			
		}
		
		override protected function createLoader() : void
		{
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
//			_imageLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			_imageLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpenHandler);
		}
		
		override protected function getContent( evt:Event = null ) : void
		{
			if ( !_isFailed ){
				try{
					this._data = _imageLoader.content;
				}catch( e : SecurityError ){
					this._data = null;
					
					onSecurityErrorHandler( e, false );
				}
			}
			else
				this._data = null;
		}
		
		override public function reset():void
		{
			super.reset();
			_imageLoader = null;
		}
		
		override public function close() : void
		{
			if ( this._isLoading && this._imageLoader != null ){
				try{
					this._imageLoader.close();					
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
			_imageLoader = null;
		}
		
		override protected function clearListeners() : void
		{
			if ( _imageLoader == null )
				return;
			
			_imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler );
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler );
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
//			_imageLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler );
			_imageLoader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpenHandler );			
		}
		
		/**
		 * true时，创建一默认的 LoaderContext
		 * @param value
		 * 
		 */		
		override public function set policy(value:*):void
		{
			if ( value == true ){
				_policy = new LoaderContext( true );	
			}else if ( value is LoaderContext ){
				_policy = value;
			}else			
				_policy = null;
		}
	}
}