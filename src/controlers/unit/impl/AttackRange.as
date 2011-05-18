package controlers.unit.impl
{
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	public class AttackRange extends Range implements IRange
	{
		public var block:Boolean;		//是否包含障碍单元
		public var overlay:Boolean;		//是否显示已有移动单位的单元格
		public var self:Boolean;		//是否包括自己
		
		public function AttackRange( unit:Unit, len:uint, type:int )
		{
//			super(unit, unit.model.range, unit.model.rangeType );
			super(unit, len, type );
		}
		
		override protected function onMeasure() : void
		{
			var diff:int, i :int, j:int;
			
			switch(type)
			{
				case RangeType.MATTS: //全方位攻击
				{
					for (i = - len ; i <= len; i++) 
					{
						for (j = -len ; j <= len; j++) 
						{
							if ( (i != 0 || j != 0) && Range.tileLayer.isValid( row + i, col + j ) )
								addNode( Range.tileLayer.getNode( row + i, col + j ) );
						}
					}	
					break;
				}
				case RangeType.SPREAD://蔓延型
				{
					for (i = - len ; i <= len; i++) 
					{
						diff = len - Math.abs( i );
						if ( Range.tileLayer.isValid( row + i, col + diff ) )
							addNode( Range.tileLayer.getNode( row + i, col + diff ) );
						if ( Range.tileLayer.isValid( row + i, col - diff ) )
							addNode( Range.tileLayer.getNode( row + i, col - diff ) );
						
						if ( --diff >= 0 ){
							if ( Range.tileLayer.isValid( row + i, col + diff ) )
								addNode( Range.tileLayer.getNode( row + i, col + diff ) );
							if ( Range.tileLayer.isValid( row + i, col - diff ) )
								addNode( Range.tileLayer.getNode( row + i, col - diff ) );	
						}
					}
					break;
				}
				case RangeType.HOLE:	//散射型
				{
					for (i = - len ; i <= len; i++) 
					{
						diff = len - Math.abs( i );
						if ( Range.tileLayer.isValid( row + i, col + diff ) )
							addNode( Range.tileLayer.getNode( row + i, col + diff ) );
						if ( Range.tileLayer.isValid( row + i, col - diff ) )
							addNode( Range.tileLayer.getNode( row + i, col - diff ) );
					}
					break;
				}
				case RangeType.CROSS :	//十字
				{
					for (i = - len ; i <= len; i++) 
					{
						diff = len - Math.abs( i );
						for (j = -diff ; j <= diff; j++) 
						{
							if ( (i != 0 || j != 0) && Range.tileLayer.isValid( row + i, col + j ) )
								addNode( Range.tileLayer.getNode( row + i, col + j ) );
						}
					}					
					break;
				}
				case RangeType.LINE:	//直线型
				{
					for (i = - len ; i <= len; i++) 
					{
						if ( i != 0 && Range.tileLayer.isValid( row + i, col ) )
							addNode( Range.tileLayer.getNode( row + i, col ) );
					}
					for (j = -len ; j <= len; j++) 
					{
						if ( j != 0 && Range.tileLayer.isValid( row , col + j ) )
							addNode( Range.tileLayer.getNode( row , col + j ) );
					}
					break;
				}
				case RangeType.RECT:	//方框型
				{
					for (i = - len ; i <= len; i++) 
					{
						if ( Range.tileLayer.isValid( row + i, col + len ) )
							addNode( Range.tileLayer.getNode( row + i, col + len ) );
						if ( Range.tileLayer.isValid( row + i, col - len ) )
							addNode( Range.tileLayer.getNode( row + i, col - len ) );
					}
					for (j = -len ; j <= len; j++) 
					{
						if ( Range.tileLayer.isValid( row + len , col + j ) )
							addNode( Range.tileLayer.getNode( row + len , col + j ) );
						if ( Range.tileLayer.isValid( row - len , col + j ) )
							addNode( Range.tileLayer.getNode( row - len , col + j ) );
					}
					break;
				}
				default:
				{
					break;
				}
			}
			
			if( self )
				addNode( unit.node ); 
		} 
	}
}