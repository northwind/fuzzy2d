package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.log.Logger;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class DebugMsgLayer extends BaseLayer
	{
		private var textFormat:ElementFormat = new ElementFormat( new FontDescription() );
		private var block:TextBlock = new TextBlock();
		
		public var lineWidth:uint = 50;
		
		public function DebugMsgLayer()
		{
			super();
			
			this.view.mouseChildren = false;
			this.view.mouseEnabled = false;
			
		}
		
		public function showMsg( msg:String ) : void
		{
			if ( msg == null || msg == "" )
				return;
			
			Logger.debug( msg );
			
			block.content = new TextElement( msg,  textFormat );
			
			var line:TextLine = block.createTextLine( null, lineWidth );
			
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
			
			this.view.addChild( line );
		}
	}
}