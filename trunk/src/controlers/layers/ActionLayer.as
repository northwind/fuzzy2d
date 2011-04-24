package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.unit.Unit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import views.IconButton;
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
			this.craeteAction();
		}
		
		public function bind( unit:Unit ) :void
		{
			this._unit = unit;
			
			var mapItem:IMapItem = this._unit.figure.mapItem;
			var node:Node = tileLayer.getNode( mapItem.row, mapItem.col );
			
			this.oX = node.x - 24;
			this.oY = node.y - 48;
		}
		
		public function unbind() : void
		{
			this._unit = null;
		}
		
		private function craeteAction() : void
		{
			_icons = {};
			
			//设置弹出菜单按钮
			var mBtn:IconButton = new IconButton( "移动" );
			mBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_move" );
			IconButtonMgr.reg( "move", mBtn );
			
			var sBtn:IconButton = new IconButton( "待机" );
			sBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_standby" );
			IconButtonMgr.reg( "standby", sBtn );
			
			var aBtn:IconButton = new IconButton( "攻击" );
			aBtn.dataSource = MyWorld.instance.resourceMgr.getResource( "unit_attack" );
			IconButtonMgr.reg( "attack", aBtn );
			
			_icons[ 90 ] = mBtn;
			_icons[ 45 ] = aBtn;
			_icons[ -90 ] = sBtn;
		}
		
		public function showAction() : void
		{
			if ( this._unit == null )
				return;
			
			for( var angle:String in _icons ){
				runTo( _icons[ angle ] as DisplayObject , parseFloat( angle ) * conversion );	
			}
		}
		
		public function hideAction() : void
		{
			while( this.view.numChildren > 0 )
				this.view.removeChildAt( 0 );
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