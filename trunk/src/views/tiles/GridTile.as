package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
//	[Embed(source='assets/grid.png')]
	[Embed(source='assets/grid2.png')]
	public class GridTile extends Bitmap implements ITile
	{
		public function GridTile()
		{
			super();
			this.cacheAsBitmap = true;
		}
	}
}