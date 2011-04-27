package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.map.*;
	import com.norris.fuzzy.map.astar.*;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import controlers.events.UnitEvent;
	import controlers.unit.IFigure;
	import controlers.unit.IMoveable;
	import controlers.unit.IRange;
	import controlers.unit.Unit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BaseMove extends BaseComponent implements IMoveable
	{
		//TODO 采用资源管理器统一加载
		[Embed(source='assets/moveto.png')]
		public static const gridClass:Class;
		public static const bitmapData:BitmapData = (new gridClass() as Bitmap).bitmapData; 
		
		public static const COUNT:uint = 12;
		public static const INTER:uint = 30;
		public static const STEPX:Number = MyWorld.CELL_WIDTH / 2/ COUNT;
		public static const STEPY:Number = MyWorld.CELL_HEIGHT / 2 / COUNT;
		
		private var _active:Boolean;
		private var _range:MoveRange;
		
		private var _lastRow:int;
		private var _lastCol:int;
		private var _target:Node;
		
		private var timer:Timer;
		private var onWalkPathCallback:Function;
		private var currentNode:Node;
		private var nextNode:Node;
		private var currentN:int;
		private var nodes:Array;
		
		private var offsetX:Number;		
		private var offsetY:Number;
		private var calcX:int;		//判断X坐标加还是减
		private var calcY:int;		//判断Y坐标加还是减
		
		public var unit:Unit;
		public var model:UnitModelComponent;
		public var figure:IFigure;
		public var moving:Boolean;
		
		public function BaseMove()
		{
			super();
			
			this.timer = new Timer( BaseMove.INTER, BaseMove.COUNT ); 
			this.timer.addEventListener(TimerEvent.TIMER, onTimer );
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			unit.addEventListener(UnitEvent.STANDBY, onStandby );
			_active = true;
			_range = new MoveRange( unit );
		}

		/**
		 * 移动范围 
		 */		
		public function get range():IRange
		{
			_range.measure();
			
			return _range;
		}
		
		public function showRange():void
		{
			unit.layer.tileLayer.paintRange( range, BaseMove.bitmapData );
		}
		
		public function hideRange():void
		{
			unit.layer.tileLayer.clear();
		}
		
		public function canMove( node:Node ):Boolean
		{
			return _range.contains( node );
		}
		
		public function get active() :Boolean
		{
			return _active;
		}
		
		protected function onStandby(event:Event):void
		{
			//待机后清空移动范围
			_range.reset();
			_active = true;
		}
		
		public function moveTo( to:Node, callback:Function = null ):void
		{
			if ( moving || !canMove( to ) )
				return;
			
			_target = to;
			var path:Path = unit.layer.astar.search( unit.node, to );
			
			moving = true;
			walkPath( path, callback );
		}
		
		private function walkPath( path:Path, callback:Function = null ) : void
		{
			nodes = path.nodes;
			//无路径或者只有自己所在的单元格直接返回
			if ( nodes.length <= 1 ){
				if ( callback != null )
					callback.call();
				return;
			}
			
			onWalkPathCallback = callback;
			currentN = 1;
			currentNode = nodes[0] as Node;
			
			walkTo( nodes[1] );
		}
		
		private function onNodeCallback() : void 
		{
			currentNode = nextNode;
			
			if ( currentN++ < nodes.length -1 ){
				//继续移动
				walkTo( nodes[ currentN ] );
			}else{
				//已经完成移动
				moving = false;
				_active  = false;
				unit.node = _target;
				
				if ( onWalkPathCallback != null )
					onWalkPathCallback.call();
				
				unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE_OVER, this.unit ) );
			}
		}
		
		private function walkTo( node:Node ) : void
		{
			figure.faceTo( node );

			//如果方向在九宫格的右上角则X=1 否则为-1或0
			//如果在九宫格的上方则为-1否则为1或0
			var r:uint = figure.direct / 3, c:uint = figure.direct % 3;
			calcX = c > r ? 1 : ( c < r ? -1 : 0 );
			calcY = r + c < 2 ? -1 : ( r+c > 2 ? 1 : 0  );
			
			nextNode = node;
			figure.mapItem.row = this.currentNode.row;
			figure.mapItem.col  = this.currentNode.col;
			
			this.timer.reset();
			this.timer.start();
		}
		
		protected function onTimer(event:Event):void
		{
			figure.mapItem.offsetX += calcX * BaseMove.STEPX;
			figure.mapItem.offsetY += calcY * BaseMove.STEPY;
			
			//宿主分发事件
			unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE, this.unit ) );
		}
		
		protected function onTimerComplete(event:Event):void
		{
			figure.mapItem.row = nextNode.row;
			figure.mapItem.col = nextNode.col;
			//还原offset
			figure.mapItem.offsetX = this.offsetX;
			figure.mapItem.offsetY = this.offsetY;
			
			onNodeCallback();
		}		
	}
}