package controlers.core.debug.impl
{
	import controlers.core.debug.IConsole;
	import controlers.core.display.impl.BaseDisplay;
	import controlers.core.log.Logger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.ui.Keyboard;
	
	public class BaseConsole extends BaseDisplay implements IConsole
	{
		private var textField:TextField;
		private var minH :int = 200;
		private var minW :int = 400;
		private var callback:Function;
		private var content:String;
		private var font_description:FontDescription;
		private var resultSprite:Sprite;
		
		public function BaseConsole()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			minW = Math.max( this.stage.width - 10, minW );
			minH = Math.max( this.stage.height / 3 , minH );
			
			this.x = 5;
			this.y = 0;
			
			font_description = new FontDescription();
			font_description.fontName="_typewriter";
			font_description.renderingMode=RenderingMode.CFF;
			
			graphics.beginFill(0x00, 0.8);
			graphics.drawRect(0, 0, minW , 30 );
			graphics.endFill();
			
			createResultSprite();
			createInputField();
		}
		
		override protected function onShow() : void
		{
			if ( textField != null )
				this.stage.focus = textField;
		}
		
		protected function createResultSprite(): void
		{
			resultSprite = new Sprite();
			resultSprite.y = 30;
			
			this.addChild( resultSprite );
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
			format.size = 12;
			format.color = 0xFFFFFF;
			textField.setTextFormat(format);
			textField.defaultTextFormat = format;
			textField.name = "ConsoleInput";
			
			textField.height = 18;
			textField.y = 2;
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
		
		public function onEnter( callback:Function ) : void
		{
			this.callback = callback;
		}
		
		private function createLines( textBlock : TextBlock, startX : int, startY : int ) : void
		{
			var textLine:TextLine = textBlock.createTextLine (null, width);
			var totalH : int = 0 ;
			while (textLine)
			{
				textLine.x = startX;
				textLine.y = startY + totalH;
				totalH += textLine.height + 6;
				resultSprite.addChild(textLine);
				textLine = textBlock.createTextLine (textLine, minW );
			}
			
			resultSprite.graphics.beginFill(0x00, 0.8);
			resultSprite.graphics.drawRect(0, 0, minW , totalH + 10 );
			resultSprite.graphics.endFill();			
		}

		public function writeLine(content:String, color:uint = 0xffffff ):void
		{
			this.content = content;
			this.clear();
			
			var element_format:ElementFormat;
			element_format = new ElementFormat(font_description);
			element_format.fontSize=12;
			element_format.kerning=Kerning.ON;
			element_format.alpha=1;
			element_format.color = color;
			
			var text_element:TextElement=new TextElement( content , element_format);
			var text_block:TextBlock = new TextBlock();
			text_block.content=text_element;
			createLines(text_block, 15, 10 );			
		}
		
		public function clear():void
		{
			//delete children
			while ( resultSprite.numChildren > 0 ){
				resultSprite.removeChildAt( 0 );
			}			
			resultSprite.graphics.clear();
		}
		
		public function getContent():String
		{
			return this.content;
		}
	}
}