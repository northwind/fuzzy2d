package impl
{
	public class BaseAttack extends BaseComponent implements IAttackable
	{
		public var figure:IFigure;
		
		public function BaseAttack()
		{
			super();
		}
		
		public function attack(name:String):void
		{
			trace( "BaseAttack attack : " + name );
			if ( this.figure )
				this.figure.attack( "up" , null );
		}
	}
}