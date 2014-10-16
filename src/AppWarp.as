
import com.adobe.serialization.json.JSON;
import com.shephertz.appwarp.WarpClient;
import com.shephertz.appwarp.listener.ConnectionRequestListener;
import com.shephertz.appwarp.listener.NotificationListener;
import com.shephertz.appwarp.listener.RoomRequestListener;
import com.shephertz.appwarp.listener.ZoneRequestListener;
import com.shephertz.appwarp.messages.Chat;
import com.shephertz.appwarp.messages.LiveResult;
import com.shephertz.appwarp.messages.LiveRoom;
import com.shephertz.appwarp.messages.LiveUser;
import com.shephertz.appwarp.messages.Lobby;
import com.shephertz.appwarp.messages.MatchedRooms;
import com.shephertz.appwarp.messages.Move;
import com.shephertz.appwarp.messages.Room;
import com.shephertz.appwarp.types.ResultCode;

import flash.utils.ByteArray;

var APIKEY:String = "Your API Key";
var SECRETEKEY:String = "Your Secret Key";
var Connected:Boolean = false;
var INITIALIZED:Boolean = false;
var client:WarpClient;
var roomID:String;
var State:int = 0;
var User:String;

class connectionListener implements ConnectionRequestListener
{	
	private var connectFunc:Function;
	
	public function connectionListener(f:Function)
	{
		connectFunc = f;
	}
	
	public function onConnectDone(res:int, reason:int):void
	{
		if(res == ResultCode.success)
		{
			Connected = true;
		}
		else
		{
			Connected = false;
		}
		
		connectFunc(res);
	}
	
	public function onDisConnectDone(res:int):void
	{
		Connected = false;
	}
	
	public function onInitUDPDone(res:int):void
	{
		
	}
}

class roomListener implements RoomRequestListener
{
	private var connectFunc:Function;
	private var joinFunc:Function;
	
	public function roomListener(f:Function,f1:Function)
	{
		connectFunc = f;
		joinFunc = f1;
	}
	
	public function onSubscribeRoomDone(event:Room):void
	{
		if(State == 2)
			joinFunc();
		else
			connectFunc();
	}
	public function onUnsubscribeRoomDone(event:Room):void
	{
	
	}
	public function onJoinRoomDone(event:Room):void
	{
		if(event.result == ResultCode.resource_not_found)
		{
			if(State == 1)
			{
				State = 3;
			}
			client.createRoom("room","admin",2,null);
		}
		else if(event.result == ResultCode.success)
		{
			if(State == 1)
			{
				State = 2;	
			}
			roomID = event.roomId;
			client.subscribeRoom(roomID);
		}
	}
	public function onLeaveRoomDone(event:Room):void
	{
		client.unsubscribeRoom(roomID);
	}
	public function onGetLiveRoomInfoDone(event:LiveRoom):void
	{
		
	}
	public function onSetCustomRoomDataDone(event:LiveRoom):void
	{
		
	}
	public function onUpdatePropertyDone(event:LiveRoom):void
	{
		
	}
	
	public function onLockPropertiesDone(result:int):void
	{
		
	}
	public function onUnlockPropertiesDone(result:int):void
	{
		
	}
	public function onUpdatePropertiesDone(event:LiveRoom):void
	{
		
	}
}

class zoneListener implements ZoneRequestListener
{	
	public function onCreateRoomDone(event:Room):void
	{
		roomID = event.roomId;
		client.joinRoom(roomID);
	}
	
	public function onDeleteRoomDone(event:Room):void
	{
			
	}
	
	public function onGetLiveUserInfoDone(event:LiveUser):void
	{
		
	}
	
	public function onGetAllRoomsDone(event:LiveResult):void
	{
		
	}
	public function onGetOnlineUsersDone(event:LiveResult):void
	{
		
	}
	public function onSetCustomUserInfoDone(event:LiveUser):void
	{
		
	}
	
	public function onGetMatchedRoomsDone(event:MatchedRooms):void
	{
		
	}
}

class notifylistener implements NotificationListener
{
	private var joinFunc:Function;
	private var msgFunc:Function;
	private var leaveFunc:Function;
	
	public function notifylistener(f:Function)
	{
		joinFunc = f;
	}
	
