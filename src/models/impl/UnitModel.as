package models.impl
{
	import models.IDataModel;
	
	import server.*;
	
	public class UnitModel extends BaseModel implements IDataModel
	{
		public var id:String;
		public var name:String;
		public var level:int;
		public var figure:String;
		public var visiable:Boolean;		//是否可见
		
		public var currentHP:int;				//当前HP 各个效率累加计算后的
		public var bodyHP:int;					//自身HP
		public var fixHP:int;					//装备等固定增加的HP
		public var offsetHP:int;				//使用技能等增加的会有变动的HP
		
		public var currentAttack:int;			//当前HP 各个效率累加计算后的
		public var bodyAttack:int;				//自身HP
		public var fixAttack:int;				//装备等固定增加的HP
		public var offsetAttack:int;			//使用技能等增加的会有变动的HP
		
		public var row:int;
		public var col:int;
		
		public var faction:int;
		public var team:int;
		
		public var range:int;
		public var rangeType:int;
		public var step:int;						//行动力
		public var direct:int;						//朝向
		
		private var _skills:Array;
		private var _needLoad:Boolean;
		
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
			_skills = [];
			var skills:Array = attr[ "sk" ] as Array;
			if ( skills ){
				for (var i:int = 0; i < skills.length; i++) 
				{
					_skills.push( SkillModelManager.get( skills[i] ) );
				}
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
				this.onCompleted( {} );
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
				this.setAttr( value );
				
				this.onCompleted( value );
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
		
		private static const _mapper : Object =  {
			r : "row", c : "col", cH : "currentHP", bH : "bodyHP", fH : "fixHP", oH : "offsetHP",
			cA : "currentHP", bA : "bodyHP", fA : "fixHP", oA : "offsetHP",　fa : "faction", tm : "team",
			v : "visiable", na : "name", fg : "figure", lv : "level",  rt : "step",  rt : "rangeType",
			rg :"range", d : "direct"
		}
		
	}
}