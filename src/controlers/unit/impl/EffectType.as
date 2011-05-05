package controlers.unit.impl
{
	/**
	 * 技能或物品可以影响到的对象
	 * 任意对象可以组合  SELF & MYTEAM
	 * @author norris
	 * 
	 */	
	public class EffectType
	{
		public static const NONE:int = -1;				//无
		public static const SELF:int = 1;				//自身
		public static const BROTHER:int = 2;				//队友
		public static const FRIEND:int = 4;				//盟军
		public static const ENEMY:int = 8;				//敌军
		public static const NPC:int = 16;				//NPC
		public static const Construction:int = 32;		//建筑物
	}
}