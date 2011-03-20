package screens
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import screens.ISortable;
	
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
		
		public var view:Sprite;
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
			
			if ( this.view == null )
				this.view = new Sprite();
			
			this.view.x =  raw * 64;
			this.view.y =  col * 32;
			
			//先清空
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
			
			if ( _source.isFinish() ){
				this.view.addChild( _source.content as Bitmap );
			}else{
				_source.addEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
				_source.load();
			}
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_source.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			if ( event.ok )
				this.view.addChild( _source.content as Bitmap );
		}
		
		public function get dataSource() : IResource
		{
			return _source;
		}
	}
}