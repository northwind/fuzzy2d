package impl
{
	public class BaseRole extends BaseEntity implements IRole
	{
		private var command:ICommandable;
		
		public function BaseRole( command:ICommandable )
		{
			this.command = command;
			this.addComponent( command );
		}
		
		public function action( method:String, params:Array, callback:Function = null ) : void
		{
			if ( this.command ){
				this.command.excute( method, params, callback );	
			}else{
				if ( callback != null )
					callback.call( null );
			}
		}
	}
}