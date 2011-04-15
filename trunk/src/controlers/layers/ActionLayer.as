package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.DisplayObject;
	import flash.geom.*;
	
	import views.IconButtonMgr;
	import controlers.unit.Unit;

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
		private var r:Number = 150;			//半径
		private var oScale:Number = 0.1;	//变形比率
		private var oAlpha:Number = 0.5;	//透明度
		private var conversion:Number = Math.PI/180;
		
		private var _icons:Object;
		
		public function ActionLayer()
		{
			super();
		}
		
		public function bind( unit:Unit ) :void
		{
			this._unit = unit;
		}
		
		private function craeteAction() : void
		{
			_icons = {};
			_icons[ 90 ] = IconButtonMgr.get( "move" );
			_icons[ 45 ] = IconButtonMgr.get( "attack" );
			_icons[ -90 ] = IconButtonMgr.get( "standby" );
		}
		
		public function showAction() : void
		{
			if ( this._unit == null )
				return;
			
			this.craeteAction();
		
			for( var angle:String in _icons ){
				runTo( _icons[ angle ] as DisplayObject , (angle as Number) * conversion );	
			}
		}
		
		public function hideAction() : void
		{
		}

		private function runTo( target:DisplayObject, angle:Number ) : void
		{
			target.x = oX;
			target.y = oY;
			target.scaleX = oScale;
			target.scaleY = oScale;
			target.alpha = oAlpha;
			
			this.view.addChild( target );
			
			var x:int = oX + r * Math.cos( angle  );
			var y:int = oY - r * Math.sin( angle );
			
			TweenLite.to(target, 0.7, { x:x, y : y, scaleX : 1, scaleY : 1, alpha: 1 } );
		}
		
		private function onCansel() : void
		{
		}
		
	}
}