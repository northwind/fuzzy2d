package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.hurlant.eval.ast.Func;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.display.impl.ScrollLayerContainer;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.events.*;
	import controlers.unit.*;
	import controlers.unit.impl.Range;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import models.impl.SkillModel;
	import models.impl.StuffModel;
	
	import views.BlowIconButton;
	import views.IconButton;
	import views.IconButtonMgr;

	/**
	 * 角色操作层 
	 * 角色共有六种状态
	 * 1. 初始化状态
	 * 2. 等待移动状态
	 * 3. 移动后状态
	 * 4. 等待攻击状态
	 * 5. 攻击后状态
	 * 6. 待机
	 * 每个状态在退出后都必须还原为最初状态，即没有任何多余显示
	 * @author norris
	 * 
	 */	
	public class ActionLayer extends BaseLayer
	{
		private var _unit:Unit;				//绑定的角色
		private var oX:Number;				//原点
		private var oY:Number;				//原点
		private var r:Number = 85;			//半径
		private var oScale:Number = 0.1;	//变形比率
		private var oAlpha:Number = 0.5;	//透明度
		private var conversion:Number = Math.PI/180;
		private var lasttime:Number = 0.6;
		private var icons:Array = [];
		private var clicked:Object = {};
		public var cancelPoint:Point;
		
		private var mBtn:RangeIconButton;
		private var aBtn:RangeIconButton;
		private var sBtn:IconButton;
		private var cBtn:IconButton;
		
		public var tileLayer:TileLayer;
		public var unitsLayer:UnitsLayer;
		public var cancelLayer:CancelLayer;
		
		//六种状态
		private var initState:ActionState;
		private var movingState:RangeActionState;
		public var movedState:ActionState;
		private var attackingState:RangeActionState;
		private var attackedState:ActionState;
		private var standbyState:ActionState;
		
		public var stack:StateStack;
		
		public function ActionLayer()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			//资源加载好后再初始化
			//------------------------- 角色状态 ---------------------
			stack = new StateStack();
			stack.onEmpty = function():void{
				_unit.unselect();
			};
			//初始化
			initState = new ActionState( function():void{
				icons = [];
				addMoveBtn();
				addAttackBtn();
				addSkillBtns();
				addStandbyBtn();
				addStuffBtns();
				addCancelBtn();
				updateOriginXY();
				showAction();
				resetRange();
			},  function():void{
				clearAction();
			} );
			//移动后
			movedState = new ActionState( function():void{
				icons = [];
				addAttackBtn();
				addSkillBtns();
				addStandbyBtn();
				addStuffBtns();
				addCancelBtn();
				updateOriginXY();
				showAction();
				resetRange();
			},  function():void{
				clearAction();
				updateOriginXY();
			} );
			//准备移动
			movingState = new RangeActionState();
			movingState.actionLayer = this;
			movingState.nextState = movedState;
			
			//攻击后
			movedState = new ActionState( function():void{
				stack.push( standbyState );
			});
			
			//准备攻击
			attackingState = new RangeActionState();
			attackingState.actionLayer = this;
			attackingState.nextState = movedState;
			
			//待机
			standbyState = new ActionState( function():void{
				stack.clear();
				_unit.standby();
			});
			
			//--------------------------设置弹出菜单按钮----------------------
			mBtn = new RangeIconButton( "移动" );
			mBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_move" );
			mBtn.addEventListener(MouseEvent.ROLL_OVER, onRangeBtnOver );
			mBtn.addEventListener(MouseEvent.ROLL_OUT, onRangeBtnOut );
			mBtn.addEventListener(MouseEvent.CLICK, onRangeBtnClick );
			mBtn.state = this.movingState;
			IconButtonMgr.reg( "move", mBtn );
			
			aBtn = new RangeIconButton( "攻击" );
			aBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_attack" );
			aBtn.addEventListener(MouseEvent.ROLL_OVER, onRangeBtnOver );
			aBtn.addEventListener(MouseEvent.ROLL_OUT, onRangeBtnOut );
			aBtn.addEventListener(MouseEvent.CLICK, onRangeBtnClick );
			aBtn.state = this.attackingState;
			IconButtonMgr.reg( "attack", aBtn );		
			
			sBtn = new BlowIconButton( "待机" );
			sBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_standby" );
			IconButtonMgr.reg( "standby", sBtn );
			
			cBtn = new BlowIconButton( "取消" );
			cBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_cancel" );
			cBtn.addEventListener(MouseEvent.CLICK, onCancelClick );
			IconButtonMgr.reg( "cancel", cBtn );	
		}
		
		public function bind( unit:Unit ) :void
		{
			var mapItem:IMapItem = unit.figure.mapItem;
			var node:Node = tileLayer.getNode( mapItem.row, mapItem.col );
			
			this._unit = unit;
			
			mBtn.able = unit.moveable;
			aBtn.able = unit.attackable;
			
			updateOriginXY();
		}
		
		private function resetRange() : void
		{
			var rb:RangeIconButton;
			for each (var btn:IconButton in icons) {
				if ( btn is RangeIconButton ){
					rb = btn as RangeIconButton;
					if ( rb != null && rb.able != null  )
						rb.able.reset();
				}
			}
		}
		
		public function updateOriginXY() : void
		{
			this.oX = _unit.node.centerX - 24;
			this.oY = _unit.node.centerY - 48;
		}
		
		public function unbind() : void
		{
			this._unit = null;
		}
		
		//技能
		private function addSkillBtns() :void
		{
			var sm:SkillModel, btn:RangeIconButton;
			for (var j:int = 0; j < this._unit.skills.length; j++) 
			{
				sm = (this._unit.skills[ j ] as ISkillable).skillModel;
				if ( sm != null ){
					btn = IconButtonMgr.get( sm.name ) as RangeIconButton;
					if ( btn == null ){
						//如果没有则延迟加载
						btn = IconButtonMgr.create( sm.name, sm.desc, sm.iconUrl, RangeIconButton  ) as RangeIconButton;
						btn.able = this._unit.skills[ j ] as IActionable;
						btn.state = this.attackingState;
						btn.addEventListener(MouseEvent.ROLL_OVER, onRangeBtnOver );
						btn.addEventListener(MouseEvent.ROLL_OUT, onRangeBtnOut );
						btn.addEventListener(MouseEvent.CLICK, onRangeBtnClick );
					}
					icons.push( btn );
				}
			}
		}
		
		//物品
		private function addStuffBtns() :void
		{
			var stuff:StuffModel, btn:RangeIconButton;
			for (var i:int = 0; i < this._unit.stuffs.length; i++) 
			{
				stuff = (this._unit.stuffs[ i ] as IStuffable ).model;
				if ( stuff != null ){
					btn = IconButtonMgr.get( stuff.name ) as RangeIconButton;
					if ( btn == null ){
						//如果没有则延迟加载
						btn = IconButtonMgr.create( stuff.name, stuff.desc, stuff.iconUrl, RangeIconButton ) as RangeIconButton;
						btn.able = this._unit.stuffs[ i ] as IActionable;
						btn.state = this.attackingState;
					}
					icons.push( btn );
				}
			}
		}
		
		//移动
		private function addMoveBtn() :void
		{
			if ( this._unit.moveable != null &&  this._unit.moveable.active ){
				icons.push( mBtn );
			}
		}
		
		//攻击
		private function addAttackBtn() : void
		{
			if ( this._unit.attackable != null )
				icons.push( aBtn );
		}
		
		//待机
		private function addStandbyBtn() :void
		{
			icons.push( sBtn );
		}
		
		//取消
		private function addCancelBtn() :void
		{
			icons.push( cBtn );
		}
		
		public function clearAction(): void
		{
			for each (var btn:IconButton in icons) {
				try
				{
					if ( btn.parent )
						btn.parent.removeChild( btn );
				}
				catch(error:Error) 
				{}
			}
			
			icons = [];
		}
		
		public function showCancel( point:Point ) : void
		{
			if ( point == null ) return;
			
			cBtn.x = point.x;
			cBtn.y = point.y;
			
			this.cancelLayer.view.addChild( cBtn ); 
		}
		
		public function hideCancel() : void
		{
			if ( cBtn.parent )
				cBtn.parent.removeChild( cBtn );
		}
		
		public function beginAction() :void
		{
			stack.push( this.initState );
		}
		
		public function endAction() :void
		{
			//删除
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
			
			while( this.cancelLayer.view.numChildren > 0 )
				this.cancelLayer.view.removeChildAt( 0 );
		}
		
		public function showAction( animation:Boolean = true ) : void
		{
			var a:Number = 360 / icons.length; 
			
			var ct:DisplayObjectContainer = this.view, btn:DisplayObject;
			for (var i:int = 0; i < icons.length; i++) 
			{
				//将取消按钮添加到静止层
				btn = icons[ i ] as DisplayObject;
				runTo( btn , (90 - i * a) * conversion, ct, animation );
			}
		}
		
		private function runTo( target:DisplayObject, angle:Number, ct:DisplayObjectContainer, animation:Boolean = true ) : void
		{
			var x:Number = oX + r * Math.cos( angle  );
			var y:Number = oY - r * Math.sin( angle );
			
			if ( target == cBtn ){
				cancelPoint = new Point( x, y );
			}
			
			if ( animation ){			
				target.x = oX;
				target.y = oY;
				target.scaleX = oScale;
				target.scaleY = oScale;
				
				ct.addChild( target );
				
				TweenLite.to(target, lasttime, { x:x, y : y, scaleX : 1, scaleY : 1 } );
			}else{
				target.x = x;
				target.y = y;
				ct.addChild( target );
			}
		}
		
		protected function onRangeBtnOver(event:MouseEvent):void
		{
			var btn:RangeIconButton = event.target as RangeIconButton;
			btn.able.showRange();
		}
		
		protected function onRangeBtnOut(event:MouseEvent = null):void
		{
			var btn:RangeIconButton = event.target as RangeIconButton;
			if ( clicked[ btn.dataSource.name ] != true )
				btn.able.hideRange();
			
			clicked[ btn.dataSource.name ] = false;
		}
		
		protected function onRangeBtnClick(event:MouseEvent = null ):void
		{
			var btn:RangeIconButton = event.target as RangeIconButton;
			btn.able.hideRange();
			clicked[ btn.dataSource.name ] = true;
			//切换为选择单元格状态
			btn.state.bind( btn.able );
			stack.push( btn.state );
		}
		
		protected function onCancelClick(event:MouseEvent):void
		{
			this.stack.pop();
		}
	}
}
import controlers.events.TileEvent;
import controlers.layers.ActionLayer;
import controlers.layers.TileLayer;
import controlers.unit.IActionable;

