package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	
	import controlers.unit.Unit;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.utils.Timer;
	
	/**
	 *  
	 * @author norris
	 * 
	 */	
	public class TalkLayer extends BaseLayer
	{
		private var left:MovieClip;
		private var right:MovieClip;
		private var board:Sprite;			//黑板显示文字
		private var boardHeight:uint = 90;	//黑板高度 满足4行文字
		private var wordGroup:Array;		//当文字过长时分隔存储的字符串		
		private var fontSize:uint = 14;
		private var fontColor:uint = 0xffffff;
		private var timer:Timer;
		private var step:int = 14;
		private var typing:Boolean;			//打字中
		private var waiting:Boolean;		//等待用户输入
		
		private var font_description:FontDescription;
		
		public function TalkLayer()
		{
			super();
			
			board = new Sprite();
			timer = new Timer( 60 );
			timer.addEventListener(TimerEvent.TIMER, onTimer );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			this._view.addEventListener(Event.ADDED_TO_STAGE, onAdded );
		}
		
		private function onAdded(event:Event):void
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE, onAdded );
			
			MyWorld.instance.inputMgr.on( InputKey.ENTER, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.SPACE, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.ESCAPE, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.LEFT, onKeyDown );
		}
		
		/**
		 * 
		 * @param unit
		 * @param words {p}分页 {b}换行
		 * @param callback
		 * 
		 */		
		public function speak( unit:Unit, words:String, callback:Function = null ):void
		{
			var mc:MovieClip = unit.figure.avatar;
			mc.x = 5;
			mc.y = this._view.stage.stageHeight - mc.height;
			this._view.addChild( mc );
			left = mc;
			
			createBoard( words );
			
			index = 0;
			this.callback = callback;
			
			showWords( wordGroup[ 0 ] );
		}
		
		private var callback:Function;
		private var index:int;		//第几页
		private function showWords( content:String ):void
		{
			var element_format:ElementFormat;
			element_format = new ElementFormat(font_description);
			element_format.fontSize= fontSize;
			element_format.kerning= Kerning.ON;
			element_format.color = fontColor;
			
			var text_element:TextElement=new TextElement( content , element_format );
			text_block = new TextBlock();
			text_block.content=text_element;
			
			var textLine:TextLine = text_block.createTextLine (null, board.width - 20 );
			
			totalH = 0;
			typing = true;	//打字中
			waiting = false;
			
			animateTextLine( textLine );
		}
		
		private var text_block:TextBlock;
		private var currentLine:TextLine;
		private var cursor:int;
		private var totalH:int = 0;
		
		private function animateTextLine( textLine:TextLine ) :void
		{
			//设置显示位置
			textLine.x = 10;
			textLine.y = -5 + totalH;
			textLine.height = 16;
			
			totalH += textLine.height + 6;
			
			currentLine = textLine;
			currentLine.scrollRect = new Rectangle( 0, 0, 0, 0 );
			board.addChild(textLine);
			cursor = 0;
			
			//设置循环次数
			timer.reset();
			timer.repeatCount = currentLine.textWidth / step + 1;
			timer.start();
		}
		
		protected function onTimer(event:Event):void
		{
			currentLine.scrollRect = new Rectangle( 0, -20, cursor += step , 30 );
		}
		
		protected function onTimerComplete(event:Event):void
		{
			currentLine = currentLine.textBlock.createTextLine( currentLine, currentLine.specifiedWidth );
			if ( currentLine )
				animateTextLine( currentLine ); 
			else{
				//没有下一行可以显示了
				typing = false;
				waiting = true;		//等待用户输入
			}
		}
		
		//响应用户操作
		private function onKeyDown( event:Event ):void
		{
			if ( waiting ){
				if ( ++index == wordGroup.length ){
					//清除显示
					clear();
					
					//全部显示完毕
					if ( callback != null )
						callback();
				}else{
					//继续下一页
					showWords( wordGroup[ index ] );
				}
			}
			
			//用户等不及了，想一下子都展示出来
			if ( typing ){
				
				while( board.numChildren > 0 )
					board.removeChildAt( 0 );
				
				var textLine:TextLine = text_block.createTextLine (null, board.width - 20 );
				totalH = 0;
				
				while( textLine ){
					textLine.x = 10;
					textLine.y = -5 + totalH;
					textLine.height = 16;
					totalH += textLine.height + 6;
					board.addChild(textLine);
					
					textLine = textLine.textBlock.createTextLine( textLine, textLine.specifiedWidth );
				}
				
				typing = false;
				waiting = true;
			}
		}
		
		private function clear():void
		{
			while( this._view.numChildren > 0 )
				this._view.removeChildAt( 0 );
		}
		
		private function createBoard( words:String ):void
		{
			var w:int =  this._view.stage.stageWidth;
			
			if ( left != null ){
				w -= left.width;
				board.x = left.width;
			}
			if ( right != null )
				w -= right.width;
			
			while( board.numChildren > 0 )
				board.removeChildAt( 0 );
			
			board.graphics.beginFill( 0x000000, 0.6 );
			board.graphics.drawRect(0,0, w, boardHeight );
			board.graphics.endFill();
			
			board.y = this._view.stage.stageHeight - boardHeight; 
			
			this._view.addChild( board );
			
			//切割字符串
			wordGroup = [];
			var count:int = ( w - 20 ) / fontSize;
			count *= 4;
			var i:int, pages:Array = words.split( "{p}" );
			for each (var str:String in pages) {
				for ( i = 0; i < str.length; i+= count )
				{
					wordGroup.push( str.substr( i, count ) );
				}
			}

			trace( "wordGroup.length = " + wordGroup.length );
		}
		
		
		/**
		 * 多角色间对话 
		 * @param dialogues  [ [ unit, words ], [ ... ], ... ]
		 * @param callback
		 * @return 
		 * 
		 */		
		public function dialogue( dialogues:Array, callback:Function ):void
		{
			
		}
		
		/**
		 * 角色提出选择 
		 * @param unit
		 * @param options  [ [value, content], [...], ... ]
		 * @param callback
		 * 
		 */		
		public function select( unit:Unit, options:Array, callback:Function ):void
		{
			
		}
		
	}
}