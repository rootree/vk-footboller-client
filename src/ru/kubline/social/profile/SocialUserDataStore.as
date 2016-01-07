package ru.kubline.social.profile {

    /**
     * хранилище загруженных профайлов из соц. сети
     */
    public class SocialUserDataStore {

         private static var instance:SocialUserDataStore;

        /**
         * хранилище всех профайлов соц. сети
         */
        private var store:Object = new Object();

        public function SocialUserDataStore() {
            instance = this;
        }

        /**
         * @param id профайла
         * @return профайл по id или null
         */
        public static function get(id:Object): SocialUserData {
            return SocialUserData(instance.store[id]);
        }

        /**
         * Сохранит профайл в store
         * @param id профайла
         * @param value сам профайл
         */
        public static function put(id:Object, value:SocialUserData): void {
            instance.store[id] = value;
        }

        /**
         *
         * @param store - мапа SocialUserData
         */
        public static function setStore(store:Object): void {
            instance.store = store;
        }

        /**
         * удалит профайл из store с id
         * @param id профайла
         * @return true если профайл был удален
         */
        public static function remove(id:Object): Boolean {
            var isExist:Boolean = (instance.store[id] != null);
            if(isExist){
                delete instance.store[id];
            }
            return isExist;
        }

        /**
         * @param id профайла
         * @return true если по данному id уже хранится профайл
         */
        public static function isExist(id:Object):Boolean{
            return  (instance.store[id] != null);
        }

        /**
         * @return вернет все хранилище
         */
        public static function getStore(): Object {
            return instance.store;
        }



    }
}