import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;

import views.BlowIconButton;

internal class RangeIconButton extends BlowIconButton
{
	public var able:IActionable;
	public var state:RangeActionState;
	
	public function RangeIconButton( tips:String=null, bitmapData:BitmapData=null ) : void
	{
		super( tips, bitmapData );
	}
}

/**
 * 角色动作状态 
 * @author norris
 * 
 */	
internal class ActionState
{
	public var onEnter:Function;
	public var onExit:Function;
	
	public function ActionState( onEnter:Function = null, onExit:Function = null )
	{
		this.onEnter = onEnter;
		this.onExit = onExit;
	}
	
	public function enter( preStatus:ActionState = null ) :void
	{
		if ( onEnter != null )
			onEnter( preStatus );
	}
	
	public function exit( nextStatus:ActionState = null ) :void
	{
		if ( onExit != null )
			onExit( nextStatus );
	}
}

internal class RangeActionState extends ActionState
{
	private var able:IActionable;
	public var actionLayer:ActionLayer;
	public var cancelPoint:Point;
	public var nextState:ActionState;
	
	public function RangeActionState()
	{
		super( onStateEnter, onStateExit );
	}
	
	public function bind( able:IActionable ) :void
	{
		this.able = able;
		this.cancelPoint = null;
	}
	
