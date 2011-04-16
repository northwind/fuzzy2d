package controlers.unit
{
	import com.norris.fuzzy.core.cop.impl.Entity;
	
	import controlers.unit.impl.BaseFigure;
	
	import models.impl.UnitModel;
	
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
			this.figure = new BaseFigure( model ) ;
			
			this.addComponent( figure );
		}
	}
}