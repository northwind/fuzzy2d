package views
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class BlowIconButton extends IconButton
	{
		public static var growFilter:GlowFilter = new GlowFilter( 0x33CCFF, 0.8, 30,30, 2,1,false,false);
		
		public function BlowIconButton(tips:String=null, bitmapData:BitmapData=null )
		{
			super(tips, bitmapData);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			//TODO 周边颜色渲染
			this.filters = [ BlowIconButton.growFilter ];
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
			this.filters = [];
		}
		
		
	}
}