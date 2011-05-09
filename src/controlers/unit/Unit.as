package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.ComponentEntity;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	
	import controlers.events.UnitEvent;
	import controlers.layers.UnitsLayer;
	import controlers.unit.impl.BaseFigure;
	import controlers.unit.impl.UnitModelComponent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.impl.UnitModel;
	
	[Event(name="move", type="controlers.events.UnitEvent")]
	
	[Event(name="move_over", type="controlers.events.UnitEvent")]
	
	[Event(name="standby", type="controlers.events.UnitEvent")]
	
	[Event(name="dead", type="controlers.events.UnitEvent")]
	
	[Event(name="start", type="controlers.events.UnitEvent")]
	
	[Event(name="speak", type="controlers.events.UnitEvent")]
	
	[Event(name="appear", type="controlers.events.UnitEvent")]
	/**
	 *  TODO mapItem做为unit的view
	 * @author norris
	 * 
	 */	
	public class Unit extends ComponentEntity
	{
		public var figure:IFigure;
		public var model:UnitModelComponent;
		public var moveable:IMoveable;
		public var attackable:IAttackable;
		
		public var skills:Array = [];
		public var stuffs:Array = [];
		public var layer:UnitsLayer;
		public var node:Node;
		public var isStandby:Boolean;
		
		private var timer:Timer = new Timer( 200, 1 );
		private var callback:Function;
		
		public function Unit( model:UnitModelComponent = null )
		{
			super();
			
			if ( model != null )
				this.addComponent( model );
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted );
		}
		
		public function restore() : void
		{
			isStandby = false;
		}
		
		public function standby( callback:Function = null ) : void
		{
			this.model.standby(0,0);
			this.figure.gray();
			isStandby = true;
			
			this.callback = callback;
			
			timer.reset();
			timer.start();
		}
		
		private function onTimerCompleted(event:Event):void
		{
			if ( callback != null ){
				callback();
				callback = null;
			}
			
			this.dispatchEvent( new UnitEvent( UnitEvent.STANDBY, this ) );
		}
		
		public function select() : void
		{
			figure.highlight();
			
			layer.actionLayer.bind( this );
			layer.actionLayer.beginAction();
			
//			layer.tipsLayer.topTip( "哦耶，我被选中了.童话：从前有只没有名字的兔子，总是喜欢跟小动物们说各种冷笑话，并把别人的冷笑话当成自己的，还宣称它讲的冷笑话是全世界最独一无二的。有一天，当老虎发现兔子在私下里说，兔子才是森林里说话最有价值的群体，还能靠说笑话赚钱，老虎就生气把兔子吃掉了，但这样的兔子还有好多好多。科学家经过检测，发现地球周围确实存在时空漩涡，其各项参数和爱因斯坦广义相对论预言的完全符合。根据爱因斯坦的相对论，空间和时间是交织在一起的，形成一种被他称为“时空”的四维结构。地球的质量会在这种结构上产生“凹陷”，这很像是一个成年人站在蹦床上陷进去的情形.{p}还能靠说笑话赚钱，老虎就生气把兔子吃掉了，但这样的兔子还有好多好多。" );
			layer.tipsLayer.topTip( "哦耶，我被选中了." );
			
			layer.talkLayer.speak( this, "哦耶，我被选中了.童话：从前有只没有名字的兔子，总是喜欢跟小动物们说各种冷笑话，并把别人的冷笑话当成自己的，还宣称它讲的冷笑话是全世界最独一无二的。有一天，当老虎发现兔子在私下里说，兔子才是森林里说话最有价值的群体，还能靠说笑话赚钱，老虎就生气把兔子吃掉了，但这样的兔子还有好多好多。科学家经过检测，发现地球周围确实存在时空漩涡，其各项参数和爱因斯坦广义相对论预言的完全符合。根据爱因斯坦的相对论，空间和时间是交织在一起的，形成一种被他称为“时空”的四维结构。地球的质量会在这种结构上产生“凹陷”，这很像是一个成年人站在蹦床上陷进去的情形.{p}还能靠说笑话赚钱，老虎就生气把兔子吃掉了，但这样的兔子还有好多好多。", function():void{
				trace( "speak done." );
			} );
		}
		
		public function unselect() : void
		{
			layer.actionLayer.unbind();
			layer.actionLayer.endAction();
		}
		
		public function set skillable( value:ISkillable ) : void
		{
			skills.push( value );
		}
		
		public function set stuffable( value:IStuffable ) : void
		{
			stuffs.push( value );
		}
		
		//同一阵营 不同队伍
		public static function isFriend ( a:Unit, b:Unit ) :Boolean
		{
			return a.model.teamModel.faction == b.model.teamModel.faction &&
						a.model.teamModel.team != b.model.teamModel.team;
		}
		//同一阵营 同一队伍	
		public static function isSibling ( a:Unit, b:Unit ) :Boolean
		{
			return a.model.teamModel.faction == b.model.teamModel.faction &&
				a.model.teamModel.team == b.model.teamModel.team;
		}
		//不同阵营
		public static function isEnemy ( a:Unit, b:Unit ) :Boolean
		{
			return a.model.teamModel.faction != b.model.teamModel.faction;
		}
		//同一阵营
		public static function isBrother ( a:Unit, b:Unit ) :Boolean
		{
			return a.model.teamModel.faction == b.model.teamModel.faction;
		}

	}
}