package server.impl
{
	import com.adobe.serialization.json.JSON;
	import com.norris.fuzzy.core.log.Logger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	import server.DataRequest;
	import server.IDataServer;
	import server.event.ServerEvent;
	
	public class SocketServer extends EventDispatcher implements IDataServer
	{
		private var _host:String;
		private var _port:uint; 
		
		private var _connecting:Boolean = false;
		private var _socket:Socket;
		private var _timer:Timer;
		
		private var _cn:uint = 1;					//client number
		private var _sn:uint = 0;					//server number
		
		private var _sent:Object = {};				//已发送但未接收消息队列
		private var _waitfor:Array = [];			//待发送消息队列
		
		public var timeout:uint = 10000;		//超时 10s
		
		public function SocketServer( )
		{
			super();
			
			_socket = new Socket();
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		public function config(host:String, port:uint, wait:uint=300, timeout :uint = 10000 ):void
		{
			this._host = host;
			this._port = port;
			
			this.timeout = timeout;
			
			//如果已经在运行则销毁再重建
			if ( _timer != null && _timer.running ){
				clearTimer();
			}
			
			this._timer = new Timer( wait, 0 );
			this._timer.addEventListener(TimerEvent.TIMER, onTimer );
		}
		
		public function connect() : void
		{
			if ( _socket.connected )
				return;
			if ( _connecting )
				return;
			
			_connecting = true;
			_socket.connect( this._host, this._port );
		}
		
		/**
		 *清除定时器 
		 */		
		private function clearTimer() : void
		{
			_timer.stop();
			_timer.removeEventListener( TimerEvent.TIMER, onTimer );
			_timer = null;
		}
		/**
		 * 开启定时器 
		 */		
		private function startTimer() : void
		{
			if ( _timer.running )
				return;
			
			_timer.start();
		}
		
		/**
		 *  主动关闭链接 
		 */		
		public function close() : void
		{
			if ( !_socket.connected )
				return;
			
			_socket.close();
			clearTimer();
		}

		private function onTimer( event:Event ) : void
		{
			this.send();
		}
		
		/**
		 *  立即发送消息队列 
		 */		
		public function send():void
		{
			if ( !_socket.connected || _waitfor.length == 0 )
				return;
			
			//重新复制一份
			var tmp:Array = _waitfor.slice( 0, _waitfor.length );
			_waitfor = [];
			
			//TODO 考虑返回中的序列号
			//写入客户端序列号
			for each( var req:Object in tmp ){
				req.cn = this._cn++;
				req.sn = this._sn;
				
				_sent[ req.cn ] = req; 	//做为已发送保存
			}
			
			_socket.writeUTFBytes( encode( tmp )  );
			_socket.flush();
		}
		
		/**
		 * 对消息队列编码 
		 * @param arr
		 * @return 
		 * 
		 */		
		public function encode( arr:Array ) :String
		{
			var ret:String = "";
			
			ret = JSON.encode( arr );
			
			return ret;
		}
		
		/**
		 * 对返回内容解码
		 * @param ret
		 * @return 消息队列
		 * 
		 */		
		public function decode( ret:String ) :Array
		{
			try{
				return JSON.decode( ret ) as Array;
			}catch( e:Error ){
				Logger.error( "SocketServer decode error." );
			}
			return null;
		}
		
		/**
		 * 添加消息 
		 * @param request
		 * 
		 */		
		public function add(request:Object ):void
		{
			if ( request == null )
				return;
			
			_waitfor.push( request );
		}
		
		/**
		 *  与服务器断开链接 
		 * @param event
		 * 
		 */		
		private function closeHandler(event:Event):void {
			Logger.warning( "SocketServer disconnect." );
			
			clearTimer();
			
			//失去链接
			this.dispatchEvent( new ServerEvent( ServerEvent.Disconnect, this ) );
		}
		
		/**
		 * 成功链接 
		 */		
		private function connectHandler(event:Event):void {
			Logger.info( "SocketServer connect success." );
			
			_connecting = false;
			
			startTimer();
			
			this.dispatchEvent( new ServerEvent( ServerEvent.Connect, this ) );
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Logger.error( "SocketServer 没有找到server, host = " + this._host + " port = " + this._port );
			_connecting = false;
			
			this.dispatchEvent( new ServerEvent( ServerEvent.Error, this ) );
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Logger.error( "SocketServer securityError, host = " + this._host + " port = " + this._port );
			_connecting = false;
			
			this.dispatchEvent( new ServerEvent( ServerEvent.Error, this ) );
		}
		
		//接收数据
		private function socketDataHandler(event:ProgressEvent):void {
			var str:String = this._socket.readUTFBytes( this._socket.bytesAvailable );
			
			this.dispatchEvent( new ServerEvent( ServerEvent.Receive, this ) );
			
			this.handleResponse( str );
			
		}
		
		private function handleResponse( str:String ) :void
		{
			var ret:Array = this.decode( str );
			if ( ret == null )
				return;
			
			for each( var item:Object in ret ){
				var req:Object =  _sent[ item["cn"] ];
				if (  req == null )
					continue;
				
				//从已发送中删除
				delete _sent[ item["cn"] ];
				
				//执行回调
				//参数为返回内容
				if ( req[ "callback" ] is Function )
					(req.callback as Function).call(null, req["rvalue"] );
				
				//清除
				req = null;
			}
			
			ret = null;
		}
		
	}
}