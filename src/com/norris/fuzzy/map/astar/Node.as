package com.norris.fuzzy.map.astar {
	/**
	 * A tile that will work with the A* search needs to implment INode. It can extend this class for convenience, which already implements INode.
	 */
	public class Node{
		
		public var neighbors:Array = null;
		
		public var col:int;
		public var row:int;
		public var id:String;
		
		public var type:String;
		public var heuristic:Number;		
		
		public var centerX:Number;	//该结点映射到屏幕后的中心点
		public var centerY:Number;	//该结点映射到屏幕后的中心点
		
		public var originX:Number;  //左上角的顶点
		public var originY:Number; //左上角的顶点
		
		public function Node( row:int, col:int ) {
			this.row = row;
			this.col = col;
			this.id  = row + "_" + col;
		}
	}
}
