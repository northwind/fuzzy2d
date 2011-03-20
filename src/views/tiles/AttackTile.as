package views.tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	[Embed(source='assets/attack.png')]
	public class AttackTile extends Bitmap  implements ITile
	{
		public function AttackTile()
		{
			super();
			this.cacheAsBitmap = true;
		}
	}
}