package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class DebugNumberTile extends Sprite implements ITile
	{
		[Embed(source='assets/grid2.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new DebugNumberTile.gridClass() as Bitmap).bitmapData;
		
		public static const textFormat:ElementFormat = new ElementFormat( new FontDescription() ); 
		
		public function DebugNumberTile( x:int, y:int )
		{
			this.cacheAsBitmap = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			var block:TextBlock = new TextBlock();
			block.content = new TextElement(  x + "," + y, DebugNumberTile.textFormat );
			var line:TextLine = block.createTextLine( null, 50 );
			
			line.x = 35;
			line.y = 25;
			
			addChild( line );
			
			this.graphics.beginBitmapFill( DebugNumberTile.bitmapData, null, false );
			this.graphics.drawRect( 0,0, DebugNumberTile.bitmapData.width, DebugNumberTile.bitmapData.height );
			this.graphics.endFill();
		}
	}
}