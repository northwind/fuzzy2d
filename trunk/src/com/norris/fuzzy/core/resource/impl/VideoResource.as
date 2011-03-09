package com.norris.fuzzy.core.resource.impl
{
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoResource extends BaseResource implements IResource
	{
		private var nc:NetConnection;
		private var stream:NetStream;
		private var _metaData : Object;
		private var _video:Video;
		
		public function VideoResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override public function get content():*
		{
			return getStream();
		}
		
		public function getVideo():Video
		{
			if ( _video )
				return _video;
			
//			if ( _data == null )
//				return null;
			
			_video = new Video();
			_video.attachNetStream( stream );
			
			return _video;
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
			
			if (  stream == null )
				this.createLoader();
			
			_isFailed  = false;
			_isFinish  = false;
			_isLoading = true;
			
			try{
				stream.play( this._url , _policy);
			}catch( e : SecurityError){
				onSecurityErrorHandler( e );
			}	
			
			stream.seek(0);
			
		}
		
		override protected function createLoader() : void
		{
			nc = new NetConnection();
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
//			nc.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
			nc.connect(null);
			
			stream = new NetStream(nc);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus );
			
			var customClient:Object = new Object();
			customClient.onCuePoint = function(...args):void{};
			customClient.onMetaData = onVideoMetadata;
			customClient.onPlayStatus = function(...args):void{};
			stream.client = customClient;
		}
		
		private function onNetStatus(evt : NetStatusEvent) : void{
			if(!stream){
				return;
			}
			
//			trace( "evt.info.code = " + evt.info.code );
			if(evt.info.code == "NetStream.Buffer.Flush"){
				
				var event:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS );
				event.bytesTotal = stream.bytesTotal ;
				event.bytesLoaded = stream.bytesLoaded ;
				
				onProgressHandler( event );
				
			}else if(evt.info.code == "NetStream.Play.Start"){
				_data = stream;
				var e : Event = new Event(Event.OPEN);
				onOpenHandler(e);
			}else if(evt.info.code == "NetStream.Play.Stop"){
				stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus );
				
				onCompleteHandler();
				
			}else if(evt.info.code == "NetStream.Play.StreamNotFound"){
				onIOErrorHandler( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
			}
		}
		
		override protected function getContent( evt:Event = null ) : void
		{
			this._data = stream;
		}
		
		override public function reset():void
		{
			super.reset();
			stream = null;
			nc = null;
		}
		
		override public function close() : void
		{
			if ( this._isLoading && this.stream != null ){
				try{
					this.stream.close();
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
			nc = null;
			stream = null;
		}
		
		override protected function clearListeners() : void
		{
			if (stream) {
				stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler, false);
				stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false);
			}
			if ( nc ){
				nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				nc.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler );				
			}
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
		
		private function onVideoMetadata(evt : *):void{
			_metaData = evt;
		}
		
		public function get metaData() : Object { 
			return _metaData; 
		}
	}
}