package com.norris.fuzzy.core.resource.impl
{
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.log.Logger;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class SWFResource extends BaseResource implements IResource
	{
		private var _clip:MovieClip;
		private var _appDomain:ApplicationDomain;
		private var _swfLoader:Loader;
		
		public function SWFResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
			this.policy = policy;
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
			
			if ( _swfLoader == null )
				this.createLoader();
			
			_isFailed  = false;
			_isFinish  = false;
			_isLoading = true;
			
			try{
				_swfLoader.load( _request, _policy );
			}catch( e : SecurityError){
				onSecurityErrorHandler( e );
			}	
			
		}
		
		override protected function createLoader() : void
		{
			_swfLoader = new Loader();
			_swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			_swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			//			_swfLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			_swfLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpenHandler);
		}
		
		override protected function getContent( evt:Event = null ) : void
		{
			if ( !_isFailed ){
				try{
					this._data = _swfLoader.content;
					
					// Get the app domain...
					if (_swfLoader && _swfLoader.contentLoaderInfo)
						_appDomain = _swfLoader.contentLoaderInfo.applicationDomain;
					else if(_data && _data.loaderInfo)
						_appDomain = _data.loaderInfo.applicationDomain;		
					
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
			_swfLoader = null;
		}
		
		override public function close() : void
		{
			if ( this._isLoading && this._swfLoader != null ){
				try{
					this._swfLoader.close();					
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
			_swfLoader = null;
		}
		
		override protected function clearListeners() : void
		{
			if ( _swfLoader == null )
				return;
			
			_swfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler );
			_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler );
			_swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
			//			_swfLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler );
			_swfLoader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpenHandler );			
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
		
		override public function get content():*
		{
			return getMovieClip();
		}
		
		public function getMovieClip( symbol:String = null ) : MovieClip
		{
			if ( symbol == null ){
				return this._data as MovieClip;
			}
			else{
				var m:MovieClip;
				try{
					m = new (getSymbol( symbol )) as MovieClip;					
				}catch( e:Error ){
					Logger.error(  this.name + " has no symbol : " + symbol );
					m = new MovieClip();
				}
				return m;
			}
		}
		
		public function getSymbol( symbol:String ) :Class
		{
			if (null == _appDomain) 
				throw new Error("not initialized");
			
			var clazz:Class;
			if (_appDomain.hasDefinition(symbol)){
				try{
					clazz = _appDomain.getDefinition(symbol) as Class;
				}catch( e:Error ){
					clazz = null;
				}
			}
			else{
				clazz = null;
			}
			
			return clazz;
		}
		
	}
}