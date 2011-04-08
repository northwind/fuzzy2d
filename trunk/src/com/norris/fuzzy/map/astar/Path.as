package com.norris.fuzzy.map.astar {
	/**
	 * This class represents a path of INodes. If a successful search is performed then SearchResults.getPath() returns the most optimal path.
	 */
	public class Path {
		
		public var nodes:Array = [];
		
		public var cost:Number = 0;
		
		public var lastNode:Node;
		/**
		 * Creates a new instance of the Path class.
		 */
		public function Path() {
			
		}
		/**
		 * Clones the class. This is used during the search algorithm when trying to find the most optimal path.
		 * @return Path instance.
		 */
		public function clone():Path {
			var p:Path = new Path();
			p.incrementCost(cost);
			p.nodes = nodes.slice(0);
			return p;
		}
		
		/**
		 * Gets the total cost of the path. That includes the cost from the start node to this point plus the heuristic guess of how much cost from this point to the goal.
		 * @return The cost of the path plus heuristic.
		 */
		public function getF():Number {
			return cost + lastNode.heuristic;
		}
		
		/**
		 * Increments the cost by an amount.
		 * @param	Amount to increment the cost.
		 */
		public function incrementCost(num:Number):void {
			cost += num;
		}
		
		/**
		 * Adds an INode to the path.
		 * @param	The INode to add.
		 */
		public function addNode(n:Node):void {
			nodes.push(n);
			lastNode = n;
		}

	}
	
}
