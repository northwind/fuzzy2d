package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.ComponentEntity;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	
	import controlers.layers.UnitsLayer;
	import controlers.unit.impl.BaseFigure;
	import controlers.unit.impl.UnitModelComponent;
	
	import flash.events.Event;
	
	import models.impl.UnitModel;
	
	[Event(name="move", type="controlers.events.UnitEvent")]
	
	[Event(name="move_over", type="controlers.events.UnitEvent")]
	
	[Event(name="standby", type="controlers.events.UnitEvent")]
	
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
		
		public function Unit( model:UnitModelComponent = null )
		{
			super();
			
			if ( model != null )
				this.addComponent( model );
		}
		
		public function standby() : void
		{
			this.model.standby(0,0);
			this.figure.gray();
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
		
		
	}
}