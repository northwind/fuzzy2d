package
{
	import flash.geom.Point;

	public interface IMoveable extends IComponent
	{
		function moveTo( p :Point ) : void;
	}
}