package models.impl
{
	import models.IDataModel;
	import com.norris.fuzzy.map.item.MapItemType;
	import server.DataRequest;
	import server.ProxyServer;
	
	public class FigureModel extends BaseModel
	{
		public var id:String;
		public var type:int;		//MapItemType
		
		public var url :String;		//统一地址，不同symbol
		public var symbol:String;
		
		public var offsetX:int;
		public var offsetY:int;
		
		public var rows:int;
		public var cols:int;
		
		public function FigureModel( id:String )
		{
			super();
			this.id = id;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Figure, { id:this.id }, null, onResponse ) );
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
				for( var key:String in FigureModel._mapper){
					if ( attr[ key ] !== undefined ){
						this[ FigureModel._mapper[ key ] ] = attr[ key ];
					}
				}
			}
			catch(error:Error) {}
		}
		
		private static const _mapper : Object =  {
			fg : "url", sb:"symbol", oX :"offsetX", oY:"offsetY", rs :"rows", cs :"cols", tp:"type"
		}
			
	}
}