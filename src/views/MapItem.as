package views
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import com.norris.fuzzy.map.ISortable;
	
	public class MapItem implements IDataSource
	{
		public var define:String = "";		//定义名
		public var src:String = "";			//资源地址
		
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		
		public var cols:uint = 0;
		public var raws:uint = 0;
		
		public var col:int = -1;
		public var raw:int = -1;
		
		public var walkable:Boolean = false;
		public var overlap:Boolean = false;
		
		public var view:DisplayObject;
		private var _source:IResource;
		
		public function MapItem()
		{
			super();
		}
		
		public function set dataSource( value:IResource ) : void
		{
			if ( _source != null ){
				_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			}
			
			_source = value;
			
			if ( _source.isFinish() ){
				onResourceComplete();
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent = null ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			
			if ( !_source.isFailed() )
				this.view = _source.content as DisplayObject;
		}
		
		public function get dataSource() : IResource
		{
			return _source;
		}
	}
}