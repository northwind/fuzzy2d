package views.tiles
{
	import flash.display.Bitmap;
	
	[Embed(source='assets/grid.png')]
	public class GridTile extends Bitmap implements ITile
	{
		public function GridTile()
		{
			this.cacheAsBitmap = true;
		}
	}
}