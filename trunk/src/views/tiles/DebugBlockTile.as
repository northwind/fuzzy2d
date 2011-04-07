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
	
	public class DebugBlockTile extends Sprite implements ITile
	{
		[Embed(source='assets/grid2.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new DebugBlockTile.gridClass() as Bitmap).bitmapData;
		
		[Embed(source='assets/attack.png')]
		public static const blockClass:Class;
		public static const blockBitmapData:BitmapData = (new DebugBlockTile.blockClass() as Bitmap).bitmapData;
		
		public static const textFormat:ElementFormat = new ElementFormat( new FontDescription() ); 
		
		public function DebugBlockTile( x:int, y:int, block:Boolean = false )
		{
			this.cacheAsBitmap = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			var textBlock:TextBlock = new TextBlock();
			textBlock.content = new TextElement(  x + "," + y, DebugBlockTile.textFormat );
			var line:TextLine = textBlock.createTextLine( null, 50 );
			
			line.x = 35;
			line.y = 25;
			
			addChild( line );
			
			var data:BitmapData = block ? blockBitmapData : bitmapData;
			
			this.graphics.beginBitmapFill( data, null, false );
			this.graphics.drawRect( 0,0, data.width, data.height );
			this.graphics.endFill();
		}
	}
}