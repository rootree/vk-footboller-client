package ru.kubline.interfaces.menu {
import com.adobe.serialization.json.JSONDecoder;
import com.greensock.TweenMax;

import com.greensock.easing.Back;
import com.greensock.easing.Bounce;
import com.greensock.easing.Elastic;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;

import ru.kubline.controllers.LoginController;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.WelcomeEvent;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.window.Message;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.UserProfileHelper;

public class TeamLogoList extends UIPagingMenu{

    // create logger instance
    private var log:Logger = new Logger(TeamLogoList);

    private var inputTitle:TextField;
    private var teamLogo:MovieClip;
    private var userLogoContainer:MovieClip;
    private var inputBG:MovieClip;

    private var isLogoSelected:Boolean;
    private var logoId:uint;
    private var isinputTitleClicked:Boolean;

    public function TeamLogoList(container:MovieClip) {

        super(container);

        isLogoSelected = false; 
        isinputTitleClicked = false;
    }

    override protected function initComponent():void{
        super.initComponent();

        inputTitle = TextField(container.getChildByName("inputTitle"));

        userLogoContainer = container.getChildByName("userLogo") as MovieClip;
        userLogoContainer.visible = false;

        teamLogo = userLogoContainer.getChildByName("teamLogo") as MovieClip;
        inputBG = container.getChildByName("inputBG") as MovieClip;

        inputTitle.text = "Им. " + Application.teamProfiler.getSocialData().getLastName();
        inputTitle.addEventListener(KeyboardEvent.KEY_UP, onInputigTytle);

        inputTitle.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
        inputTitle.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);

    }

    override public function destroy():void{
        super.destroy();
        inputTitle.removeEventListener(KeyboardEvent.KEY_UP, onInputigTytle); 
        inputTitle.removeEventListener(MouseEvent.MOUSE_OVER, onItemOver);
        inputTitle.removeEventListener(MouseEvent.MOUSE_OUT, onItemOut);
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

    private function isAbleToProceed():void{
        if(isLogoSelected && (inputTitle.length != 0)){
            
            Application.teamProfiler.setTeamName(inputTitle.text);
            Application.teamProfiler.setTeamLogoId(logoId);
            
            dispatchEvent(new Event(WelcomeEvent.ABLE_TO_PROCEED));
        }else{
            dispatchEvent(new Event(WelcomeEvent.UNABLE_TO_PROCEED));
        }
    }

    private function onInputigTytle(e:KeyboardEvent):void {
        isAbleToProceed();
    }
    
    private function onItemOut(e:Event):void {

        if(!( inputTitle.length != 0 )){

            TweenMax.killTweensOf(inputBG);
            if(inputBG){
                inputBG.filters = [];
            }
            TweenMax.to(inputBG, 1, {colorTransform:{tint:0x5E6F9B, tintAmount:1, exposure:2, brightness:1.4, redMultiplier:1 }, ease:Back.easeOut});

        }else{
            TweenMax.to(inputBG, 1, {colorTransform:{tint:0xD8DFE7, tintAmount:1, exposure:2, brightness:1.4, redMultiplier:1 }, ease:Back.easeOut});
        }
    }

    private function onItemOver(e:Event):void {
        TweenMax.killTweensOf(inputBG);
        if(inputBG){
            inputBG.filters = [];
        }
        TweenMax.to(inputBG, 1, {colorTransform:{tint:0xE4E6EB, tintAmount:1, exposure:2, brightness:1.4, redMultiplier:1 }, ease:Back.easeOut});
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

            isAbleToProceed();
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