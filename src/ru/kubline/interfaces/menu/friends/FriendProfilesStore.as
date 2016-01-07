package ru.kubline.interfaces.menu.friends {
import ru.kubline.gui.controls.PagingStore;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.IncommingMessageEvent;

/**
 * Хранилище профайлов друзей и подгрузка недостоющих профайлов с сервера
 * если есть необходимость
 */
public class FriendProfilesStore extends PagingStore {

    public static const TYPE_ABLE_TO_CHOOSE:uint = 1;
    public static const TYPE_UNABLE_TO_CHOOSE:uint = 2;
    public static const TYPE_ALL:uint = 3;

    public static const serverPageSize:int = 27;

    private var callback:Function;

    private static var initialData:Object = new Object();

    private static var initialTotalCount:uint;

    public static function init(data:Object, totalCount:int):void {
        initialData = data;
        initialTotalCount = totalCount;
    }

    public function FriendProfilesStore(data:Array, pageSize:int) {
        super(data, pageSize, initialTotalCount);
    }

    public static function getFrindsStore():Object{
        return initialData;
    }

    override public function loadCurPageData(callback:Function):void {
        if (getFirstIndex() < data.length) {
            super.loadCurPageData(callback);
        } else {
            this.callback = callback;
        }
    }

    private function onGetFriendListPageResult(e:IncommingMessageEvent):void {
        //        MainConnection.removeMessageListener(GetFriendListPageResult, onGetFriendListPageResult);
        //
        //        var structures:Array = GetFriendListPageResult(e.message).profileStructures;
        //        for each(var st:UserProfileStructure in structures) {
        //            var p:UserProfile = new UserProfile();
        //            p.initFromStructure(st);
        //            p.initFromSocialData(SocialUserDataStore.get(st.socialUserId));
        //            data.push(p);
        //        }
        super.loadCurPageData(callback);
    }

    public static function getFriendById(id:uint):TeamProfiler {
        return initialData[id];
    }

    public static function getFriendsByType(type:uint):Array {
        var friendsList:Array = new Array();
        for each(var st:TeamProfiler in initialData) {
            if(st.getSocialUserId() != Application.teamProfiler.getSocialUserId()){

                switch(type){
                    case FriendProfilesStore.TYPE_ABLE_TO_CHOOSE:
                        if(st.getIsAbleToChoose() ){
                            friendsList.push(st);
                        }
                        break;
                    case FriendProfilesStore.TYPE_UNABLE_TO_CHOOSE:
                        if(!st.getIsAbleToChoose()){
                            friendsList.push(st);
                        }
                        break;
                    case FriendProfilesStore.TYPE_ALL:
                        if(st.isInstalled()){
                            friendsList.push(st);
                        }
                        break;
                }

            }
        }
             sort(friendsList);
        return (friendsList);
    }

    public static function getInstalledFriends(isInstalled:Boolean):Array {
        var friendsList:Array = new Array();
        for each(var st:TeamProfiler in initialData) {
            if(st.isInstalled() == isInstalled && st.getSocialUserId() != Application.teamProfiler.getSocialUserId()){
                friendsList.push(st);
            }
        }
        return friendsList;
    }


    /**
     * Сортировка строений согласно XML
     * @param items
     */
    public static function sort(items:Array):void {
        items.sort(itemsComparator);
    }

    /**
     * Писькомер для массивов, возрашает от меньшего к большему
     * @param a
     * @param b
     * @return ar
     */
    public static function itemsComparator(a:TeamProfiler, b:TeamProfiler):int {
        if (b.getPlaceForFriend() < a.getPlaceForFriend()) {
            return 1;
        } else if (b.getPlaceForFriend() > a.getPlaceForFriend()) {
            return -1;
        } else {
            return 0;
        }
    }
    

}
}