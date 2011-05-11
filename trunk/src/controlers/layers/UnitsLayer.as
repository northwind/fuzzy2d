package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.event.ResourceEvent;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	import com.norris.fuzzy.map.*;
	import com.norris.fuzzy.map.astar.Astar;
	import com.norris.fuzzy.map.astar.ISearchable;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import controlers.Team;
	import controlers.events.TileEvent;
	import controlers.events.UnitEvent;
	import controlers.unit.IFigure;
	import controlers.unit.Unit;
	import controlers.unit.impl.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.RecordModel;
	import models.impl.SkillModel;
	import models.impl.StuffModel;
	import models.impl.TeamModel;
	import models.impl.UnitModel;
	
	[Event(name="start", type="controlers.events.RoundEvent")]
	
	[Event(name="end", type="controlers.events.RoundEvent")]
	/**
	 * 统筹管理unit，并分配用户的操作，不直接响应用户的操作 
	 * @author norris
	 * 
	 */	
	public class UnitsLayer extends BaseLayer implements ISearchable
	{
		public var tileLayer:TileLayer;
		public var tipsLayer:TipsLayer;
		public var staticLayer:StaticLayer;
		public var actionLayer:ActionLayer;
		public var animationLayer:AnimationLayer;
		public var talkLayer:TalkLayer;
		
		public var active:Boolean = true;		//是否接受鼠标点击事件
		public var teams:Array = [];
		public var myTeam:Team;
		
		//使用unitsLayer做为Astar寻路的容器
		private var astar:Astar;
		private var walker:Unit;
		private var _recordModel:RecordModel;
		private var _units:Object = {};
		private var _unitsPos:Object = {};
		private var _sortedItems:Array = [];
		
		private var _lastMoveRow:int = 6;
		private var _lastMoveCol:int = 20;
		
		private var _selectUnit:Unit;

		private var unitTipWrap:Sprite = new Sprite();	//显示角色信息
		private var unitTipShowing:Boolean;			//是否在显示信息
		private var currentTipUnit:Unit;				//当前显示角色
		private var mouseOnTip:Boolean;				//鼠标是否停留在提示信息栏上
		private var unitTipTimer:Timer = new Timer( 200, 1 );	//延迟隐藏
		private var unitTipDelayTimer:Timer = new Timer( 1000, 1 );		//延迟显示
		private var tipClass:Sprite;
		
		public function UnitsLayer( model:RecordModel )
		{
			super();
			
			_recordModel = model;
			astar= new Astar( this );
			
			unitTipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTipTimerCompleted );
			unitTipDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimerCompleted ); 
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		private function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			if ( this._recordModel.data == null )
				this._recordModel.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
			else 
				onModelCompleted();
			
			var resource:SWFResource = (MyWorld.instance.resourceMgr.getResource( "unit_tipbg" ) as SWFResource);
			if ( resource != null ){
				tipClass = new (resource.getSymbol( "showUnit" ));
				
				unitTipWrap.addChild( tipClass );
				unitTipWrap.addEventListener(MouseEvent.ROLL_OVER, onUnitTipOver );
				unitTipWrap.addEventListener(MouseEvent.ROLL_OUT, onUnitTipOut );
			}	
		}
		
		private function onModelCompleted( event :ModelEvent = null ) :void
		{
			this._recordModel.removeEventListener( ModelEvent.COMPLETED, onModelCompleted );
			
			var coord:Coordinate, unit:Unit, mapItem:IMapItem, team:Team;
			for each (var teamModel:TeamModel in this._recordModel.teams) {
				//初始化team
				team = new Team( teamModel );
				if ( teamModel == _recordModel.myTeamModel )
					myTeam = team;
				
				//初始化角色
				for each( var model:UnitModelComponent in teamModel.members.getAll() ){
					unit = new Unit();
					unit.layer = this;
					unit.addComponent( model );
					unit.addComponent( new BaseMove() );
					unit.addComponent( new BaseFigure() );
					if ( model.bodyAttack != 0 )
						unit.addComponent( new BaseAttack() );	
					//技能和物品
					for each (var sk:SkillModel in model.skills ) {
						unit.addComponent( new BaseSkill( sk ) );					
					}
					for each (var sf:StuffModel in model.stuffs ) {
						unit.addComponent( new BaseStuff( sf ) );					
					}
					unit.node = tileLayer.getNode( model.row, model.col );
					unit.setup();
					
					_units[ model.id ] = unit;
					_unitsPos[ unit.node.id ] = unit;
					
					if ( unit.figure != null && unit.figure.mapItem != null ){
						mapItem = unit.figure.mapItem;
						tileLayer.adjustPosition( mapItem );
						
						_sortedItems.push( mapItem );
						
						//延迟加载，加载好后调用onFigureComplete
						unit.figure.addEventListener( Event.COMPLETE, onFigureCompleted );
					}
					
					team.addUnit( unit );
				}
				
				teams.push( team );				
			}
			
			renderAll();
			
			//监听单元格事件
			tileLayer.addEventListener(TileEvent.MOVE, onMoveTile);
			tileLayer.addEventListener(TileEvent.SELECT, onSelectTile);		
			
			Range.unitsLayer = this;
		}
		
		//重新排序
		private function onFigureCompleted( event:Event ):void
		{
			var f:IFigure =event.target as IFigure; 
			f.removeEventListener( Event.COMPLETE, onFigureCompleted );
			
			tileLayer.adjustPosition( f.mapItem );
			renderMapItem( f.mapItem );
		}
		
		private function onSelectTile( event:TileEvent ):void
		{
			if ( !active )
				return;
			
			var unit:Unit = getUnitByPos( event.row, event.col );
			if ( _selectUnit == null ){
				//当前没有操作对象且点在空地上时，什么都不做
				if ( unit == null )
					return;
				
				_selectUnit = unit;
				_selectUnit.select();
				
				//隐藏提示框
				unitTipDelayTimer.reset();
				hideUnitInfo();
			}else{
//				if ( _selectUnit != unit ){
//					_selectUnit.unselect();
//				}
				
				if ( unit == null ){
					return;
				}else{
					_selectUnit = unit;
					_selectUnit.select();
				}
				
			}
			return;
		}
		
		public function unselect() : void
		{
			if ( _selectUnit == null )
				return;
			_selectUnit.unselect();
			_selectUnit = null;
		}
		
		private function onMoveTile( event:TileEvent ):void
		{
			//如果停留在信息栏上忽略
			if ( mouseOnTip )
				return;
			
			//显示角色基本信息
			var temp:Unit = this.getUnitByNode( event.node );
			if ( temp == null ){
				unitTipDelayTimer.reset();
				
				if ( unitTipShowing )
					hideUnitInfo();
			}else{
				if ( currentTipUnit != temp ){
					preShow = temp;
					unitTipDelayTimer.reset();
					unitTipDelayTimer.start();
				}
			}
		}
		
		private var preShow:Unit;
		protected function onDelayTimerCompleted(event:Event):void
		{
			showUnitInfo( preShow );
		}
		
		public function showUnitInfo(unit:Unit):void
		{
			if ( unitTipTimer.running )
				unitTipTimer.reset();
			if ( preShow == null )
				return;
			
			currentTipUnit = unit;
			unitTipShowing = true;
			
			unitTipWrap.x = Math.max( 10, unit.node.originX - unitTipWrap.width + 20 );
			unitTipWrap.y = Math.max( 10,  unit.node.originY - 40 );
			
			try
			{
				var type:int = 3;		//自己人
				if ( this.isEnemy( unit ) )	//敌人
					type = 1;
				else if ( this.isFriend( unit ) )		//盟军
					type = 2;
					
				tipClass[ "showTip" ]( type, unit.model.name, unit.model.level , 
					unit.model.bodyHP + unit.model.fixHP, unit.model.currentHP, unit.model.offsetHP,  
					unit.model.bodyAttack + unit.model.fixAttack, unit.model.currentAttack, unit.model.offsetAttack );
			}
			catch(error:Error) 
			{
				Logger.error( "UnitsLayer showUnit error. " + error.toString()  );
			}
			
			this._view.addChild( unitTipWrap );
		}
		
		public function hideUnitInfo() : void
		{
			if ( unitTipDelayTimer.running )
				unitTipDelayTimer.reset();
			 
			if ( !unitTipShowing )
				return;
			 
			unitTipTimer.reset();
			unitTipTimer.start();
		}
		
		protected function onTipTimerCompleted(event:Event):void
		{
			currentTipUnit = null;
			preShow = null;
			unitTipShowing = false;
			
			this._view.removeChild( unitTipWrap );
		}
		
		protected function onUnitTipOver(event:Event):void
		{
			mouseOnTip = true;
			if ( unitTipTimer.running )
				unitTipTimer.stop();
		}
		
		protected function onUnitTipOut(event:Event):void
		{
			mouseOnTip = false;
			
			//移动显示框同时移动到了别的单元格则取消显示
			if ( this.getUnitByNode( this.tileLayer.currentNode ) != currentTipUnit )
				hideUnitInfo();
		}
		
		/**
		 * 敌军位置不可通过 
		 * @param node
		 * @param walker
		 * @return 
		 * 
		 */		
		public function isWalkable( node:Node, walker:Unit ) : Boolean
		{
			var holder:Unit = getUnitByNode( node );
			return !_recordModel.mapModel.isBlock( node.row, node.col ) && 
				   ( holder == null || holder != null && Unit.isBrother( holder, walker ) );
		}
		
		public function getUnit( id:String ) :Unit
		{
			return _units[ id ] as Unit;
		}
		
		private function generateKey( row:int, col:int ) :String
		{
			return row + "_" + col;
		}
		
		public function getUnitByPos( row:int, col:int ) :Unit
		{
			return _unitsPos[ generateKey( row, col) ] as Unit;
		}
		
		public function hasUnitByPos( row:int, col:int ) :Boolean
		{
			return _unitsPos[ generateKey( row, col) ] != undefined;
		}
		
		public function getUnitByNode( node:Node ) :Unit
		{
			if ( node == null )
				return null;
			
			return _unitsPos[ node.id ] as Unit;
		}
		
		public function delUnitByNode( node:Node ) :void
		{
			delete _unitsPos[ node.id ];
		}
		
		public function addUnitByNode( node:Node, unit:Unit ) :void
		{
			_unitsPos[ node.id ] = unit;
		}
		/**
		 * 每当有item更改位置时，需要调用该方法，重新排序 
		 */		
		public function renderMapItem( item:IMapItem ) : void
		{
			this.tileLayer.adjustPosition( item );
			renderAll();
		}
		
		public function renderAll() :void
		{
			sortAllItems();
		}
		
		private function sortAllItems() : void 
		{
			var list:Array = _sortedItems.slice(0);
			
			_sortedItems = [];
			
			for (var i:int = 0; i < list.length;++i) {
				var nsi:ISortable = list[i];
				
				var added:Boolean = false;
				for (var j:int = 0; j < _sortedItems.length;++j ) {
					var si:ISortable = _sortedItems[j];
					
					if (nsi.col <= si.col && nsi.row <= si.row ) {
						_sortedItems.splice(j, 0, nsi);
						added = true;
						break;
					}
				}
				if (!added) {
					_sortedItems.push(nsi);
				}
			}
			
			while( this.view.numChildren>0 )
				this.view.removeChildAt( 0 );
			
			for (i = 0; i < _sortedItems.length;++i) {
				var disp:IMapItem = _sortedItems[i] as IMapItem;
				this.view.addChildAt(disp.view, i);
			}
		}
		
		public function getCols():int 
		{
			return tileLayer.cols;
		}
		
		public function getRows():int
		{
			return tileLayer.rows;
		}
		
		public	function getNodeTransitionCost(n1:Node, n2:Node):Number
		{
			var cost:Number = 1;
			if ( staticLayer.isBlock( n1.row, n1.col ) || staticLayer.isBlock( n2.row, n2.col ) )
				cost = 10000;
			else {
				//如果是寻路者的敌人则不让通过
				var u1:Unit = this.getUnitByNode( n1 ), u2:Unit = this.getUnitByNode( n2 );
				if ( u1 && Unit.isEnemy( walker, u1 ) ||
					  u2 && Unit.isEnemy( walker, u2 ) )
					cost = 10000;
			}
			return cost;
		}
		
		/**
		 * 寻路 
		 * @param walker
		 * @param target
		 * @return 
		 * 
		 */		
		public function findPath( walker:Unit, target:Node ):Path
		{
			if ( walker == null || target == null )
				return null;
			
			this.walker = walker;
			return astar.search( walker.node, target );
		}
		
		public function getNode( row:int, col:int ):Node
		{
			return tileLayer.getNode( row, col );
		}
		
		//同一阵营 不同队伍
		public function isFriend ( b:Unit ) :Boolean
		{
			return myTeam.model.faction == b.model.teamModel.faction &&
				myTeam.model.team != b.model.teamModel.team;
		}
		//同一阵营 同一队伍	
		public function isSibling ( b:Unit ) :Boolean
		{
			return myTeam.model.faction == b.model.teamModel.faction &&
				myTeam.model.team == b.model.teamModel.team;
		}
		//不同阵营
		public function isEnemy ( b:Unit ) :Boolean
		{
			return myTeam.model.faction != b.model.teamModel.faction;
		}
		//同一阵营
		public function isBrother ( b:Unit ) :Boolean
		{
			return myTeam.model.faction == b.model.teamModel.faction;
		}
		
	}
}