package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	/**
	 * 技能管理器，所有的技能都存放在这里
	 * DEMO期间写死，后期考虑延迟加载脚本方式实现
	 * @author norris
	 * 
	 */	
	public class SkillModelManager
	{
		private static var _items:BaseManager = new BaseManager();
		
		public function SkillModelManager()
		{
		}
		
		public static function reg( id:String, skill:SkillModel ) : void
		{
			SkillModelManager._items.reg( id, skill );
		}
		
		public static function unreg( id:String ) :void
		{
			SkillModelManager._items.unreg( id );
		}
		
		public static function has( id:String ) :Boolean
		{
			return SkillModelManager._items.has( id );
		}
		
		public static function get( id:String ) : SkillModel
		{
			return SkillModelManager._items.find( id ) as SkillModel ;
		}
		
	}
}