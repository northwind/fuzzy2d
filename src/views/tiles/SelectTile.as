package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source='assets/select.png')]
	public class SelectTile extends Bitmap  implements ITile
	{
		public function SelectTile()
		{
			super();
			this.cacheAsBitmap = true;
		}
	}
}