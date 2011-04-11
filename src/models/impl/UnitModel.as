package models.impl
{
	import models.IDataModel;
	
	import server.*;
	
	public class UnitModel extends BaseModel implements IDataModel
	{
		public var id:String;
		public var name:String;
		
		public var currentHP:int;				//当前HP 各个效率累加计算后的
		public var bodyHP:int;					//自身HP
		public var fixHP:int;					//装备等固定增加的HP
		public var offsetHP:int;				//使用技能等增加的会有变动的HP
		
		public var currentAttack:int;			//当前HP 各个效率累加计算后的
		public var bodyAttack:int;				//自身HP
		public var fixAttack:int;				//装备等固定增加的HP
		public var offsetAttack:int;			//使用技能等增加的会有变动的HP
		
		private var _skills:Array;
		
		public function UnitModel( id:String, attr:Object = null )
		{
			super();
			
			this.id = id;
			//设置属性
			if ( attr != null ){
				
			}
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Unit, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else
				this.onCompleted( value );
		}
		
		public function getSkill( index:uint ) :SkillModel
		{
			return _skills[ index ] as SkillModel;	
		}
		
		public function get skillCount() :uint
		{
			return _skills.length;
		}
			
		
	}
}