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
		
		public function Unit( model:UnitModelComponent = null )
		{
			super();
			
			if ( model != null )
				this.addComponent( model );
		}
		
		public function restore() : void
		{
			isStandby = false;
		}
		
		public function standby() : void
		{
			this.model.standby(0,0);
			this.figure.gray();
			isStandby = true;
			
			this.dispatchEvent( new UnitEvent( UnitEvent.STANDBY, this ) );
		}
		
		public function select() : void
		{
			figure.highlight();
			
			layer.actionLayer.bind( this );
			layer.actionLayer.beginAction();
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