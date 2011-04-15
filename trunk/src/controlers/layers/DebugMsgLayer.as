package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.log.Logger;
	
	import flash.text.TextField;
	
	public class DebugMsgLayer extends BaseLayer
	{
		private var text:TextField = new TextField();
		
		public function DebugMsgLayer()
		{
			super();
			
			this.view.mouseChildren = false;
			this.view.mouseEnabled = false;
			
			text.textColor = 0xffffff;
//			text.backgroundColor = 0x000000;
			text.x = 10;
			text.y = 40;
			
			this.view.addChild( text );
		}
		
		public function showMsg( msg:String ) : void
		{
			if ( msg == null || msg == "" )
				return;
			
			text.text = msg;
		}
	}
}