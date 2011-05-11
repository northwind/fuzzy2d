package controlers.unit.impl
{
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	public class MoveRange extends Range implements IRange
	{
		public var overlay:Boolean;		//是否显示已有移动单位的单元格
		
		private var open:Object;
		private var closed:Object;
		
		public function MoveRange(unit:Unit )
		{
			super(unit, unit.model.step, RangeType.CROSS);
		}
		
		override protected function onMeasure() : void
		{
			 open = {};
			 closed = {};
			 
			 var step:int = this.len, node:Node, checks:int, 
				 copy:Object, key:String, neighbors:Array, child:Node;
			 
			//删除原指针
			unit.node.parent = null;
			
			open[ unit.node.id ] = unit.node;
			checks = 1;
			
			while( checks > 0 && step-- >0 ){
				//添加到open中会导致过多循环
				copy = {};
				for ( key in open ) {
					copy[ key ] = open[ key ];
				}
				
				for ( key in copy ) {
					node = open[ key ] as Node;
					//添加到已处理过的closed表
					closed[ key ] = node;
					
					//添加子节点
					neighbors = Range.tileLayer.astar.getNeighbors( node );
					
					for each ( child in neighbors ) {
						//判断是否可以行走/是否已经计算过/如果有单位判断是否为友军
						if ( 
							Range.unitsLayer.isWalkable( child, unit ) &&
							!open.hasOwnProperty( child.id ) && 
							!closed.hasOwnProperty( child.id )  ) {
							
							child.parent = node;
							open[ child.id ] = child;
							checks++;
						}	
					}
					
					//并从OPEN表中删除
					delete open[ key ];
					checks--;
				}
			}
			//剔除掉友军所占据的单元格
			var h:Unit;
			for each (var n:Node in closed) {
				h = Range.unitsLayer.getUnitByNode( n );
				if ( h != null && Unit.isBrother( h, unit ) )
					delete closed[ n.id ];
			}
			
			_nodes = closed;
		}
		
	}
}