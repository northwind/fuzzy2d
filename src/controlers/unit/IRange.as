package controlers.unit
{
	public interface IRange
	{
		function reset() :void;
		
		function measure() :void;
	
		function get nodes() :Object;
	}
}