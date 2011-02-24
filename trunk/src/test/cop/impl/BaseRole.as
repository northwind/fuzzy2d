package impl
{
	public class BaseRole extends BaseEntity implements IRole
	{
		private var ai:IAIable;
		
		public function BaseRole()
		{
			//TODO: implement function
		}
		
		override public function addComponent(c:IComponent):void
		{
			super.addComponent( c );
			
			if ( c is IAIable ){
				this.ai = c as IAIable;
			}
		}
		
		public function action() : void
		{
			if ( this.ai ){
				this.ai.think();
			}
		}
	}
}