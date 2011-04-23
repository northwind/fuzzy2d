package controlers.unit.impl
{
	import com.hurlant.eval.ast.Void;
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.IDataSource;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.IResource;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	import com.norris.fuzzy.map.item.*;
	
	import controlers.events.UnitEvent;
	import controlers.layers.TileLayer;
	import controlers.layers.UnitsLayer;
	import controlers.unit.IFigure;
	import controlers.unit.Unit;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.impl.FigureModel;
	import models.impl.FigureModelManager;
	import models.impl.UnitModel;
	
	import server.IDataServer;
	
	[Event(name="complete", type="flash.events.event")]
	
	public class BaseFigure extends BaseComponent implements IFigure
	{
		public static const COUNT:uint = 12;
		public static const INTER:uint = 30;
		public static const STEPX:Number = MyWorld.CELL_WIDTH / 2/ BaseFigure.COUNT;
		public static const STEPY:Number = MyWorld.CELL_HEIGHT / 2 / BaseFigure.COUNT;
		
		private var _mapItem:SWFMapItem;
		private var model:UnitModel;
		private var _figureModel:FigureModel;
		private var _resource:IResource;
		private var unit:Unit;
		private var timer:Timer;
		private var currentNode:Node;
		private var nextNode:Node;
		
		private var offsetX:Number;		
		private var offsetY:Number;
		private var calcX:int;		//判断X坐标加还是减
		private var calcY:int;		//判断Y坐标加还是减
		
		public function BaseFigure( model:UnitModel, unit:Unit )
		{
			super();
			this.model = model;
			this.unit = unit;
			
			this.timer = new Timer( BaseFigure.INTER, BaseFigure.COUNT ); 
			this.timer.addEventListener(TimerEvent.TIMER, onTimer );
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete );
		}
		
		override public function onSetup() :void
		{
			if ( model == null )
				return;
			
			_figureModel = model.figureModel;
			if ( _figureModel.type != MapItemType.SWF ){
				Logger.error( this.model.name + "'s type != MapItemType.SWF"  );
				return;
			}
			
			_mapItem = new SWFMapItem( model.figureModel.symbol );
			(_mapItem.view as MovieClip ).mouseEnabled =false;
			(_mapItem.view as MovieClip ).mouseChildren = false;
			//				_mapItem = new UnitMapItem( model.figureModel.symbol );
			//记录原始偏移量
			this.offsetX = this._figureModel.offsetX;
			this.offsetY = this._figureModel.offsetY;
			
			//加载资源
			_resource = MyWorld.instance.resourceMgr.getResource( _figureModel.url );
			if ( _resource == null ){
				_resource = MyWorld.instance.resourceMgr.add( _figureModel.url, _figureModel.url, true );
			}
			//没有下载的使用默认显示
			if ( _resource.isFinish() ){
				setMapItem( _figureModel );
				_mapItem.dataSource = 	_resource;
			}else{
				setMapItem( FigureModelManager.defaultFigureModel );
				_mapItem.dataSource	= MyWorld.instance.resourceMgr.getResource( "defaultFigure" );
				
				_resource.addEventListener( ResourceEvent.COMPLETE, onResourceComplete );
				_resource.load();
			}
			
		}
		
		private function setMapItem( f:FigureModel ) :void
		{
			_mapItem.define = model.name;
			_mapItem.row = model.row;
			_mapItem.col = model.col;
			
			_mapItem.offsetX = f.offsetX;
			_mapItem.offsetY = f.offsetY;
			_mapItem.cols 	 = f.cols;
			_mapItem.rows    = f.rows;
			_mapItem.symbol = f.symbol;
			
			//unitsLayer中会根据角色类型做出进一步判断
			_mapItem.isWalkable = true;
			_mapItem.isOverlap = false;
		}
		
		private function onResourceComplete( event:ResourceEvent ) : void
		{
			_resource.removeEventListener( ResourceEvent.COMPLETE, this.onResourceComplete );
			
			setMapItem( _figureModel );
			_mapItem.dataSource = _resource;
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get mapItem():IMapItem
		{
			return _mapItem;
		}
		
		private var onWalkPathCallback:Function;
		public function walkPath( path:Path, callback:Function = null ) : void
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
//			nextNode      = nodes[1] as Node;
			
			this.walkTo( nodes[1], onNodeCallback );
		}
		
		private var currentN:int;
		private var nodes:Array;
		private function onNodeCallback() : void 
		{
			currentNode = nextNode;
			
			if ( currentN++ < nodes.length -1 ){
				this.walkTo( nodes[ currentN ], onNodeCallback );
			}else{
				if ( onWalkPathCallback != null )
					onWalkPathCallback.call();
				
				unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE_OVER, this.unit ) );
			}
		}
		
		private var nodeCallback:Function;
		private var node:Node;
		private var lastDirect:uint;
		private function walkTo( node:Node, callback:Function = null ) : void
		{
			var direct:uint = BaseFigure.getDirect(  currentNode, node );
			if ( lastDirect != direct ){
				lastDirect = direct;
				
				var fn:String = "turn" + direct;
				try
				{
					_mapItem.view[ fn ]();	
				}
				catch(error:Error) {
					Logger.error( this.model.name + " has no function : " +  fn );
				}
				
				//如果方向在九宫格的右上角则X=1 否则为-1或0
				//如果在九宫格的上方则为-1否则为1或0
				var r:uint = direct / 3, c:uint = direct % 3;
				calcX = c > r ? 1 : ( c < r ? -1 : 0 );
				calcY = r + c < 2 ? -1 : ( r+c > 2 ? 1 : 0  );
			}
			
//			this.node = node;
			this.nextNode = node;
			this.nodeCallback = callback;
			this._mapItem.row = this.currentNode.row;
			this._mapItem.col  = this.currentNode.col;
			
			this.timer.reset();
			this.timer.start();
		}
		
		/**
		 * 计算9宫格方向 
		 * [0,1,2,
			3,4,5,
			6,7,8]
			  0
		    3    1
		  6    4   2
		     7   5
			   8
			 
		 * @param from
		 * @param to
		 * @return 
		 * 
		 */		
		public static function getDirect( from:Node, to:Node ) :uint
		{
			var diffX:int = from.row - to.row,
				diffY:int = from.col - to.col;
			
			return (diffX > 0 ? 0 : diffX< 0 ? 2 : 1 ) + 
					(diffY > 0 ? 0 : diffY< 0 ? 6 : 3 );
		}
		
		protected function onTimer(event:Event):void
		{
			this._mapItem.offsetX += calcX * BaseFigure.STEPX;
			this._mapItem.offsetY += calcY * BaseFigure.STEPY;
			
			//宿主分发事件
			unit.dispatchEvent( new UnitEvent( UnitEvent.MOVE, this.unit ) );
		}
		
		protected function onTimerComplete(event:Event):void
		{
			this._mapItem.row = nextNode.row;
			this._mapItem.col = nextNode.col;
			//还原offset
			this._mapItem.offsetX = this.offsetX;
			this._mapItem.offsetY = this.offsetY;
			
			if ( nodeCallback != null )
				nodeCallback.call();
		}
		
		
	}
}