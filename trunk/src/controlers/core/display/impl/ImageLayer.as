package controlers.core.display.impl
{
	import controlers.core.display.IDataSource;
	import controlers.core.display.ILayer;
	import controlers.core.resource.IResource;
	import controlers.core.resource.event.ResourceEvent;
	import controlers.core.resource.impl.ImageResource;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class ImageLayer extends BaseLayer implements ILayer, IDataSource
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
			
			while( this.numChildren > 0 ){
				this.removeChildAt( 0 );
			}
			
			if ( _source.isFinish() ){
				this.addChild( _source.content as Bitmap );
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			this.addChild( _source.content as Bitmap );
		}
		
		public function get dataSource() : IResource
		{
			return _source;
		}
		
	}
}