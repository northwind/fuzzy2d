package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class IconButton extends Sprite
	{
		public var tips:String;

		/**
		 * TODO dataresource 
		 */		
		private var _available:Boolean;
		
		public function IconButton( bitmapData:BitmapData = null, tips:String = null )
		{
			super();
			
			if ( bitmapData != null ){
				drawIcon( bitmapData );
			}
			
			this.tips = tips;
		}
		
		public function drawIcon( bitmapData:BitmapData ) : void
		{
			if ( bitmapData == null )
				return;
				
			var g:Graphics = this.graphics;
			g.beginBitmapFill( bitmapData, new Matrix(), false, true );
			g.drawRect( 0, 0, bitmapData.width, bitmapData.height );
			g.endFill();
		}
		
		public function set available( value:Boolean ) :void
		{
			_available = value;
		}
		
		public function get available() :Boolean
		{
			return _available;
		}
		
	}
}