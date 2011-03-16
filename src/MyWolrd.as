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
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import screens.BattleScreen;
	
	public class MyWolrd extends World
	{
		public function MyWolrd()
		{
			super();
			
			Logger.init( new TraceWriter() );
		}
		
		override public function init(  area:Sprite  ) : void
		{
			super.init( area );
			
			var battle:BattleScreen = new BattleScreen();
			battle.setup();
			battle.loadData();
			
			this.screenMgr.add( "battle", battle );
			
			this.screenMgr.goto("battle");
		}
	}
}