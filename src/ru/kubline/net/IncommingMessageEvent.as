package ru.kubline.net {
import flash.events.Event;

/**
     * ивент который будет рассылаться когда пришло сообщение с сервера и успешно десериализовалось
     * @autor denis
     */
    public class IncommingMessageEvent extends Event {

        /**
         * входящее сообщение
         */
		public var message: Object;

		public function IncommingMessageEvent(message: Object, type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.message = message;
		}

		public override function clone(): Event {
			return new IncommingMessageEvent(message, type, bubbles, cancelable);
		}
    }

}