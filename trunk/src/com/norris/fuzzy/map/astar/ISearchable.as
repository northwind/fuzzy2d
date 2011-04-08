package com.norris.fuzzy.map.astar {
	/**
	 * This interface must be implemented by anything that wants to be searchable by the Astar class.
	 */
	public interface ISearchable {
		/**
		 * Gets the number of columns in the grid.
		 * @return The number of columsn in the grid.
		 */
		function getCols():int;
		/**
		 * Gets the number of rows in the grid.
		 * @return The number of rows in the grid.
		 */
		function getRows():int;
		/**
		 * Gets the node for a specific row/column combo.
		 * @param	Column that the node is in.
		 * @param	Row that the node is in.
		 * @return The INode instance.
		 */
		function getNode( row:int, col:int ):Node
		/**
		 * Gets the terrain transition cost between one node type and another.
		 * @param	The first node.
		 * @param	The second node.
		 * @return The transition cost.
		 */
		function getNodeTransitionCost(n1:Node, n2:Node):Number;
	}
	
}
