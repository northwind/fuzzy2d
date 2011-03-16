package
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.log.impl.TraceWriter;
	import com.norris.fuzzy.core.display.IScreenManager;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	import com.norris.fuzzy.core.display.impl.BaseScreenManager;
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.log.impl.TextAreaWriter;
	import com.norris.fuzzy.core.resource.*;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.*;
	import com.norris.fuzzy.core.sound.ISounder;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
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
			
			var sm :IScreenManager = this.screenMgr;
			
			var first:BaseScreen = new BaseScreen();
			var second:BaseScreen = new BaseScreen();
			var third:BaseScreen = new BaseScreen();
			var fourth:BaseScreen = new BaseScreen();
			
			var bg1:ImageLayer = new ImageLayer();
			bg1.dataSource = new ImageResource( "a", "http://slgengine.sinaapp.com/test/friends.png", true );
			first.push( bg1 ); 
			
			var bg2:ImageLayer = new ImageLayer();
			bg2.dataSource = new ImageResource( "b", "http://slgengine.sinaapp.com/test/mission.png", true );
			second.push( bg2 ); 
			
			var bg3:ImageLayer = new ImageLayer();
			bg3.dataSource = new ImageResource( "c", "http://slgengine.sinaapp.com/test/ready.png", true );
			third.push( bg3 ); 
			
			var bg4:ImageLayer = new ImageLayer();
			bg4.dataSource = new ImageResource( "d", "http://slgengine.sinaapp.com/test/battle.png", true );
			fourth.push( bg4 ); 
			
			sm.add( "friends", first ); 
			sm.add( "mission", second );
			sm.add( "ready", third );
			sm.add( "battle", fourth );
			
			sm.goto("friends");
			
			var i:uint = 1;
			var screens:Array = [ "friends",  "mission", "ready", "battle" ];
			
			this.inputMgr.on( InputKey.ANYKEY, function( event:Event ) :void {
				if ( i == screens.length )
					i = 0;
				
				sm.goto( screens[ i++ ] );
				
			} );
			
			this.resourceMgr.add( "lin", "http://slgengine.sinaapp.com/test/lin.mp3", true );
			this.resourceMgr.load( "lin", null, function( event:ResourceEvent ) : void {
				Logger.debug( "lin sound loaded." );
				var sounder:ISounder = soundMgr.create( "lin", event.resource );
				
				soundMgr.loops( "lin", 2 );
				soundMgr.play( "lin" );
				
			} );
			
			var off:Boolean = true;
			this.inputMgr.on( InputKey.RIGHT , function( event:Event ) :void {
				soundMgr.mute( "lin", off );
				off = !off;
			} );
			
			var stoped:Boolean = false;
			this.inputMgr.on( InputKey.SPACE , function( event:Event ) :void {
				if ( stoped ){
					stoped = false;
					soundMgr.play( "lin" );
				}else{
					stoped = true;
					soundMgr.stop( "lin" );
				}
			} );
			
			this.inputMgr.on( InputKey.DOWN , function( event:Event ) :void {
				soundMgr.down( "lin", 0.1 );
			} );
			
			this.inputMgr.on( InputKey.UP , function( event:Event ) :void {
				soundMgr.up( "lin", 0.1 );
			} );
			
			this.inputMgr.on( InputKey.LEFT , function( event:Event ) :void {
				soundMgr.replay( "lin" );
			} );
			
		}
		
	}
}