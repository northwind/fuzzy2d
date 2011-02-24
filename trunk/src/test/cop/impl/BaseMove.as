package impl
{
	import flash.geom.Point;
	
	public class BaseMove extends BaseComponent implements IMoveable
	{
		public var figure:IFigure;
		
		public function BaseMove()
		{
			//TODO: implement function
			super();
		}
		
		public function moveTo(p:Point):void
		{
			//TODO: implement function
			if ( this.figure )
				this.figure.walk( [], null );
		}
	}
}