package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source='assets/moveto.png')]
	public class MoveTile extends Bitmap  implements ITile
	{
		public function MoveTile()
		{
			super();
			this.cacheAsBitmap = true;
		}
	}
}