	public function msgListener(f:Function,f1:Function):void
	{
		msgFunc = f;
		leaveFunc = f1;
	}
	
	public function onRoomCreated(event:Room):void
	{
		
	}
	public function onRoomDestroyed(event:Room):void
	{
		
	}
	public function onUserLeftRoom(event:Room, user:String):void
	{
		if(user != User)
		{
			leaveFunc();
		}
	}
	public function onUserJoinedRoom(event:Room, user:String):void
	{
		if(State == 3)
			joinFunc();
	}
	public function onUserLeftLobby(event:Lobby, user:String):void
	{
		
	}
	public function onUserJoinedLobby(event:Lobby, user:String):void
	{
				
	}
	public function onChatReceived(event:Chat):void
	{
		if(event.sender != User)
		{
			var obj:Object = com.adobe.serialization.json.JSON.decode(event.chat);
			msgFunc(obj);
		}
	}
	public function onUpdatePeersReceived(update:ByteArray, isUDP:Boolean):void
	{
			
	}
	public function onUserChangeRoomProperty(room:Room, user:String,properties:Object):void
	{
		
	}
	public function onPrivateChatReceived(sender:String, chat:String):void
	{
		
	}
	public function onPrivateUpdateReceived(sender:String, update:ByteArray, isUDP:Boolean):void
	{
		
	}
	public function onUserChangeRoomProperties(room:Room, user:String,properties:Object, lockTable:Object):void
	{
		
	}
	public function onMoveCompleted(move:Move):void
	{
		
	}
	public function onUserPaused(locid:String, isLobby:Boolean, username:String):void
	{
		
	}
	public function onUserResumed(locid:String, isLobby:Boolean, username:String):void
	{
		
	}
	public function onGameStarted(sender:String, roomid:String, nextTurn:String):void
	{
		
	}
	public function onGameStopped(sender:String, roomid:String):void
	{
		
	}
	public function onNextTurnRequest(lastTurn:String):void
	{
		
	}
}

package
{
	import com.adobe.serialization.json.JSON;
	import com.shephertz.appwarp.WarpClient;

	public class AppWarp
	{	
		public static var _roomlistener:roomListener;
		public static var _zonelistener:zoneListener;
		public static var _notifylistener:notifylistener;
		public static var _connectionlistener:connectionListener;
		
		private static function generateRandomString(strlen:Number):String{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var num_chars:Number = chars.length - 1;
			var randomChar:String = "";
			for (var i:Number = 0; i < strlen; i++){
				randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
			}
			return randomChar;
		}

		public static function connect(f:Function):void
		{
			if(INITIALIZED == false)
			{
				WarpClient.initialize(APIKEY, SECRETEKEY);
				client = WarpClient.getInstance();
				INITIALIZED = true;
			}
			
			if(Connected == false)
			{
				_connectionlistener = new connectionListener(f);
				client.setConnectionRequestListener(_connectionlistener);
				User = generateRandomString(16);
				client.connect(User);
			}
			else
				f(0);
		}
		
		public static function join(f1:Function, f2:Function):void
		{
			_roomlistener = new roomListener(f1,f2);
			_zonelistener = new zoneListener();
			_notifylistener = new notifylistener(f2);
			
			client.setRoomRequestListener(_roomlistener);
			client.setZoneRequestListener(_zonelistener);
			client.setNotificationListener(_notifylistener);
			
			State = 1;
			client.joinRoomInRange(1,1,true);
		}
		
		public static function leave():void
		{
			client.leaveRoom(roomID);
		}
		
		public static function begin(f:Function, f1:Function, dir:int, x:int, y:int):void
		{
			_notifylistener.msgListener(f, f1);
			send(0,dir,x,y);
		}
		
		public static function move(dir:int,x:int,y:int):void
		{
			send(1,dir,x,y);
		}
		
		public static function eat(dir:int,x:int,y:int):void
		{
			send(2,dir,x,y);
		}
		
		public static function send(type:int,dir:int,x:int,y:int):void
		{
			if(Connected == true)
			{
				var obj:Object = new Object();
				obj.type = type;
				obj.dir = dir;
				obj.x = x;
				obj.y = y;
				
				client.sendChat(com.adobe.serialization.json.JSON.encode(obj));
			}
		}
	}
}