	private function onStateEnter( preStatus:ActionState = null ) :  void
	{
		if ( able == null )  return;
		
//		if( preStatus == actionLayer.movedState ){
//			able.reset();
//			actionLayer.updateOriginXY();
//		}
		able.reset();
		able.showRange();
		//保存取消按钮所在位置,并映射为屏幕坐标
		if ( this.cancelPoint == null ){
			this.cancelPoint = actionLayer.cancelPoint.clone();
			actionLayer.tileLayer.toScreen( cancelPoint );
		}
		actionLayer.showCancel( this.cancelPoint );
		actionLayer.unitsLayer.active = false;
		
		actionLayer.tileLayer.addEventListener( TileEvent.SELECT, onSelectTile );
	}
	
	private function onStateExit( nextStatus:ActionState = null ) :  void
	{
		if ( able == null )
			return;
		
		actionLayer.tileLayer.removeEventListener( TileEvent.SELECT, onSelectTile );
		able.hideRange();
		
		actionLayer.hideCancel();
		actionLayer.unitsLayer.active = true;
	}
	
	protected function onSelectTile(event:TileEvent):void
	{
		if ( able.canApply( event.node ) ){
			actionLayer.tileLayer.removeEventListener( TileEvent.SELECT, onSelectTile );
			
			able.hideRange();
			actionLayer.hideCancel();
			able.applyTo( event.node, function() : void{
				//切换为移动后状态
				actionLayer.stack.push( nextState );
			} );
		}
		else{
			//TIP
		}
	}
	
}

/**
 * 状态栈 
 * @author norris
 * 
 */	
internal class StateStack
{
	public var onEmpty:Function;
	private var _items:Array;
	
	public function StateStack()
	{
		_items = [];
	}
	
	public function push( status:ActionState ) :void
	{
		if ( _items.length > 0 ){
			var top:ActionState = _items[ _items.length - 1 ] as ActionState;
			top.exit( status );
		}
		
		_items.push( status );
		status.enter( top );
	}
	
	public function pop() :void
	{
		if ( _items.length == 0 )
			return;
		
		var top:ActionState = _items[ _items.length - 1 ] as ActionState;
		var next:ActionState;
		if ( _items.length > 1 )
			next = _items[ _items.length - 2 ] as ActionState;
		
		top.exit( next );
		_items = _items.slice( 0, _items.length - 1 );
		
		//进入下个状态开启
		if ( next ){
			next.enter( top );
		}else{
			onEmpty();
		}
	}
	
	public function clear() : void
	{
		_items = [];
	}
}