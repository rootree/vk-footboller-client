package ru.kubline.social.events {

    /**
     * Класс содержит события для контроллеров социальной сети
     * 
     * @autor denis
     */
    public class LoadUserSettingsEvent {

        /**
         * успешная загрузка настроек приложения
         */
        public static const ACCESS_ALLOWED:String = "ACCESS_ALLOWED";

        /**
         * если юзер запретил какие либо действия
         * приложения, например запршивать список друзей
         */
        public static const ACCESS_DENIED:String = "ACCESS_DENIED";

        public function LoadUserSettingsEvent() {
            
        }
    }
}