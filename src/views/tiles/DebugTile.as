package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class DebugTile extends Sprite implements ITile
	{
		[Embed(source='assets/grid2.png')]
		private var gridClass:Class;
		
		public function DebugTile( x:int, y:int )
		{
			super();
			this.cacheAsBitmap = true;
			
			var text:TextField = new TextField();
			text.text = x + "," + y;
			text.width = text.textWidth + 4;
			text.height = text.textHeight + 3;
			text.mouseEnabled = false;
			text.mouseWheelEnabled = false;
			
			this.addChild( text );
			
			this.addChild( new gridClass() as DisplayObject );
			
			text.x = (this.width - text.width) / 2;
			text.y = ( this.height - text.height ) / 2;
		}
	}
}