package views.tiles
{
	import flash.display.Bitmap;
	
	[Embed(source='assets/select.png')]
	public class MoveTile extends Bitmap  implements ITile
	{
		public function MoveTile()
		{
			this.cacheAsBitmap = true;
		}
	}
}