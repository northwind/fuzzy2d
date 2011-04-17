package controlers.unit
{
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.map.astar.Path;
	
	import controlers.unit.impl.BaseFigure;
	
	import models.impl.UnitModel;
	
	[Event(name="move", type="controlers.events.UnitEvent")]
	
	[Event(name="move_over", type="controlers.events.UnitEvent")]
	
	/**
	 *  TODO mapItem做为unit的view
	 * @author norris
	 * 
	 */	
	public class Unit extends Entity
	{
		public var figure:IFigure;
		public var model:UnitModel;
		
		public function Unit( model:UnitModel )
		{
			super();
			
			this.model = model;
			this.figure = new BaseFigure( model, this ) ;
			
			this.addComponent( figure );
		}
		
		public function walkPath( path:Path, callback:Function = null ) : void
		{
			this.figure.walkPath( path, callback );
		}
		
	}
}