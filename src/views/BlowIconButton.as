package views
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class BlowIconButton extends IconButton
	{
		public function BlowIconButton(tips:String=null, bitmapData:BitmapData=null )
		{
			super(tips, bitmapData);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		protected function onRollOver(event:MouseEvent):void
		{
			//TODO 周边颜色渲染
//			this.filters = [ ];
		}
		
		protected function onRollOut(event:MouseEvent):void
		{
//			this.scaleX = 1;
//			this.scaleY = 1;
			this.filters = [];
		}
		
		
	}
}