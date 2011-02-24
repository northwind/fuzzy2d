package
{
	public interface IFigure extends IComponent
	{
		function walk( points:Array, callback:Function ) : void;
		
		function turnLeft( callback:Function ) : void;
		
		function attack ( direct:String, callback:Function ) : void;
		
	}
}