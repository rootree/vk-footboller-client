package ru.kubline.interfaces.menu {
import com.adobe.serialization.json.JSONDecoder;
import com.greensock.TweenMax;

import com.greensock.easing.Back;
import com.greensock.easing.Bounce;
import com.greensock.easing.Elastic;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;


import ru.kubline.comon.Classes;
import ru.kubline.controllers.LoginController;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.WelcomeEvent;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.friends.mainmenu.FriendsList;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.MCUtils;

public class SelectLogoList extends UIPagingMenu{

    // create logger instance
    private var log:Logger = new Logger(TeamLogoList);

    private var inputTitle:TextField;
    private var teamLogo:MovieClip;
    private var userLogoContainer:MovieClip;
    private var inputBG:MovieClip;

    private var isLogoSelected:Boolean;
    private var logoId:uint;
    private var isinputTitleClicked:Boolean;

    private var safeBtn:UISimpleButton;

    public function SelectLogoList() {

        super(ClassLoader.getNewInstance(Classes.CUSTOMIZATION));

 
        isinputTitleClicked = false;
    }

    override protected function initComponent():void{
        super.initComponent();

        isLogoSelected = false;
        inputTitle = TextField(container.getChildByName("inputTitle"));

        userLogoContainer = container.getChildByName("userLogo") as MovieClip;
        teamLogo = userLogoContainer.getChildByName("teamLogo") as MovieClip;

        safeBtn =new UISimpleButton(SimpleButton(getContainer().getChildByName("safeBtn")));
        safeBtn.addHandler(onSaveClickBtn);
        safeBtn.setQtip("Сохранить изменения");

    }

    override public function destroy():void{
        safeBtn.removeHandler(onSaveClickBtn);
        super.destroy();
    }

    override public function show():void{
 
        var ar:Array = ItemTypeStore.getStoreByType(ItemTypeStore.TYPE_LOGO_TEAM);

        setData(ar);
        setPage(1);

        super.show();

        new Gallery(teamLogo, Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());
        logoId = Application.teamProfiler.getTeamLogoId();
        inputTitle.text = Application.teamProfiler.getTeamName();

    }

    public function getTeamName():String{
        return inputTitle.text;
    }

    public function getTeamLogoId():uint{
        return logoId;
    }

    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:TeamLogoItem = new TeamLogoItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick); 
        return logoItem;
    }

     
    private function onSaveClickBtn(e:Event):void { 
        if(logoId > 0 && (inputTitle.length != 0)){

            Singletons.connection.addEventListener(HTTPConnection.COMMAND_CUSTOM, onChangesSeved);
            Singletons.connection.send(HTTPConnection.COMMAND_CUSTOM, {teamTitle:inputTitle.text, teamLogoId:logoId});

        }else{
            new MessageBox("Ошибка", "Для сохранения информации о команде, необходимо указать её название и выбрать логотип", MessageBox.OK_BTN).show();
        } 
    }

    private function onChangesSeved(e:Event):void {
        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_CUSTOM, onChangesSeved);
        var result:Object = HTTPConnection.getResponse();
        new MessageBox("Сообщение", "Информация о вашей команде изменена", MessageBox.OK_BTN).show();

        Application.teamProfiler.setTeamLogoId(logoId);
        Application.teamProfiler.setTeamName(inputTitle.text);

        Application.mainMenu.userPanel.update();
         
        Application.mainMenu.friendsList.changeGrand();
        hide();
    }

    private function onItemClick(e:Event):void {

        userLogoContainer.visible = true;

        var item:UIMenuItem = UIMenuItem(e.target);
        var itemRecord:ItemResource = ItemResource(item.getItem());

        if(itemRecord != null){
            isLogoSelected = true;
            InterfaceUtils.eraceChildren(teamLogo) ;
            new Gallery(teamLogo, Gallery.TYPE_TEAM, itemRecord.getId().toString());
            logoId = itemRecord.getId();
        }
    }

 
    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }

}
}