package controlers.layers
{
	public class RangeSelector
	{
		public function RangeSelector()
		{
		}
		
		/**
		 * 计算可以作用到的单元格
		 * @param row
		 * @param col
		 * @param range  long
		 * @param type   RangeType
		 * @return       [ [row,col], [row,col],... ] 
		 */		
		public static function calcRange( row:int, col:int, range:uint, type:int ) : Array
		{
			return [ [6,20] ];
		}
	}
}