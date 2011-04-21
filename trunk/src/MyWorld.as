package
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.display.IScreenManager;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	import com.norris.fuzzy.core.display.impl.BaseScreenManager;
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.log.impl.TextAreaWriter;
	import com.norris.fuzzy.core.log.impl.TraceWriter;
	import com.norris.fuzzy.core.resource.*;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.*;
	import com.norris.fuzzy.core.sound.ISounder;
	import com.norris.fuzzy.map.Isometric;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import controlers.screens.BattleScreen;
	import controlers.screens.LoadingScreen;
	
	public class MyWorld extends World
	{
		private var loadingScreen:LoadingScreen;
		
		public static const CELL_WIDTH :uint = 96;		//单元格宽度
		public static const CELL_HEIGHT :uint = 48;     //单元格高度
		
		public static var isometric:Isometric = new Isometric( 30, 45 );		//换算工具
		//2.5D世界中宽和高
		public static var TILE_WIDTH:Number = isometric.mapToIsoWorld( MyWorld.CELL_WIDTH, 0 ).x;
		public static var TILE_HEIGHT:Number = MyWorld.TILE_WIDTH;		//等距
		
		public static var instance:MyWorld ;
		
		public function MyWorld()
		{
			super();
			
			Logger.init( new TraceWriter() );
			
			MyWorld.instance = this;
		}
		
		override public function init(  area:Sprite  ) : void
		{
			super.init( area );
			
			this.area.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		private  function onAddStage( event:Event )  : void
		{
			this.area.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			this.area.x = ( this.area.stage.stageWidth - this.area.width ) / 2;
			this.area.y = ( this.area.stage.stageHeight - this.area.height ) / 2;
		}
		
		public function showLoading() :void
		{
			if ( loadingScreen == null ){
				loadingScreen = new LoadingScreen();
				loadingScreen.setup();
				
				this.screenMgr.add( "loading", loadingScreen );
			}
			
			this.screenMgr.goto( "loading" );
		}
		
		public function addLoadingText( text:String ) :void
		{
			if ( loadingScreen == null )
				return;
			
			loadingScreen.addText( text );
		}
		
		/**
		 *   3d 换算为 屏幕对应的位置
		 * @return 
		 * 
		 */		
		public static function mapToScreen( x:int, y:int ) :Coordinate
		{
			return MyWorld.isometric.mapToScreen( 
				x * MyWorld.TILE_WIDTH , 0, -y * MyWorld.TILE_HEIGHT  );
		}
		/**
		 *   屏幕位置对应的3D单元格位置
		 * @return 
		 * 
		 */		
		public static function mapToIsoWorld( x:Number, y:Number ) :Coordinate
		{
			var coord:Coordinate = MyWorld.isometric.mapToIsoWorld( x, y );
			coord.x = Math.floor(coord.x / MyWorld.TILE_WIDTH);
			coord.y = Math.floor(Math.abs(coord.z / MyWorld.TILE_HEIGHT)) ;
			
			return coord;
		}
	}
}