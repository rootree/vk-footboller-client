package ru.kubline.social.events {
import flash.events.Event;

    /**
     * Класс события загрузки
	 * списка друзей, которые уже добавили данное приложение
     * 
     * User: denis
     * Date: 05.11.2009
     * Time: 23:12:39
     */
    public class LoadAppFriendsEvent extends Event {

        /**
         *  информация об ошибке если произошла ошибка
         */
        private var errorMsg:Object;

        /**
         * массив айдишнеков пользователей которые добавили себе данное приложение
         */
        private var uids:Array;

        /**
         * Успешная загрузка списка друзей юзера которые добавили себе данное приложение
         */
        public static const SUCCESSFULL:String = "SUCCESSFULL";

        /**
         * если юзер запретил запршивать список друзей
         */
        public static const ACCESS_DENIED:String = "ACCESS_DENIED";

        /**
         * при ошибки загрузки списка друзей будет сгенерировано данное событие
         */
        public static const ERROR:String = "ERROR";

        public function LoadAppFriendsEvent(uids:Array, errorMsg:Object, type:String, bubbles:Boolean=false, cancelable:Boolean=false)	{
			super(type, bubbles, cancelable);
            this.uids = uids;
			this.errorMsg = errorMsg;
		}

        /**
         * @return информация об ошибке если произошла ошибка
         */
        public function getErrorMessage():Object {
            return errorMsg;
        }

        /**
         * @return массив айдишнеков пользователей которые добавили себе данное приложение
         */
        public function getUids():Array {
            return uids;
        }

        public override function clone(): Event {
			return new LoadAppFriendsEvent(uids, errorMsg, type, bubbles, cancelable);
		}

        public override function toString():String {
            if(errorMsg != null){
                return errorMsg.toString();
            }else if(uids != null){
                return uids.toString();
            }else{
                return "null";
            }
        }

    }

}