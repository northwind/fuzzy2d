package com.norris.fuzzy.map.astar {

	public class Astar {
		private var startNode:Node;
		private var goalNode:Node;
		private var grid:ISearchable;
		private var closed:Object;
		
		public var allowDiag:Boolean;
		
		public var maxSearchTimes:uint = 100;		//最大循环次数
		private var _searchTimes:uint = 0;
		
		public static const DIAG:Number = Math.sqrt(2);		//拐弯的cost
		/**
		 * Creates a new instance of the Astar class. 
		 */
		public function Astar(grid:ISearchable, allowDiag:Boolean = false ) {	
			this.grid = grid;
			this.allowDiag = allowDiag;
		}
		
		/**
		 * Performs an A* search from one tile (Node) to another, using a grid (ISearchable). 
		 * @param	The starting Node point on the grid.
		 * @param	The target Node point on the grid.
		 * @return SearchResults class instance. If the search yielded a path then SearchResults.getIsSuccess() method returns true, and SearchResults.getPath() returns a Path instance that defines the path.
		 */
		public function search(start_node:Node, goal_node:Node):Path {
			startNode = start_node;
			goalNode = goal_node;
			closed = new Object();
			_searchTimes = 0;
			
			var results:Path;
			var queue:PriorityQueue = new PriorityQueue();
			
			var path:Path = new Path();
			path.addNode(start_node);
			queue.enqueue(path);
			
			while (queue.hasPath()) {
				if ( _searchTimes++ >= maxSearchTimes ) {
					break;
				}
				var p:Path = queue.getBestPath();
				var lastNode:Node = p.lastNode;
				//忽略已存在结点
				if ( closed[ lastNode.id ] != null ) {
					continue;
				} else if (lastNode == goalNode) {
					results = p;
					
					break;
				} else {
					closed[lastNode.id] = true;
					var neighbors:Array = getNeighbors(lastNode);
					
					for (var i:int=0;i<neighbors.length;++i) {
						var t:Node = Node(neighbors[i]);
						var h:Number = Math.sqrt(Math.pow(goalNode.col-t.col, 2) + Math.pow(goalNode.row-t.row, 2));
						t.heuristic = h;
						
						var pp:Path = p.clone();
						pp.addNode(t);
						
						var cost:Number;
						if (t.col == lastNode.col || t.row == lastNode.row) {
							cost = 1;
						} else {
							cost = Astar.DIAG;
						}
						var costMultiplier:Number = grid.getNodeTransitionCost(lastNode, t);
						cost *= costMultiplier;
						
						pp.incrementCost(cost);
						
						queue.enqueue(pp);
					}
				}
			}
			
			return results;
		}
		
		/**
		 * Gets the neighbor Nodes of the one passed in.
		 * @private
		 * @param	The Node for which you want to know the the neighbors.
		 * @return Array of Node instances.
		 */
		private function getNeighbors(n:Node):Array {
			var arr:Array = n.neighbors;
			var c:int = n.col;
			var r:int = n.row;
			var max_c:int = grid.getCols();
			var max_r:int = grid.getRows();
			
			if (arr == null) {
				arr = new Array();
				var t:Node;
				
				if (c+1 < max_c) {
					insertNode( arr, r, c+1 );
				}
				if (r+1 < max_r) {
					insertNode( arr, r+1, c );
				}
				if (c-1 >= 0) {
					insertNode( arr, r, c -1 );
				}
				if (r-1 >= 0) {
					insertNode( arr, r-1, c );
				}
				
				if (allowDiag) {
					if (c-1 > 0 && r+1 < max_r) {
						insertNode( arr, r+1, c-1 );
					}
					if (c+1 < max_c && r+1 < max_r) {
						insertNode( arr, r+1, c+1 );
					}
					if (c-1 > 0 && r-1 > 0) {
						insertNode( arr, r-1, c-1 );
					}
					if (c+1 < max_c && r-1 > 0) {
						insertNode( arr, r-1, c+1 );
					}
				}
				
				n.neighbors = arr;
			}
			return arr;
		}
		
		private function insertNode( arr:Array, row:int, col:int ) : void
		{
			var t:Node = grid.getNode( row, col );
			if ( t != null )
				arr.push( t );
		}
		
	}
	
}
