package controlers.core.display.impl
{
	import controlers.core.display.IDisplay;
	
	import events.DisplayEvent;
	
	import flash.display.Sprite;
	
	public class BaseDisplay extends Sprite implements IDisplay
	{
		public function BaseDisplay()
		{
			super();
		}
		
		public function show():void
		{
			if ( this.visible == false ){
				this.visible = true;
				
				this.onShow();
				
				this.dispatchEvent( new DisplayEvent( DisplayEvent.SHOW ) );
			}
		}
		
		protected function onShow() : void
		{
		}
		
		public function hide():void
		{
			if ( this.visible == true ){
				this.visible = false;
				
				this.onHide();
				
				this.dispatchEvent( new DisplayEvent( DisplayEvent.HIDE ) );
			}			
		}
		
		protected function onHide() : void
		{
		}
		
		public function toggle() : void
		{
			this.visible == true ? hide() : show();
		}
		
		public function destroy():void
		{
			this.onDestroy();
			
			this.dispatchEvent( new DisplayEvent( DisplayEvent.DESTROY ) );
		}
		
		protected function onDestroy() : void
		{
		}
	}
}