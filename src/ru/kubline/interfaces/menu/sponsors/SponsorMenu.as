package ru.kubline.interfaces.menu.sponsors {
import com.adobe.serialization.json.JSON;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;

import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import flash.utils.ByteArray;

import mx.utils.ObjectUtil;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.display.SimpleSponsor;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.Sponsor;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ObjectUtils;

public class SponsorMenu extends UIPagingMenu{

    private var log:Logger = new Logger(SponsorMenu);

    public var sponsorCount:uint = 0;

    private var firstSponsor:SingleSponsor;
    private var secondSponsor:SingleSponsor;
    private var thirdSponsor:SingleSponsor;
 
    private var userSponsor:Array;
    private var userVisibleSponsor:Array;

    private var isLogoSelected:Boolean;
 
    public static var tempStorage:Object = new Object();

    private var closeBtn:UISimpleButton;
    private var saveBtn:UISimpleButton;

    public function SponsorMenu() {
 
        super(ClassLoader.getNewInstance(Classes.PANEL_SPONSORS));

    }

    override protected function initComponent():void{
        super.initComponent();
         
        isLogoSelected = false;

        saveBtn = new UISimpleButton(SimpleButton(getChildByName("saveBtn")));
        saveBtn.addHandler(onSaveClick);

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        userSponsor = new Array(null, null, null);
        userVisibleSponsor = new Array(
                new SingleSponsor(MovieClip(container.getChildByName("firstSponsor"))),
                new SingleSponsor(MovieClip(container.getChildByName("secondSponsor"))),
                new SingleSponsor(MovieClip(container.getChildByName("thirdSponsor")))
            );

    }

    override public function destroy():void{

        super.destroy();

        closeBtn.removeHandler(onCloseClick);
        saveBtn.removeHandler(onSaveClick); 
  
        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        }
        
        var sponsors:Object = Application.teamProfiler.getSponsors();
        for (var key:String in sponsors) {

            var itemSponsor:ItemResource = ItemTypeStore.getItemResourceById(sponsors[key].getId());
            userSponsor[sponsorCount] = itemSponsor;

            var sponsor:SingleSponsor = SingleSponsor(userVisibleSponsor[sponsorCount]);
            sponsor.addEventListener(SingleSponsor.DELETE, deleteFromStore);

        }

    }

    private function onSaveClick(e:Event):void{

        var forSend:Array = new Array();
        for (var key:String in tempStorage) {
            forSend.push(key);
        }
  
        var forSendSting:String = JSON.encode(forSend);
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_SAVE_SPONSORS, onSaved);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, onSaved);
        Singletons.connection.send(HTTPConnection.COMMAND_SAVE_SPONSORS, forSendSting);
        super.hide();
    }
 
    private function onSaved(e:Event):void{
 
        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_SAVE_SPONSORS, onSaved);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, onSaved);
        
        var result:Object = HTTPConnection.getResponse();
        if(result){ 
            Application.teamProfiler.setSponsors(tempStorage);
            Application.mainMenu.userPanel.update();
        }
    }



    private function deleteFromStore(event:Event):void{
        
        var sponsor:SingleSponsor = SingleSponsor(event.target); 
        for (var i:uint = 0; i < userSponsor.length; i++) {
            if(userVisibleSponsor[i] == sponsor){

                if(userSponsor[i] is UIMenuItem){
                    UIMenuItem(userSponsor[i]).setDisabled(false);
                }
                userSponsor[i] = null;
                sponsorCount --;
            }
        }
        
        sponsor.removeEventListener(SingleSponsor.DELETE, deleteFromStore);
        sponsor.getContainer().visible = false;
        delete(tempStorage[sponsor.getId()]);

    }

    private function detectId(id:uint):uint{
        for (var i:uint = 0; i < userSponsor.length; i++) {
            if((userSponsor[i] is ItemResource) && ItemResource(userSponsor[i]).getId() == id){
                return i;
            }
        }
        return null;
    }

    private function getFreeSponsorId():uint{
        for (var i:uint = 0; i < userSponsor.length; i++) {
            if(userSponsor[i] == null){
                return i;
            }
        }
        return null;
    }


    
    override public function show():void{

        super.show();

        var insSponsorTo:MovieClip;
        var sponsors:Object = Application.teamProfiler.getSponsors();

        for (var i:uint = 0; i < userVisibleSponsor.length; i++) {
            SingleSponsor(userVisibleSponsor[i]).getContainer().visible = false;
            userSponsor[i] = null;
        }

        tempStorage = new Array();
        sponsorCount = 0;
        for (var key:String in sponsors) {
 
            var item:ItemResource = ItemTypeStore.getItemResourceById(sponsors[key].getId());
            userSponsor[sponsorCount] = item;

            var sponsor:SingleSponsor = SingleSponsor(userVisibleSponsor[sponsorCount]);

            sponsor.initData(item);
            sponsor.addEventListener(SingleSponsor.DELETE, deleteFromStore);
            
            tempStorage[sponsor.getId()] = sponsor;
            sponsorCount++;
        }

    }


    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:SponsorItem = new SponsorItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return logoItem;
    }
 
    private function onItemClick(e:Event):void {

        var item:UIMenuItem = UIMenuItem(e.target);

        if(item.isDisabled()){
            return;
        }
 
        var itemRecord:ItemResource = ItemResource(item.getItem());

        if(itemRecord != null){
 
            if(tempStorage[itemRecord.getId()]){

                item.setDisabled(true);
                var freshId:uint = detectId(itemRecord.getId()); 
                userSponsor[freshId] = item;
                //SingleSponsor(tempStorage[itemRecord.getId()]).setMenuItem(item);
                return;
            }
 
            if(sponsorCount >= Sponsor.SPONSORS_LIMIT){
                var msgBox:MessageBox = new MessageBox("Ошибка", "Больше " + Sponsor.SPONSORS_LIMIT + " спонсоров нельзя набирать", MessageBox.OK_BTN);
                msgBox.show();
                return;
            }

            var freeId:uint = getFreeSponsorId(); 
            var sponsorSlot:SingleSponsor = userVisibleSponsor[freeId];
            sponsorSlot.initData(itemRecord);
            sponsorSlot.addEventListener(SingleSponsor.DELETE, deleteFromStore);

            tempStorage[sponsorSlot.getId()] = sponsorSlot;
            userSponsor[freeId] = item;

            sponsorCount ++;
            isLogoSelected = true;
            item.setDisabled(true); 
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