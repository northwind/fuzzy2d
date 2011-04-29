package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.events.*;
	import controlers.unit.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		
		private var mBtn:IconButton;
		private var aBtn:RangeIconButton;
		private var sBtn:IconButton;
		private var cBtn:IconButton;
		private var stack:StateStack;
		
		public var tileLayer:TileLayer;
		public var unitsLayer:UnitsLayer;
		
		//六种状态
		private var initState:ActionState;
		private var movingState:ActionState;
		private var movedState:ActionState;
		private var attackingState:ActionState;
		private var attackedState:ActionState;
		
		public function ActionLayer()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			//资源加载好后再初始化
			//设置弹出菜单按钮
			mBtn = new IconButton( "移动" );
			mBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_move" );
			mBtn.addEventListener(MouseEvent.ROLL_OVER, onMoveOver );
			mBtn.addEventListener(MouseEvent.ROLL_OUT, onMoveOut );
			mBtn.addEventListener(MouseEvent.CLICK, onMoveClick );
			IconButtonMgr.reg( "move", mBtn );
			
			aBtn = new RangeIconButton( "攻击" );
			aBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_attack" );
			aBtn.addEventListener(MouseEvent.ROLL_OVER, onAttackOver );
			aBtn.addEventListener(MouseEvent.ROLL_OUT, onAttackOut );
//			aBtn.addEventListener(MouseEvent.CLICK, onAttackClick );
			IconButtonMgr.reg( "attack", aBtn );		
			
			sBtn = new BlowIconButton( "待机" );
			sBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_standby" );
			IconButtonMgr.reg( "standby", sBtn );
			
			cBtn = new BlowIconButton( "取消" );
			cBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_cancel" );
			cBtn.addEventListener(MouseEvent.CLICK, onCancelClick );
			IconButtonMgr.reg( "cancel", cBtn );	
			
			//------------------------- 角色状态 ---------------------
			stack = new StateStack();
			initState = new ActionState( function():void{
				icons = [];
				addMoveBtn();
				addAttackBtn();
				addSkillBtns();
				addStandbyBtn();
				addStuffBtns();
				addCancelBtn();
				showAction();
			},  function():void{
				clearAction();
				unitsLayer.unselect();
			} );
			//准备移动
			movingState = new ActionState( function( preStatus:ActionState ):void{
				if ( preStatus == movedState ){
					_unit.moveable.reset();
					updateOriginXY();
				}
				_unit.moveable.showRange();
				tileLayer.addEventListener( TileEvent.SELECT, onMoveSelectTile );
			},  function():void{
				tileLayer.removeEventListener( TileEvent.SELECT, onMoveSelectTile );
				_unit.moveable.hideRange();
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
			},  function():void{
				clearAction();
			} );
			//准备攻击
