package impl
{
	import flash.geom.Point;
	
	public class BaseMove extends BaseComponent implements IMoveable
	{
		public var figure:IFigure;
		
		public function BaseMove()
		{
			super();
		}
		
		public function moveTo(p:Point):void
		{
			trace( "BaseMove moveTo : " + p.toString() );
			
			if ( this.figure )
				this.figure.walk( [], null );
		}
	}
}