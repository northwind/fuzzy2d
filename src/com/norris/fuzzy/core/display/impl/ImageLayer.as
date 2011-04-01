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
			
			if ( this.view == null ){
				this.view = new Sprite();
				this.view.mouseEnabled = false;
				this.view.mouseChildren = false;
			}
			
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
//			this.view.addChild( _source.content as Bitmap );
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