//			attackingState = new RangeActionState( function():void{
//				_unit.attackable.showRange();
//				tileLayer.addEventListener( TileEvent.SELECT, onAttackSelectTile );
//			},  function():void{
//				tileLayer.removeEventListener( TileEvent.SELECT, onAttackSelectTile );
//				_unit.attackable.hideRange();
//				clearAction();
//			} );
		}
		
		public function bind( unit:Unit ) :void
		{
			var mapItem:IMapItem = unit.figure.mapItem;
			var node:Node = tileLayer.getNode( mapItem.row, mapItem.col );
			
			this._unit = unit;
				
			this.aBtn.able = unit.attackable as IActionable;
//			this.mBtn.able = unit.moveable   as IMoveable;
			
			updateOriginXY();
		}
		
		private function updateOriginXY() : void
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
			var sm:SkillModel, btn:IconButton;
			for (var j:int = 0; j < this._unit.skills.length; j++) 
			{
				sm = (this._unit.skills[ j ] as ISkillable).model;
				if ( sm != null ){
					btn = IconButtonMgr.get( sm.name );
					if ( btn == null ){
						//如果没有则延迟加载
						btn = IconButtonMgr.create( sm.name, sm.desc, sm.iconUrl, RangeIconButton  );
						(btn as RangeIconButton).able = this._unit.skills[ j ] as IActionable;
					}
					icons.push( btn );
				}
			}
		}
		
		//物品
		private function addStuffBtns() :void
		{
			var stuff:StuffModel, btn:IconButton;
			for (var i:int = 0; i < this._unit.stuffs.length; i++) 
			{
				stuff = (this._unit.stuffs[ i ] as IStuffable ).model;
				if ( stuff != null ){
					btn = IconButtonMgr.get( stuff.name );
					if ( btn == null ){
						//如果没有则延迟加载
						btn = IconButtonMgr.create( stuff.name, stuff.desc, stuff.iconUrl, RangeIconButton );
						(btn as RangeIconButton).able = this._unit.stuffs[ i ] as IActionable;
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
					this.view.removeChild( btn );		
				} 
				catch(error:Error) 
				{
				}
			}
			
			icons = [];
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
		}
		
		public function showAction() : void
		{
			var a:Number = 360 / icons.length; 
			
			for (var i:int = 0; i < icons.length; i++) 
			{
				runTo( icons[ i ] as DisplayObject , (90 - i * a) * conversion );	
			}
		}
		
		private function runTo( target:DisplayObject, angle:Number ) : void
		{
			target.x = oX;
			target.y = oY;
			target.scaleX = oScale;
			target.scaleY = oScale;
//			target.alpha = oAlpha;
			
			this.view.addChild( target );
			
			var x:int = oX + r * Math.cos( angle  );
			var y:int = oY - r * Math.sin( angle );
			
			TweenLite.to(target, lasttime, { x:x, y : y, scaleX : 1, scaleY : 1 } );
		}
		
		private function onCansel() : void
		{
//			setClicked
		}
		
		protected function onMoveOver(event:MouseEvent):void
		{
			this._unit.moveable.showRange();
		}
		
		protected function onMoveOut(event:MouseEvent):void
		{
			if ( clicked[ "move" ] != true )
				this._unit.moveable.hideRange();
			
			clicked[ "move" ] = false;
		}
		
		protected function onMoveClick(event:MouseEvent = null ):void
		{
			clicked[ "move" ] = true;
			//切换为准备移动状态
			stack.push( movingState );
		}
		
		protected function onMoveSelectTile( event:TileEvent ):void
		{
			if ( this._unit.moveable.canApply( event.node ) ){
				tileLayer.removeEventListener( TileEvent.SELECT, onMoveSelectTile );
				this._unit.moveable.hideRange();
				
				this._unit.moveable.applyTo( event.node, function() : void{
					//切换为移动后状态
					stack.push( movedState );
				} );
			}
			else{
				//TIP
			}
		}
		
		protected function onAttackOver(event:MouseEvent):void
		{
			this._unit.attackable.showRange();
		}
		
		protected function onAttackOut(event:MouseEvent):void
		{
			this._unit.attackable.hideRange();
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

import views.IconButton;

internal class RangeIconButton extends IconButton
{
	public var able:IActionable;
	
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
	public var tileLayer:TileLayer;
	
	public function RangeActionState()
	{
		super( onRangeEnter, onRangeExit );
	}
	
	public function bind( able:IActionable ) :void
	{
		able = able;
	}
	
	private function onRangeEnter() :  void
	{
		if ( able == null )
			return;
		
		able.showRange();
		tileLayer.addEventListener( TileEvent.SELECT, onSelectTile );
	}
	
	private function onRangeExit() :  void
	{
		if ( able == null )
			return;
		
		tileLayer.removeEventListener( TileEvent.SELECT, onSelectTile );
		able.hideRange();
		actionLayer.clearAction();
	}
	
	protected function onSelectTile(event:TileEvent):void
	{
		if ( able.canApply( event.node ) ){
			tileLayer.removeEventListener( TileEvent.SELECT, onSelectTile );
			
			able.hideRange();
			able.applyTo( event.node, function() : void{
				//切换为移动后状态
//				stack.push( movedState );
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
	private var _items:Array;
	
	public function StateStack()
	{
		_items = [];
	}
	
	public function push( status:ActionState ) :void
	{
		if ( _items.length > 0 ){
			var top:ActionState = _items[ _items.length - 1 ] as ActionState;
			status.exit( status );
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
		}
	}
}