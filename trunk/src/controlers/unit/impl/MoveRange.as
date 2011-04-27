package controlers.unit.impl
{
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	public class MoveRange extends Range implements IRange
	{
		public var overlay:Boolean;		//是否显示已有移动单位的单元格
		
		public function MoveRange(unit:Unit )
		{
			super(unit, unit.model.step, RangeType.CROSS);
		}
		
		override protected function onMeasure() : void
		{
			var diff:int, px:int, py : int;
			for (var i:int = - len ; i <= len; i++) 
			{
				diff = len - Math.abs( i );
				for (var j:int = -diff ; j <= diff; j++) 
				{
					//不是自身所在位置,不是无效区域,不是障碍单元,不是有角色所在,才可以被添加
					px = row + i; py = col + j;
					if ( (i != 0 || j != 0) && 
						Range.tileLayer.isValid( px, py ) &&
						!Range.staticLayer.isBlock( px, py ) &&
						!Range.unitsLayer.hasUnitByPos( px, py ) )
						
						addNode( Range.tileLayer.getNode( px, py ) );
				}
			}			
		} 
	}
}