package
{
	import flash.display.*;
	import flash.geom.Matrix;
	
	public class TestPaintBitmapData extends Sprite
	{
		[Embed(source='assets/moveto.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new gridClass() as Bitmap).bitmapData;
		
		public function TestPaintBitmapData()
		{
			super();
			
			if ( this.stage )
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			var data:BitmapData = TestPaintBitmapData.bitmapData;
			
			this.graphics.beginBitmapFill( data, new Matrix(), false);
//			this.graphics.drawRect( 96/2, 48/2, data.width, data.height );
//			this.graphics.drawRect( 0, 0, data.width, data.height );
//			this.graphics.drawRect( 0, 0, data.width * 2, data.height * 2);
			this.graphics.endFill();
			
			this.graphics.beginBitmapFill( data, new Matrix(), false);
			this.graphics.drawRect( 96/2, 48/2, data.width*2, data.height * 2);
			this.graphics.endFill();
			
		}
	}
}