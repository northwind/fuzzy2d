package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ImageLayer extends BaseLayer implements IDataSource
	{
		private var _source:IResource;
		
		public function ImageLayer()
		{
			super();
			
			this.view.mouseEnabled = false;
			this.view.mouseChildren = false;
		}
		
		/**
		 * @param value
		 * 
		 */		
		public function set dataSource( value:IResource ) : void
		{
			if ( _source != null ){
				_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			}
			
			_source = value;
			
			if ( _source.isFinish() ){
				onImageReady();
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		protected function onImageReady() : void
		{
			var bitmapData:BitmapData = (_source as ImageResource).getBitmapData();
			this.view.graphics.beginBitmapFill( bitmapData, null, false );
			this.view.graphics.drawRect( 0, 0, bitmapData.width, bitmapData.height );
			this.view.graphics.endFill();
			
//			if ( this.view.stage )
//				onStage();
//			else
//				this.view.addEventListener(Event.ADDED_TO_STAGE, onStage );
		}
		
		private function onStage( event:Event = null ) :void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onStage );
			
			var bitmapData:BitmapData = (_source as ImageResource).getBitmapData();
			this.view.graphics.beginBitmapFill( bitmapData, null, false );
			this.view.graphics.drawRect( 0, 0, bitmapData.width, bitmapData.height );
			this.view.graphics.endFill();
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			if ( event.ok )
				onImageReady();
		}
		
		public function get dataSource() : IResource
		{
			return _source;
		}
		
	}
}