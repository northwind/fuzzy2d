package controlers.core.display.impl
{
	import controlers.core.display.IDataSource;
	import controlers.core.display.ILayer;
	import controlers.core.resource.IResource;
	import controlers.core.resource.event.ResourceEvent;
	import controlers.core.resource.impl.ImageResource;
	import flash.events.Event;
	
	public class ImageLayer extends BaseLayer implements ILayer
	{
		private var _source:ImageResource;
		
		public function ImageLayer(pri:uint)
		{
			super(pri);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
		}
		
		/**
		 * TODO 未被添加，提前设置dataSource 
		 * @param value
		 * 
		 */		
		public function set dataSource( value:ImageResource ) : void
		{
			if ( _source != null ){
				_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			}
			
			_source = value;
			
			while( this.numChildren > 0 ){
				this.removeChildAt( 0 );
			}
			
			if ( _source.isFinish() ){
				this.addChild( _source.getBitmap() );
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
		}
		
		public function get dataSource() : ImageResource
		{
			return _source;
		}
		
	}
}