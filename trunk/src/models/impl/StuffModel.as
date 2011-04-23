package models.impl
{
	import flash.events.EventDispatcher;
	import models.IDataModel;
	import server.DataRequest;
	import server.ProxyServer;
	
	/**
	 * 物品信息
	 * @author norris
	 */	
	public class StuffModel extends BaseModel implements IDataModel
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
		
		public function StuffModel( id:String )
		{
			this.id = id;
		}

		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Skill, { id:this.id }, null, onResponse ) );
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
		
		/**
		 *  拷贝属性 
		 * @param attr
		 * 
		 */		
		protected function setAttr( attr :Object ) :void
		{
			try
			{
				for( var key:String in StuffModel._mapper){
					if ( attr[ key ] !== undefined ){
						this[ StuffModel._mapper[ key ] ] = attr[ key ];
					}
				}
			}
			catch(error:Error) {}
		}
		
		private static const _mapper : Object =  {
			na : "name", rt : "rangeType",	rg :"range", de : "desc", ef : "effect",
			im : "iconUrl", an : "animation", ct : "cost", lv : "level"
		}
	}
}