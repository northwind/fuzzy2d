package impl
{
	public class BaseFigure extends BaseComponent implements IFigure
	{
		public function BaseFigure()
		{
			super();
		}
		
		public function walk(points:Array, callback:Function):void
		{
			trace( "BaseFigure walk to " + points.join(",") );
		}
		
		public function turnLeft(callback:Function):void
		{
		}
		
		public function attack(direct:String, callback:Function):void
		{
			trace( "BaseFigure attack to " + direct );
		}
	}
}