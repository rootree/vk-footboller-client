package ru.kubline.interfaces.menu.team {
import flash.display.DisplayObject;
import flash.display.MovieClip; 
import flash.events.Event;
import ru.kubline.events.InterfaceEvent;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.UserTeam;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:59:08 PM
 */

public class UserPlayersMenu extends UIPagingMenu  {

    private var itemStore:UserTeam;

    public function handlerUp(container:UserTeam):void {
        this.itemStore = container;
        this.itemStore.addEventListener(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS, disableOtherUp);
    }

    public function UserPlayersMenu(container:MovieClip) {
        super(container);
        getSelected(); 
    }
 
    public function redrawContainer(type:uint, profile:TeamProfiler = null):void {
        if(profile == null){
            profile = Application.teamProfiler;;
        }

        var data:Array = profile.getFootballers(type);
        sort(data);
        setData(data);
    }

    public function disableUp(e:Event):void {
        dispatchEvent(new Event(InterfaceEvent.LOCK_UP_BUTTON));
        dispatchEvent(new Event(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS));
    }

    public function disableOtherUp(e:Event):void {
        dispatchEvent(new Event(InterfaceEvent.LOCK_UP_BUTTON)); 
    }

    public function hideNavigation(isHide:Boolean):void {
        next.setVisible(!isHide);
        prev.setVisible(!isHide);
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var userTeamItem:UserPlayersItem = new UserPlayersItem(MovieClip(cell));
        userTeamItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        userTeamItem.addEventListener(UIEvent.MENU_ITEM_DOUBLE_CLICK, onItemDoubleClick);
        userTeamItem.addEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        userTeamItem.addEventListener(InterfaceEvent.STADY_POINT_EXHAUSTED, disableUp); 
        return userTeamItem;
    }
 
    override public function destroy():void {
  
        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
            item.removeEventListener(UIEvent.MENU_ITEM_DOUBLE_CLICK, onItemDoubleClick);
            item.removeEventListener(UIEvent.ELEMENT_CHANGED, onChange);
            item.removeEventListener(InterfaceEvent.STADY_POINT_EXHAUSTED, disableUp);
        }

        super.destroy();
    }
 
    private function onItemClick(event:Event):void { 
        var newSelection:IUIMenuItem = IUIMenuItem(event.target);
        setSelectedItem(newSelection);
        dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));
    }

    private function onItemDoubleClick(event:Event):void {
        var newSelection:IUIMenuItem = IUIMenuItem(event.target);
        setSelectedItem(newSelection);
        dispatchEvent(new Event(UIEvent.MENU_ITEM_DOUBLE_CLICK));
    }

    private function onChange(event:Event):void { 
        dispatchEvent(new Event(UIEvent.ELEMENT_CHANGED));
    }
 
    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
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
    public static function itemsComparator(a:Footballer, b:Footballer):int {
        if (parseInt(a.getType()) > parseInt(b.getType())) {
            return 1;
        } else if (parseInt(a.getType()) < parseInt(b.getType())) {
            return -1;
        } else {
            return 0;
        }
    }

}
}