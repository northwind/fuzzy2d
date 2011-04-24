package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.ComponentEntity;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.map.astar.Path;
	
	import controlers.layers.UnitsLayer;
	import controlers.unit.impl.BaseFigure;
	import controlers.unit.impl.UnitModelComponent;
	
	import models.impl.UnitModel;
	
	[Event(name="move", type="controlers.events.UnitEvent")]
	
	[Event(name="move_over", type="controlers.events.UnitEvent")]
	
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
		
		public function Unit( model:UnitModelComponent = null )
		{
			super();
			
			if ( model != null )
				this.addComponent( model );
		}
		
		public function walkPath( path:Path, callback:Function = null ) : void
		{
			this.figure.walkPath( path, callback );
		}
		
		public function standby() : void
		{
			this.model.standby(0,0);
			this.figure.standby();
		}
		
		public function select() : void
		{
			figure.highlight();
			
			layer.actionLayer.bind( this );
			layer.actionLayer.showAction();
		}
		
		public function unselect() : void
		{
//			figure.normal();
			
			layer.actionLayer.unbind();
			layer.actionLayer.hideAction();
		}
		
		public function moveTo( row:int, col:int ) :void
		{
			if ( moveable != null )
				moveable.moveTo.apply( null, arguments );
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