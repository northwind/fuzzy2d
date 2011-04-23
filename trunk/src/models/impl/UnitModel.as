package models.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.log.Logger;
	
	import controlers.unit.Skill;
	
	import flash.events.Event;
	
	import models.IDataModel;
	import models.event.ModelEvent;
	import models.event.UnitModelEvent;
	
	import server.*;
	
	[Event(name="change_position", type="models.event.UnitModelEvent")]
	
	public class UnitModel extends BaseModel implements IDataModel
	{
		public var id:String;
		public var name:String;
		public var level:int;
		public var figure:String;
		public var figureModel:FigureModel;
		public var visiable:Boolean;		//是否可见
		
		public var currentHP:int;				//当前HP 各个效率累加计算后的
		public var bodyHP:int;					//自身HP
		public var fixHP:int;					//装备等固定增加的HP
		public var offsetHP:int;				//使用技能等增加的会有变动的HP
		
		public var currentAttack:int;			//当前HP 各个效率累加计算后的
		public var bodyAttack:int;				//自身HP
		public var fixAttack:int;				//装备等固定增加的HP
		public var offsetAttack:int;			//使用技能等增加的会有变动的HP
		
		private var row:int;
		private var col:int;
		public var rows:uint;
		public var cols:uint;
		
		public var faction:int;
		public var team:int;
		
		public var range:int;
		public var rangeType:int;
		public var step:int;						//行动力
		public var direct:int;						//朝向
		
		private var _skills:Array;				//技能
		private var _stuffs:Array;				//物品
		private var _needLoad:Boolean;
		
		public var skills:Array;
		
		public function UnitModel( id:String, attr:Object = null )
		{
			super();
			
			this.id = id;
			//设置属性
			if ( attr != null ){
				this.setAttr( attr );
				//判断是否需要loadData
				_needLoad = this.figure == null;
				
				attr = null;
			}
		}
		
		/**
		 *  拷贝属性 
		 * @param attr
		 * 
		 */		
		protected function setAttr( attr :Object ) :void
		{
			try
			{
				for( var key:String in UnitModel._mapper){
					if ( attr[ key ] !== undefined ){
						this[ UnitModel._mapper[ key ] ] = attr[ key ];
					}
				}
			}
			catch(error:Error) {}

			//对技能做特殊处理
			_skills = attr[ "sk" ] as Array;
			if ( _skills == null ){
				_skills = [];
			}
		}
		
		public function isNeedLoad() :Boolean
		{
			return !_needLoad;
		}
		
		override public function loadData():void
		{
			//不需要加载的直接返回成功
			if ( !_needLoad ){
				this.beforeComplete();
				return;
			}
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Unit, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else{
				setAttr( value );
				
				this.beforeComplete();
			}
		}
		
		private var _related:uint;
		private function beforeComplete() : void
		{
			//skills + figure
			_related = _skills.length;
			var hasFigure:Boolean = FigureModelManager.has( this.figure );
			if ( !hasFigure ){
				_related += 1;
			}else{
				figureModel = FigureModelManager.get( this.figure );
			}
			if ( _related == 0 ){
				this.onCompleted( {} );
				return;
			}
			//load figure
			if ( !hasFigure ){
				var f:FigureModel = new FigureModel( this.figure );
				FigureModelManager.reg( this.figure, f );
				f.addEventListener(ModelEvent.COMPLETED, onRelatedCompleted );
				f.loadData();
				
				figureModel = f;
			}			
			
			//load skills
			skills = [];
			var o:Object, s:SkillModel;
			for (var i:int = 0; i < _skills.length; i++) 
			{
				o = _skills[ i ] as Object;
				if ( SkillModelManager.has( o.id ) ){
					skills.push( SkillModelManager.get( o.id ) );
					//等同于已经加载完毕
					onRelatedCompleted();
				}else{
					s = new SkillModel( o.id );
					SkillModelManager.reg( o.id, s );
					s.addEventListener(ModelEvent.COMPLETED, onRelatedCompleted );
					s.loadData();
					
					skills.push( s );
				}
			}
		}
		
		private function onRelatedCompleted( event:ModelEvent = null ):void
		{
			if ( event != null )
				event.model.removeEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
			
			_related--;
			
			if ( _related <= 0 ){
				this.onCompleted( {} );
			}
		}
		
		public function getSkill( index:uint ) :SkillModel
		{
			return _skills[ index ] as SkillModel;	
		}
		
		public function get skillCount() :uint
		{
			return _skills.length;
		}
		
		public function moveTo( row:int, col:int ) :void
		{
			this.row = row;
			this.col = col;
		}
		
		//待机
		public function standby(  row:int, col:int ) :void
		{
			_row = row;
			_col  = col;
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Battle, 
				{ action : "standby", id:this.id, row:row, col:col }, null, null ) );
		}
		
		//攻击
		public function attack( to:UnitModel, row:int, col:int ) :void
		{
			_row = row;
			_col  = col;
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Battle, 
				{ action : "attack", id:this.id, row:row, col:col, to:to.id }, null, null ) );
		}
		
		//使用技能
		public function useSkill( n:uint, to:UnitModel, row:int, col:int ) :void
		{
			if ( n >= _skills.length )
				return;
			
			_row = row;
			_col  = col;
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Battle, 
				{ action : "skill", id:this.id, row:row, col:col, to:to.id }, null, null ) );
		}
		
		//使用物品
		public function useStuff( n:uint, to:UnitModel, row:int, col:int ) :void
		{
			if ( n >= _stuffs.length )
				return;
			
			_row = row;
			_col  = col;
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Battle, 
				{ action : "stuff", id:this.id, row:row, col:col, to:to.id }, null, null ) );
		}
		
		private static const _mapper : Object =  {
			r : "_row", c : "_col", cH : "currentHP", bH : "bodyHP", fH : "fixHP", oH : "offsetHP",
			cA : "currentHP", bA : "bodyHP", fA : "fixHP", oA : "offsetHP",　fa : "faction", tm : "team",
			v : "visiable", na : "name", fg : "figure", lv : "level",  st : "step",  rt : "rangeType",
			rg :"range", d : "direct", rs:"rows", cs:"cols"
		}
		
	}
}