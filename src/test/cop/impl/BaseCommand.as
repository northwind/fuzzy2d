package impl
{
	import flash.utils.Dictionary;

	public class BaseCommand extends BaseComponent implements ICommandable
	{
		private var commands:Dictionary = new Dictionary();
		
		public function BaseCommand()
		{
			super();
		}
		
		public function reg(name:String, callback:Function):void
		{
			commands[ name ] = callback;
		}
		
		public function excute(method:String, params:Array, callback:Function = null ):void
		{
			if ( commands.hasOwnProperty( method ) ){
				if ( callback != null && params != null ){
					params.push( callback );
				}
				(commands[ method ] as Function).apply( null, params );
			}else{
				if ( callback != null )
					callback.call();
			}
		}
	}
}