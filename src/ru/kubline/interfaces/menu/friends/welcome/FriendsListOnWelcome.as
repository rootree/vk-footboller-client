package ru.kubline.interfaces.menu.friends.welcome {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.controllers.Singletons;
import ru.kubline.events.WelcomeEvent;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;

public class FriendsListOnWelcome extends UIPagingMenu{

    private static var avableCountFriends:uint = Footballer.MAX_TEAM;

    private var friensCount:TextField;

    private var finishBtn:UISimpleButton;
    private var closeTextBtn:UISimpleButton;

    private var selectedFriends:Object;

    private var ableToChoose:MovieClip;

    private var enableToChoose:MovieClip;

    /**
     * список профайлов юзеров из списка друзей
     */
    private var profiles:Array = new Array();

    public function FriendsListOnWelcome(container:MovieClip) {

        ableToChoose = MovieClip(container.getChildByName("ableToChoose"));
        enableToChoose = MovieClip(container.getChildByName("enableToChoose"));

        super(ableToChoose);

        finishBtn = new UISimpleButton(SimpleButton(container.getChildByName("finishBtn")));
        finishBtn.addHandler(onFinishClick);

        friensCount = TextField(ableToChoose.getChildByName("friensCount"));
        friensCount.text = getFrintCount(avableCountFriends);

        selectedFriends = new Object();
    }

    private function getFrintCount(counert:uint):String{
        return counert + ' ' + Messages.chooseEnding(counert, 'друзей', 'друг', 'друга');
    }

    override public function show():void {

        var friendForChoose:Array = FriendProfilesStore.getFriendsByType(FriendProfilesStore.TYPE_ABLE_TO_CHOOSE);

        ableToChoose.visible = Boolean(friendForChoose.length);
        enableToChoose.visible = Boolean(!friendForChoose.length);

        if(friendForChoose.length){
            this.store = new FriendProfilesStore(friendForChoose, cellsContainer.numChildren);
            setPage(1);
        }

    }

    private function onFinishClick(event:MouseEvent):void {
        dispatchEvent(new Event(WelcomeEvent.FINISH));
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var friend:FriendsItem = new FriendsItem(MovieClip(cell));
        friend.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return friend;
    }

    override public function setData(data:Array):void {
        throw new IllegalOperationError();
    }

    /**
     * Действие при шелчке по элементу магазина
     * @param e
     */
    private function onItemClick(e:Event):void {

        var friend:FriendsItem = FriendsItem(e.target);

        if(friend.getUserProfile()){
            var friendName:String = UserProfileHelper.getNameTextByProfile(friend.getUserProfile());

            if(Application.teamProfiler.getFootballerById(friend.getUserProfile().getSocialUserId())){
                friend.setSelected(false);
                avableCountFriends ++;
                Application.teamProfiler.dropFootballerById(friend.getUserProfile().getSocialUserId());
            }else{
                if(avableCountFriends > 0){
                    friend.setSelected(true);
                    avableCountFriends --;
                    var footballer:Footballer = new Footballer(friendName, 1, null, friend.getUserProfile().getSocialUserId(),
                            true, true, friend.getUserProfile().getSocialData().getPhotoBig(), friend.getUserProfile().getMoney());
                    Application.teamProfiler.addFootballer(footballer);
                }
            }

            friensCount.text = getFrintCount(avableCountFriends);
            
        }else{

            var wrapper:Object = Singletons.context.getWrapper();
            if (wrapper != null) {
                wrapper.external.showInviteBox();
            }

        } 
    }


}
}