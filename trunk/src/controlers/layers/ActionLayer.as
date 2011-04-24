package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.unit.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import models.impl.SkillModel;
	import models.impl.StuffModel;
	
	import views.IconButton;
	import views.BlowIconButton;
	import views.IconButtonMgr;

	/**
	 * 角色操作层 
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
		private var _icons:Object;
		
		private var mBtn:IconButton;
		private var aBtn:IconButton;
		private var sBtn:IconButton;
		
		public var tileLayer:TileLayer;
		
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
			mBtn = new BlowIconButton( "移动" );
			mBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_move" );
			IconButtonMgr.reg( "move", mBtn );
			
			sBtn = new BlowIconButton( "待机" );
			sBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_standby" );
			IconButtonMgr.reg( "standby", sBtn );
			
			aBtn = new BlowIconButton( "攻击" );
			aBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_attack" );
			IconButtonMgr.reg( "attack", aBtn );			
		}
		
		private function createIconButton( name:String, tips:String, url:String ) :IconButton
		{
			var ret:BlowIconButton = new BlowIconButton( tips );
			ret.dataSource = MyWorld.instance.resourceMgr.add( name, url );
			return ret;
		}
		
		public function bind( unit:Unit ) :void
		{
			var mapItem:IMapItem = unit.figure.mapItem;
			var node:Node = tileLayer.getNode( mapItem.row, mapItem.col );
			
			this.oX = node.x - 24;
			this.oY = node.y - 48;
			
			//当更换对象时才重新创建
			if ( unit != this._unit ){
				this._unit = unit;
				this.craeteAction();
			}
		}
		
		public function unbind() : void
		{
			this._unit = null;
			
			//删除
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
		}
		
		private function craeteAction() : void
		{
			if ( this._unit  == null ) return;
			
			_icons = {};
			_icons[ -135 ] = sBtn;		//待机
			
			//移动
			if ( this._unit.moveable != null )
				_icons[ 90 ] = mBtn;
			//攻击
			if ( this._unit.attackable != null )
				_icons[ 45 ] = aBtn;
			//技能
			var sm:SkillModel, btn:IconButton;
			for (var j:int = 0; j < this._unit.skills.length; j++) 
			{
				sm = (this._unit.skills[ i ] as ISkillable).model;
				if ( sm != null ){
					btn = IconButtonMgr.get( sm.name );
					if ( btn == null ){
						//如果没有则延迟加载
						btn =  createIconButton( sm.name, sm.desc, sm.iconUrl );
					}
					_icons[ 0 - j * 45 ] = btn;
				}
			}
			//物品
			var stuff:StuffModel;
			for (var i:int = 0; i < this._unit.stuffs.length; i++) 
			{
				stuff = (this._unit.stuffs[ i ] as IStuffable ).model;
				if ( stuff != null ){
					btn = IconButtonMgr.get( stuff.name );
					if ( btn == null ){
						//如果没有则延迟加载
						btn =  createIconButton( stuff.name, stuff.desc, stuff.iconUrl );
					}
					_icons[ -180 - i * 45 ] = btn;
				}
			}
			
		}
		
		public function showAction() : void
		{
			if ( this._unit == null )
				return;
			
			this.view.visible = true;
			
			for( var angle:String in _icons ){
				runTo( _icons[ angle ] as DisplayObject , parseFloat( angle ) * conversion );	
			}
		}
		
		public function hideAction() : void
		{
			this.view.visible = false;
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
		}
		
	}
}