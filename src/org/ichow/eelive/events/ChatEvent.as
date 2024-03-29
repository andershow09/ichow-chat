package org.ichow.eelive.events
{
	import org.ichow.eelive.chats.SparkChat
	import org.ichow.eelive.components.HeadItem;
	import org.igniterealtime.xiff.core.UnescapedJID;
	
	import flash.events.Event;

	public class ChatEvent extends Event
	{
		public static const CHAT_STARTED:String = "newChat";
		public static const CHAT_ENDED:String = "chatClosed";
		public static const CHAT_ERROR:String = "chatError";
		
		public static const GROUP_CHAT_STARTED:String = "newGroupChat";
		
		public static const PASSWORD_ERROR:String = "passwordError";
		public static const REGISTRATION_REQUIRED_ERROR:String = "registrationRequiredError";
		public static const BANNED_ERROR:String = "bannedError";
		public static const NICK_CONFLICT_ERROR:String = "nickConflictError";
		public static const MAX_USERS_ERROR:String = "maxUsersError";
		public static const ROOM_LOCKED_ERROR:String = "roomLockedError";
		
		public var chat:SparkChat = null;
		public var jid:UnescapedJID = null;
		public var activate:Boolean = true;
		public var error:String = null;
		
		public function ChatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}