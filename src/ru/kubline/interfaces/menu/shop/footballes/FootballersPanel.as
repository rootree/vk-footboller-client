package ru.kubline.interfaces.menu.shop.footballes {
import ru.kubline.interfaces.menu.shop.*;
import ru.kubline.interfaces.menu.*;

import com.greensock.TweenMax;

import com.greensock.easing.Expo;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.events.Event;

import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;


import ru.kubline.comon.Colors;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.interfaces.game.UIPriceContainer;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.MoneyType;
import ru.kubline.model.Price;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.Trainer;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ItemUtils;

/**
 * Работа с главным магазином
 */
public class FootballersPanel extends UIPagingMenu  {

    public static const TAB_CHANGED:String = 'tab_changed';

    private var chooseGoalKeeper:UIComponent;
    private var chooseSafe:UIComponent;
    private var chooseHalfSafe:UIComponent;
    private var chooseForward:UIComponent;
    private var chooseTeamLead:UIComponent;

    private var teamId:uint;
    
    public function FootballersPanel(container:MovieClip) { 
        super(container);
    }

    override protected function initComponent():void{
        super.initComponent();

        getSelected();

        chooseGoalKeeper = new UIComponent(MovieClip(container.getChildByName("tabGolcip")));
        chooseSafe = new UIComponent(MovieClip(container.getChildByName("tabSafe")));
        chooseHalfSafe = new UIComponent(MovieClip(container.getChildByName("tabHalfSafe")));
        chooseForward = new UIComponent(MovieClip(container.getChildByName("tabForward")));
        chooseTeamLead = new UIComponent(MovieClip(container.getChildByName("tabTeamLead")));

        chooseGoalKeeper.getContainer().addEventListener(MouseEvent.CLICK, onGoalKeeperChoosed);
        chooseSafe.getContainer().addEventListener(MouseEvent.CLICK, onSafeChoosed);
        chooseHalfSafe.getContainer().addEventListener(MouseEvent.CLICK, onHalfSafeChoosed);
        chooseForward.getContainer().addEventListener(MouseEvent.CLICK, onForwardChoosed);
        chooseTeamLead.getContainer().addEventListener(MouseEvent.CLICK, onTeamLeadChoosed);

        setActive(ItemTypeStore.TYPE_FORWARD);

    }

    override public function destroy():void{
        super.destroy();
        chooseGoalKeeper.getContainer().removeEventListener(MouseEvent.CLICK, onGoalKeeperChoosed);
        chooseSafe.getContainer().removeEventListener(MouseEvent.CLICK, onSafeChoosed);
        chooseHalfSafe.getContainer().removeEventListener(MouseEvent.CLICK, onHalfSafeChoosed);
        chooseForward.getContainer().removeEventListener(MouseEvent.CLICK, onForwardChoosed);
        chooseTeamLead.getContainer().removeEventListener(MouseEvent.CLICK, onTeamLeadChoosed);  
    }

    private function onHigtLightTab(event:MouseEvent):void {
        higthLight(DisplayObjectContainer(event.currentTarget));

    }

    private function onUnHigtLightTab(event:MouseEvent):void {
        tweenerOff(DisplayObjectContainer(event.currentTarget));
    }

    public function setActive(type:String):void{
 
        tweenerOffSelectedTab(chooseGoalKeeper);
        tweenerOffSelectedTab(chooseSafe);
        tweenerOffSelectedTab(chooseHalfSafe);
        tweenerOffSelectedTab(chooseForward);
        tweenerOffSelectedTab(chooseTeamLead);

        switch(type){
            case ItemTypeStore.TYPE_GOALKEEPER:
                higthLightSelectedTab(chooseGoalKeeper);
                break;

            case ItemTypeStore.TYPE_FORWARD:
                higthLightSelectedTab(chooseForward);
                break;

            case ItemTypeStore.TYPE_SAFER:
                higthLightSelectedTab(chooseSafe);
                break;

            case ItemTypeStore.TYPE_HALFSAFER:
                higthLightSelectedTab(chooseHalfSafe);
                break;

            case ItemTypeStore.TYPE_TEAMLEAD:
                higthLightSelectedTab(chooseTeamLead);
                break;
        }
    }

    private function higthLight(tab:DisplayObjectContainer):void {
        var realTab:MovieClip = MovieClip((tab).getChildByName('elementBG'));
        TweenMax.to(realTab, 0.25, {glowFilter:{color:0xffffff, alpha:1, blurX:2, blurY:2, strength:5, quality:3}, ease:Expo.easeInOut});
    }

    private function higthLightSelectedTab(tab:UIComponent):void {
        var realTab:MovieClip = MovieClip(MovieClip(tab.getContainer()).getChildByName('elementBG'));
        tab.setDisabled(false);
        TweenMax.to(realTab, 0.75, {
            alpha:1,
            colorTransform:{tint:0xC2C7D1},
            onStartListener  : function():void{
                tab.setDisabled(false);
            }
        }) ;
    }

    private function tweenerOffSelectedTab(tab:UIComponent):void {
        var realTab:MovieClip = MovieClip(MovieClip(tab.getContainer()).getChildByName('elementBG'));
        TweenMax.to(realTab, 0.25, {
            alpha:1,
            colorTransform:{tint:0x5673A3},
            onComplete  : function():void{
                tab.setDisabled(true);
                tweenerOff(MovieClip(tab.getContainer()));
            }
        });
    }

    private function tweenerOff(tab:DisplayObjectContainer):void {
        var realTab:MovieClip = MovieClip((tab).getChildByName('elementBG'));
        realTab.filters = [];
        TweenMax.killTweensOf(realTab);
    }

    public function setTeamId(teamId:uint):void {
        this.teamId = teamId;
    }

    public function redraw(type:String):void {
        
        var data:Array;
        data = ItemTypeStore.getFootballerByType(type, teamId);

        var shopItems:Array = new Array();
        for (var i:uint = 0; i < data.length; i++) {
            switch(type){
                case ItemTypeStore.TYPE_TEAMLEAD:
                    if(Application.teamProfiler.getTrainer().getId() != ItemResource(data[i]).getId() ){
                        shopItems.push(data[i]);;
                    }
                    break;

                default:
                    if(!Application.teamProfiler.getFootballerById( ItemResource(data[i]).getId()) ){
                        shopItems.push(data[i]);
                    }
                    break;
            }
        }
 
        setData(shopItems);
        setPage(1);
        if(shopItems.length){
            getSelectedMenuItem().dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));
        }
        setActive(type);
        dispatchEvent(new Event(FootballersPanel.TAB_CHANGED));

    }

    private function onGoalKeeperChoosed(event:MouseEvent):void {
        redraw(ItemTypeStore.TYPE_GOALKEEPER);
    }

    private function onSafeChoosed(event:MouseEvent):void {
        redraw(ItemTypeStore.TYPE_SAFER);
    }

    private function onHalfSafeChoosed(event:MouseEvent):void {
        redraw(ItemTypeStore.TYPE_HALFSAFER);
    }

    private function onForwardChoosed(event:MouseEvent):void {
        redraw(ItemTypeStore.TYPE_FORWARD);
    }

    /**
     * Выбираем покупку расширений карты
     * @param event
     */
    private function onTeamLeadChoosed(event:MouseEvent):void {
        redraw(ItemTypeStore.TYPE_TEAMLEAD);
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var shopItem:FootballersItem = new FootballersItem(MovieClip(cell));
        shopItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return shopItem;
    }

    private function inBankClick(e:Event):void {
        UserPanel.bankController.showMenu();
    }

    /**
     * Действие при шелчке по элементу магазина
     * @param e
     */
    private function onItemClick(e:Event):void { 
        var item:UIMenuItem = UIMenuItem(e.target);
        if(item.getItem() is ItemResource){ 
            var itemRecord:ItemResource = ItemResource(item.getItem()); 
            var event:FootballerSelectedEvent = new FootballerSelectedEvent(itemRecord, item);
            dispatchEvent(event);
            Singletons.statistic.increaseShopItem(itemRecord.getId(), Statistics.SHOP_ACTION_CLICK);
        }
    }


    /**
     * Если хотим чтобы в магазине не отображались пустые клеточки
     * @param cell
     * @param item
     */
    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }


    override protected function onCloseClick(event:MouseEvent):void {
        super.onCloseClick(event);
    }
 
}
}