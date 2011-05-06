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
	import flash.utils.Timer;
	
	/**
	 * 显示角色间的对话
	 * textLine.scrollRect有错误 
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
		private var margin:int = 5;
		
		private var font_description:FontDescription;
		private var text_block:TextBlock;
		private var text_element:TextElement;
		private var text_format:ElementFormat;
		
		public function TalkLayer()
		{
			super();
			
			board = new Sprite();
			timer = new Timer( 60 );
			timer.addEventListener(TimerEvent.TIMER, onTimer );
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );

			font_description = new FontDescription( "_serif", FontWeight.BOLD );
			text_format = new ElementFormat(font_description, fontSize, fontColor );
			
			this._view.addEventListener(Event.ADDED_TO_STAGE, onAdded );
		}
		
		private function onAdded(event:Event):void
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE, onAdded );
			
			MyWorld.instance.inputMgr.on( InputKey.ENTER, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.SPACE, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.ESCAPE, onKeyDown );
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_LEFT, onKeyDown );
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
			mc.x = margin;
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
			while( board.numChildren > 0 )
				board.removeChildAt( 0 );
			
			text_element = new TextElement( content , text_format );
			text_block = new TextBlock( text_element );
			
			var textLine:TextLine = text_block.createTextLine (null, board.width - 20 );
			totalH = 0;
			typing = true;	//打字中
			waiting = false;
			
			animateTextLine( textLine );
		}
		
		private var currentLine:TextLine;
		private var cursor:int;
		private var totalH:int = 0;
		
		private function animateTextLine( textLine:TextLine ) :void
		{
			currentLine = textLine;
			currentLine.scrollRect = new Rectangle( 0, 0, 0, 0 );
			board.addChild(textLine);
			
			//设置显示位置
			textLine.x = 10;
			
			totalH += -margin + textLine.ascent;
			textLine.y = totalH;
			totalH += 13;
			
			cursor = 0;
			
			//设置循环次数
			timer.reset();
			timer.repeatCount = currentLine.textWidth / step + 1;
			timer.start();
		}
		
		protected function onTimer(event:Event):void
		{
			currentLine.scrollRect = new Rectangle( 0, -15, cursor += step , 30 );
		}
		
		protected function onTimerComplete(event:Event):void
		{
			currentLine = text_block.createTextLine( currentLine,  board.width - 20 );
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
				waiting = false;
				
				if ( ++index == wordGroup.length ){
					//清除显示
					clear();
					
					//全部显示完毕
					if ( callback != null )
						callback();
				}else{
					//继续下一页
					showWords( wordGroup[ index ] );
					return;		//don't run the typing case!
				}
			}
			
			//用户等不及了，想一下子都展示出来
			if ( typing ){
				typing = false;
				
				timer.stop();
				
				while( board.numChildren > 0 )
					board.removeChildAt( 0 );
					
				currentLine = text_block.createTextLine( null, board.width - 20 );
				totalH = 0;
				
				while( currentLine ){
					currentLine.x = 10;
					board.addChild(currentLine);
					
					totalH += -margin + currentLine.ascent;
					currentLine.y = totalH;
					totalH += 13;
					
					currentLine.scrollRect = new Rectangle( 0, -15, currentLine.width , 30 ); 
					
					currentLine = text_block.createTextLine( currentLine, currentLine.specifiedWidth );
				}
				
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
			var w:int =  this._view.stage.stageWidth - 10;
			
			board.x = margin;
			if ( left != null ){
				w = w - left.width - margin;
				board.x += left.width + margin;
			}
			if ( right != null )
				w = w - right.width - margin;
			
			board.graphics.clear();
			board.graphics.beginFill( 0x000000, 0.5 );
			board.graphics.drawRoundRect( 0,0, w, boardHeight, 10, 10 );
			board.graphics.endFill();
			
			this._view.addChild( board );
			board.y = this._view.stage.stageHeight - boardHeight; 
			board.height = boardHeight;
			
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