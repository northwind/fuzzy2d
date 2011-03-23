package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ImageLayer extends BaseLayer implements IDataSource
	{
		private var _source:IResource;
		
		public function ImageLayer()
		{
			super();
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
			
			if ( this.view == null )
				this.view = new Sprite();
			
			//先清空
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
			
			if ( _source.isFinish() ){
				onImageReady();
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		protected function onImageReady() : void
		{
			this.view.addChild( _source.content as Bitmap );
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