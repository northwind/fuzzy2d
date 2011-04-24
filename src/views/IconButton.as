package views
{
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	public class IconButton extends Sprite implements IDataSource 
	{
		public var tips:String;
		private var _resource:ImageResource;
		
		/**
		 * TODO dataresource 
		 */		
		private var _available:Boolean;
		
		public function IconButton( tips:String = null, bitmapData:BitmapData = null )
		{
			super();
			
			if ( bitmapData != null ){
				drawIcon( bitmapData );
			}
			
			this.tips = tips;
			
			this.cacheAsBitmap = true;
			this.buttonMode = true;
			this.useHandCursor = true;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown );
			this.addEventListener(MouseEvent.MOUSE_UP , onMouseUp );
		}
		
		public function set available( value:Boolean ) :void
		{
			_available = value;
		}
		
		public function get available() :Boolean
		{
			return _available;
		}
		
		public function set dataSource( value:IResource ) : void
		{
			_resource = value as ImageResource ;
			if ( _resource == null )
				return;
			
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
			if ( event.ok )
				onImageReady();
		}
		
		protected function onImageReady() : void
		{
			drawIcon( _resource.getBitmapData() );
		}
		
		public function drawIcon( bitmapData:BitmapData ) : void
		{
			if ( bitmapData == null )
				return;
			
			var g:Graphics = this.graphics;
			g.beginBitmapFill( bitmapData, new Matrix(), false, true );
			g.drawRect( 0, 0, bitmapData.width, bitmapData.height );
			g.endFill();
						
//			while( this.numChildren > 0 )
//				this.removeChildAt( 0 );
//			
//			this.addChild( new Bitmap( bitmapData ) );
		}
		
		public function get dataSource() : IResource
		{
			return _resource;
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			event.stopPropagation();
		}
		
	}
}