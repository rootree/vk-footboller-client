package ru.kubline.interfaces.window {
import flash.display.MovieClip;

import flash.events.Event;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.menu.SelectLineMenu;
import ru.kubline.interfaces.menu.SettingsFootballerMenu;
import ru.kubline.loader.ClassLoader;
import ru.kubline.model.Footballer;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:27:55 PM
 */

public class FootballerWindow extends UIWindow {


    private var settings:SettingsFootballerMenu;
    private var chooseLine:SelectLineMenu;

    private var player:Footballer;

    private var footballerName:TextField;
 
    public function FootballerWindow() {
        super(ClassLoader.getNewInstance(Classes.FOOTBOLLER_SETTINGS));

        settings = new SettingsFootballerMenu(MovieClip(container.getChildByName("settings")));
        chooseLine = new SelectLineMenu(MovieClip(container.getChildByName("chooseLine")));

    }

    override protected function initComponent():void{
        super.initComponent();

        chooseLine.addEventListener(SelectLineMenu.LINE_SELECTED, onLineSelected);

        settings.addEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        settings.addEventListener(SettingsFootballerMenu.CHANGES_MAKE, onChangesComplete);

        footballerName = TextField(container.getChildByName("footballerName"));

    }

    override public function destroy():void{
        chooseLine.removeEventListener(SelectLineMenu.LINE_SELECTED, onLineSelected);

        settings.removeEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        settings.removeEventListener(SettingsFootballerMenu.CHANGES_MAKE, onChangesComplete);
        super.destroy();
    }

    private function onChangesComplete(event:Event):void {
        super.hide();
    }

    private function onChange(event:Event):void {
        dispatchEvent(new Event(UIEvent.ELEMENT_CHANGED));
    }
    
    private function onLineSelected(event:Event):void {
        player.setType(chooseLine.getSelectedLine().toString());
        settings.initData(player);
        settings.setVisible(true);
        chooseLine.setVisible(false);
    }

    public function initPlayer(player:Footballer):void {
        
        this.player = player;
        footballerName.text = player.getFootballerName();

        if(player.getType() == '0'){
            chooseLine.setVisible(true) ;
        } else {
            chooseLine.setVisible(false);
             settings.initData(player);
        }

        settings.setVisible(!chooseLine.isVisible());
    }
    
}
}