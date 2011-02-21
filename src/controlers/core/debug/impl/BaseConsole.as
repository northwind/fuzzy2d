package controlers.core.debug.impl
{
	import controlers.core.debug.IConsole;
	import controlers.core.display.impl.BaseDisplay;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class BaseConsole extends BaseDisplay implements IConsole
	{
		private var textField:TextField;
		private var minH :int = 400;
		private var minW :int = 400;
		
		public function BaseConsole()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			minW = Math.max( this.stage.width - 10, minW );
			minH = Math.max( this.stage.height / 2 , minH );
			
			this.x = 5;
			this.y = 0;
			
			graphics.beginFill(0x00);
			graphics.drawRect(0, 0, minW , minH);
			graphics.endFill();
			
			
			createInputField();
		}
		
		protected function createInputField(): void
		{
			textField = new TextField();
			textField.type = TextFieldType.INPUT;
			textField.border = true;
			textField.borderColor = 0xCCCCCC;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.condenseWhite = false;
			var format:TextFormat = textField.getTextFormat();
			format.font = "_typewriter";
			format.size = 11;
			format.color = 0xFFFFFF;
			textField.setTextFormat(format);
			textField.defaultTextFormat = format;
			textField.name = "ConsoleInput";
			
			textField.height = 18;
			textField.y = minH - 20;
			textField.x = 5;
			textField.width = minW -10;
			
			
			textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 1, true);
			
			this.addChild( textField );
		}			
		
		private function onKeyDown( event:KeyboardEvent  ) : void
		{
			var code:uint = event.keyCode;
			if ( code ==  Keyboard.ENTER ){
				if ( this.callback != null ) {
					this.callback( textField.text );
					textField.text = "";
				}
			}
		}
		
		private var callback:Function;
		public function onEnter( callback:Function ) : void
		{
			this.callback = callback;
		}
		
		public function writeLine(content:String):void
		{
		}
		
		public function clear():void
		{
		}
		
		public function getContent():String
		{
			return null;
		}
	}
}