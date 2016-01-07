package ru.kubline.interfaces.menu.friends.mainmenu {

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.WallController;
import ru.kubline.gui.controls.PagingStore;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.FriendTeam;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.utils.MCUtils;

public class FriendsList extends UIPagingMenu{

    private static var avableCountFriends:uint = Footballer.MAX_TEAM;

    private var friensCount:TextField;

    private var finishBtn:UISimpleButton;

    private var closeTextBtn:UISimpleButton;

    private var selectedFriends:Object;

    private var ableToChoose:MovieClip;

    private var enableToChoose:MovieClip;

    private var ole:MovieClip;

    /**
     * список профайлов юзеров из списка друзей
     */
    private var profiles:Array = new Array();

    public function FriendsList(container:MovieClip) {
        super(MovieClip(container.getChildByName("friendPanel")));


        ole = MovieClip(container.getChildByName("ole"))
        var inviteContiner:MovieClip = MovieClip(container.getChildByName("invite"));


        if(Application.isFirstLanch()){

            ole.visible = true;
            MovieClip(container.getChildByName("friendPanel")).visible = false;
            inviteContiner.visible = false;

            changeGrand();

        }else{
 
            var friendForChoose:Array = FriendProfilesStore.getFriendsByType(FriendProfilesStore.TYPE_ALL);  // TODO Проверить каких друзья возращаються

            this.store = new PagingStore(friendForChoose, cellsContainer.numChildren);

            setPage(1);
            
            ole.visible = false;

            MovieClip(container.getChildByName("friendPanel")).visible = Boolean(friendForChoose.length);
 
            new UIComponent(inviteContiner).setQtip("Пригласить в команду своих друзей");

            var friendForInvite:Array = FriendProfilesStore.getInstalledFriends(false); 
            inviteContiner.visible = true;
            MovieClip(inviteContiner.getChildByName('medal')).visible = false;
            TextField(inviteContiner.getChildByName('place')).visible = false;

/*            if(!friendForInvite.length){
                friendForInvite = friendForChoose;
            }*/
 
            MovieClip(inviteContiner.getChildByName("selection")).visible = false; ;
            MovieClip(inviteContiner.getChildByName("disabled")).visible = false; ;
            
            if(friendForInvite.length){

                var inv:uint = Math.floor(Math.random() * friendForInvite.length);
                var userForInvite:TeamProfiler = friendForInvite[inv];
                new Gallery(MovieClip(MovieClip(container.getChildByName("invite")).getChildByName("avatar")),
                        Gallery.TYPE_OUTSOURCE, userForInvite.getSocialData().getPhotoBig());

            }else{

                var containerForAdd:MovieClip = MovieClip(MovieClip(container.getChildByName("invite")).getChildByName("avatar"));

                var addFootballerIcon:MovieClip = ClassLoader.getNewInstance(Classes.FOOTBOLLER_ADD);
                InterfaceUtils.scaleIcon(addFootballerIcon, containerForAdd.width, containerForAdd.height);
                MCUtils.enableMouser(MovieClip(addFootballerIcon));

                MovieClip(containerForAdd.getChildByName("loading")).visible = false;
                MovieClip(containerForAdd.getChildByName("loading")).stop();

                containerForAdd.addChild(addFootballerIcon);
            }

            MovieClip(container.getChildByName("invite")).addEventListener(MouseEvent.CLICK, onInvite);
            
        }

    }

    private function onInvite(e:Event): void {

        var wrapper:Object = Singletons.context.getWrapper();
        if (wrapper != null) {
            wrapper.external.showInviteBox();
        }  
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var friend:FriendsItemInMM = new FriendsItemInMM(MovieClip(cell));
        friend.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return friend;
    }

    override public function setData(data:Array):void {
        throw new IllegalOperationError();
    }

    public function changeGrand():void {
        if(Application.teamProfiler.getTeamName()){ 
            var sharphText:TextField = TextField(ole.getChildByName("grand"));
            sharphText.text = Messages.sprintf("{0}",
                    Application.teamProfiler.getTeamName().substring(0, 16));
        }
    }

    private function onItemClick(e:Event):void {

        var item:FriendsItemInMM = FriendsItemInMM(e.target);
        Singletons.friendTeamController.init(item.getUserProfile());

        // TODO придумать что будет на клик

    }


}
}