package controlers.screens
{
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	
	import controlers.layers.LoadingLayer;
	
	public class LoadingScreen extends BaseScreen
	{
		private var loadingLayer:LoadingLayer = new LoadingLayer();
		
		public function LoadingScreen()
		{
			super();
			
			this.push( loadingLayer );
		}
		
		public function addText( text:String ) :void
		{
			loadingLayer.addText( text );
		}
		
	}
}