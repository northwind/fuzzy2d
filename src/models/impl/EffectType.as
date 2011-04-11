package models.impl
{
	/**
	 * 技能或物品可以影响到的对象
	 * 任意对象可以组合  SELF & MYTEAM
	 * @author norris
	 * 
	 */	
	public class EffectType
	{
		public static const SELF:int = 0;				//自身
		public static const MYTEAM:int = 1;				//队友
		public static const FRIEND:int = 2;				//盟军
		public static const ENEMY:int = 4;				//敌军
		public static const NPC:int = 8;				//NPC
		public static const Construction:int = 16;		//建筑物
	}
}