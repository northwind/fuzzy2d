package models.impl
{
	import flash.events.EventDispatcher;
	
	/**
	 * 只存放技能信息，不处理逻辑
	 * @author norris
	 * 
	 */	
	public class SkillModel extends EventDispatcher
	{
		public var id:String;					
		public var name:String;					//名称
		public var desc:String = "";			//描述
		public var level:uint = 1;				//级别
		public var effect:int;					//对谁起作用
		public var iconUrl:String;				//icon地址
		public var range:uint = 1;				//范围
		public var rangeType:uint;				//范围类型 RangeType.CROSS
		public var animation:String;			//动画名称
		public var cost:uint;					//需要的回合数
		
		public function SkillModel( id:String )
		{
			this.id = id;
		}

	}
}