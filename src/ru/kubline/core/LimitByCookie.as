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
     * ��� ������� � �������, ��������� �����  ������� ������� ������ �� ����. ������ ��� ��������, ������ �� ����� ��� ���
     */
    private var NAME_OBJ_FIRST_BURN_TIME:String ;

    /**
     * ��� ������� � �������, ��������� ������� ������� ������. ������ ��� �������� ����,������� ������ ��� ����� �������
     */
    private var NAME_OBJ_COUNT_OF_BURNS:String;

    public var objWithFirstBurnTime:Object;
    public var objWithCountOfBurns:Object;

    private var limit:uint;

    public function initForCurrentUser():void {
        
        objWithFirstBurnTime = Cookie.getValue(NAME_OBJ_FIRST_BURN_TIME, null);
        objWithCountOfBurns = Cookie.getValue(NAME_OBJ_COUNT_OF_BURNS, null);

        var currentData:Date = new Date();

        if (!objWithFirstBurnTime) { // ���� ������� ��� ���, �� ������� ��
 
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
        if (!objWithFirstBurnTime) { // ���� ������� ��� ���, �� ������� ��
            createObjectsForCookie();
            Cookie.setValue(NAME_OBJ_FIRST_BURN_TIME, objWithFirstBurnTime);
            Cookie.setValue(NAME_OBJ_COUNT_OF_BURNS, objWithCountOfBurns);
        }
        setCountOfBurnsForFriendList();
    }

    /**
     * ��������� ������� ��� �����, � ������� �������� id-����� ������, �����, ����� ��� ���������� ������ ������ (���� �� ������ ������, �� 0),
     * � ���������� ��������� ��� ������������� ������
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

        if (objWithFirstBurnTime[friend.getSocialUserId()]) {  // ������ �� ������ ��� ���� � �������
            if (currentDate.getDate() != burnDate.getDate()) {
                objWithFirstBurnTime[friend.getSocialUserId()] = currentDate.toString();
                objWithCountOfBurns[friend.getSocialUserId()] = limit;
            }
        } else { // ����� ������ ��� ��������� � ������. ���� �������� ��� ������ � ������

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

        // ���� ��� ������ �������
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