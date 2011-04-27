package controlers.unit.impl
{
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	public class MoveRange extends Range implements IRange
	{
		public var block:Boolean;		//是否包含障碍单元
		public var overlay:Boolean;		//是否显示已有移动单位的单元格
		
		public function MoveRange(unit:Unit )
		{
			super(unit, unit.model.step, RangeType.CROSS);
		}
		
		override protected function onMeasure() : void
		{
			var diff:int;
			for (var i:int = - len ; i <= len; i++) 
			{
				diff = len - Math.abs( i );
				for (var j:int = -diff ; j <= diff; j++) 
				{
					if ( (i != 0 || j != 0) && Range.tileLayer.isValid( row + i, col + j ) )
						addNode( Range.tileLayer.getNode( row + i, col + j ) );
				}
			}			
		} 
	}
}