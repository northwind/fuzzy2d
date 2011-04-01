package views.tiles
{
	import flash.display.Bitmap;
	
	[Embed(source='assets/grid2.png')]
	public class DebugTile extends Bitmap implements ITile
	{
		public function DebugTile()
		{
			this.cacheAsBitmap = true;
		}
	}
}