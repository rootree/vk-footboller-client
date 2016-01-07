package ru.kubline.core {
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.model.TeamProfiler;

public class LimitByCookie {

    public function LimitByCookie(nameCount:String, nameFirstTime:String, limit:uint) {
        NAME_OBJ_FIRST_BURN_TIME = nameFirstTime;
        NAME_OBJ_COUNT_OF_BURNS = nameCount;
        this.limit = limit;
    }

    /**
     * имя объекта в кукисах, хранящего время  первого поджога здания из трех. служит для проверки, прошли ли сутки или нет
     */
    private var NAME_OBJ_FIRST_BURN_TIME:String ;

    /**
     * имя объекта в кукисах, хранящего счетчик поджога зданий. служит для проверки того,сколько зданий еще можно поджечь
     */
    private var NAME_OBJ_COUNT_OF_BURNS:String;

    public var objWithFirstBurnTime:Object;
    public var objWithCountOfBurns:Object;

    private var limit:uint;

    public function initForCurrentUser():void {
        
        objWithFirstBurnTime = Cookie.getValue(NAME_OBJ_FIRST_BURN_TIME, null);
        objWithCountOfBurns = Cookie.getValue(NAME_OBJ_COUNT_OF_BURNS, null);

        var currentData:Date = new Date();

        if (!objWithFirstBurnTime) { // если кукисов еще нет, то создаем их
 
            objWithFirstBurnTime = new Object();
            objWithCountOfBurns = new Object();

            objWithFirstBurnTime[Application.teamProfiler.getSocialUserId()] = currentData.toString();
            objWithCountOfBurns[Application.teamProfiler.getSocialUserId()] = limit;

            Cookie.setValue(NAME_OBJ_FIRST_BURN_TIME, objWithFirstBurnTime);
            Cookie.setValue(NAME_OBJ_COUNT_OF_BURNS, objWithCountOfBurns);
        }

        setCurrentProfile(currentData, Application.teamProfiler);

    }

    public function init():void {
        objWithFirstBurnTime = Cookie.getValue(NAME_OBJ_FIRST_BURN_TIME, null);
        objWithCountOfBurns = Cookie.getValue(NAME_OBJ_COUNT_OF_BURNS, null);
        if (!objWithFirstBurnTime) { // если кукисов еще нет, то создаем их
            createObjectsForCookie();
            Cookie.setValue(NAME_OBJ_FIRST_BURN_TIME, objWithFirstBurnTime);
            Cookie.setValue(NAME_OBJ_COUNT_OF_BURNS, objWithCountOfBurns);
        }
        setCountOfBurnsForFriendList();
    }

    /**
     * формируем объекты для кукис, в которых хранятся id-шники друзей, время, когда они обворовали первое здание (если ни одного здания, то 0),
     * и количество доступных для обворовывания зданий
     */
    private function createObjectsForCookie():void {

        var currentData:Date = new Date();

        objWithFirstBurnTime = new Object();
        objWithCountOfBurns = new Object();

        for each(var friend:TeamProfiler in FriendProfilesStore.getFrindsStore()) {
            if (friend.getSocialUserId() == Application.teamProfiler.getSocialUserId())
                continue;

            objWithFirstBurnTime[friend.getSocialUserId()] = currentData.toString();
            objWithCountOfBurns[friend.getSocialUserId()] = limit;
        }
    }


    private function setCountOfBurnsForFriendList():void {
        var currentDate:Date = new Date();

        for each(var friend:TeamProfiler in FriendProfilesStore.getFrindsStore()) {
            if (friend.getSocialUserId() == Application.teamProfiler.getSocialUserId())
                continue;
            setCurrentProfile(currentDate, friend);
        }
    }

    public function setCurrentProfile(currentDate:Date, friend:TeamProfiler):void {
        
        var burnDate:Date= new Date(objWithFirstBurnTime[friend.getSocialUserId()]);

        if (objWithFirstBurnTime[friend.getSocialUserId()]) {  // данные об игроке уже есть в кукисах
            if (currentDate.getDate() != burnDate.getDate()) {
                objWithFirstBurnTime[friend.getSocialUserId()] = currentDate.toString();
                objWithCountOfBurns[friend.getSocialUserId()] = limit;
            }
        } else { // игрок только что добавился в друзья. надо записать его данные в кукисы

            objWithFirstBurnTime[friend.getSocialUserId()] = currentDate.toString();
            objWithCountOfBurns[friend.getSocialUserId()] = limit;
            Cookie.setValue(NAME_OBJ_FIRST_BURN_TIME, objWithFirstBurnTime);
            Cookie.setValue(NAME_OBJ_COUNT_OF_BURNS, objWithCountOfBurns);
        }
    }

    public function isAvailableBurn(friendId:uint):Boolean {

        var currentDate:Date = new Date();
        var friend:TeamProfiler = FriendProfilesStore.getFriendById(friendId);

        setCurrentProfile(currentDate, friend);
        var countOfBurns:uint = uint(objWithCountOfBurns[friendId]);
        if (countOfBurns > 0) {
            return true;
        }

        // если уже нельзя поджечь
        return false;
    }

    public function decreaseCountOfBurns(friendId:uint):void {
        
        var currentDate:Date = new Date();
        var friend:TeamProfiler = FriendProfilesStore.getFriendById(friendId);
        var countOfBurns:uint = uint(objWithCountOfBurns[friendId]);
        countOfBurns--;
        objWithCountOfBurns[friendId] = countOfBurns;

        Cookie.setValue(NAME_OBJ_FIRST_BURN_TIME, objWithFirstBurnTime);
        Cookie.setValue(NAME_OBJ_COUNT_OF_BURNS, objWithCountOfBurns);

    }

}
}