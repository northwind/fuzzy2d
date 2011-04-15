package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class LoadingLayer extends BaseLayer
	{
		[Embed("assets/loading.swf")]
		private const loadingClass:Class;
		
		private var textFiled:TextField;
		
		public function LoadingLayer()
		{
			super();
			
			this.view.addEventListener(Event.ADDED_TO_STAGE, onAdd );
			
		}
		
		private function onAdd( event:Event ) :void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onAdd );
			
			this.view.graphics.beginFill( 0x000000 );
			this.view.graphics.drawRect( 0, 0,  this.view.stage.stageWidth, this.view.stage.stageHeight );
			this.view.graphics.endFill();
			
			var loading:DisplayObject = new loadingClass() as DisplayObject;
			loading.x = ( this.view.stage.stageWidth - loading.width ) / 2;
			loading.y = ( this.view.stage.stageHeight - loading.height ) / 2;
			
			this.view.addChild( loading );
			
			textFiled = new TextField();
			textFiled.y = loading.y + 25;
			textFiled.textColor = 0xffffff;
			textFiled.selectable = false;
			
			this.view.addChild( textFiled );
		}
		
		public function addText( text:String ) :void
		{
			if ( textFiled == null || text == null )
				return;
			
			textFiled.text = text;
			textFiled.width = textFiled.textWidth + 4;
			textFiled.x = ( this.view.stage.stageWidth - textFiled.width ) / 2;
			
		}
	}
}