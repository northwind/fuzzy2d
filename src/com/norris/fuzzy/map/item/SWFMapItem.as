package com.norris.fuzzy.map.item
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	import com.norris.fuzzy.map.ISortable;
	
	public class SWFMapItem extends BaseMapItem implements ISortable, IDataSource
	{
		private var _resource:SWFResource;
		public var symbol:String;
		
		public function SWFMapItem( symbol:String = null )
		{
			super();
			this.symbol = symbol;
		}
		
		public function set dataSource(value:IResource):void
		{
			if ( !(value is SWFResource) )
				return;
			
			_resource = value as SWFResource;
			
			if ( _resource.isFinish() ){
				onContentReady();
			}else{
				_resource.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_resource.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			onContentReady();
		}
		
		protected function onContentReady() : void
		{
			if ( _resource.isFailed() )
				return;
			
			this._view = _resource.getMovieClip( symbol );
		}
		
		public function get dataSource():IResource
		{
			return _resource;
		}
	}
}