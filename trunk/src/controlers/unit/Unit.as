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
	import controlers.unit.Unit;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.impl.UnitModel;
	import models.event.UnitModelEvent;
	
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
		
		public function Unit( model:UnitModelComponent )
		{
			super();
			
			if ( model != null ){
				this.addComponent( model );
				
				model.addEventListener(UnitModelEvent.CHANGE_HP, onChangeHP );
				
			}
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
			this.layer.unselect( this );
			
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
			
			dispatchEvent( new UnitEvent( UnitEvent.STANDBY, this ) );
		}
		
		public function select() : void
		{
			figure.highlight();
		}
		
		public function set skillable( value:ISkillable ) : void
		{
			skills.push( value );
		}
		
		public function set stuffable( value:IStuffable ) : void
		{
			stuffs.push( value );
		}
		
		protected function onChangeHP(event:UnitModelEvent):void
		{
			var tempX:Number = Math.max( 10, node.originX + 30 );
			var tempY:Number = Math.max( 10,  node.originY - 40 );
			
			this.layer.animationLayer.showNumber( event.offset, event.offset < 0 ? 0xff0000 : 0x00ff00, 
				tempX, tempY );
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