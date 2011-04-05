package com.norris.fuzzy.map.item
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	import com.norris.fuzzy.map.ISortable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	public class ImageMapItem extends BaseMapItem implements ISortable, IDataSource
	{
		private var _resource:ImageResource;
		
		public function ImageMapItem()
		{
			super();
		}
		
		public function set dataSource(value:IResource):void
		{
			if ( _resource != null ){
				_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			}
			
			if ( !(value is ImageResource) )
				return;
			
			_resource = value as ImageResource;
			
			if ( _resource.isFinish() ){
				onImageReady();
			}else{
				_resource.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_resource.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			onImageReady();
		}
		
		protected function onImageReady() : void
		{
			if ( _resource.isFailed() )
				return;
			
			var bitmapData:BitmapData = _resource.getBitmapData();
			this._view = new Bitmap( bitmapData );
		}
		
		public function get dataSource():IResource
		{
			return _resource;
		}
	}
}