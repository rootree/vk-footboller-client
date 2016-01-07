package ru.kubline.interfaces.menu.friends {
import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.errors.IllegalOperationError;

import flash.events.MouseEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;

/**
 * Класс отображает список друзей пользователя
 * @autor denis
 */
public class FriendsListItem extends UIPagingMenu {

    /**
     * список профайлов юзеров из списка друзей
     */
    private var profiles:Array = new Array();

    public function FriendsListItem(container:MovieClip) {
        super(container);
        this.store = new FriendProfilesStore(FriendProfilesStore.getFriendsByType(FriendProfilesStore.TYPE_ALL), cellsContainer.numChildren);
        initAddButtons();
        setPage(1);
    }

    override public function setData(data:Array):void {
        throw new IllegalOperationError();
    }

    private function initAddButtons():void {
        // считаем что все кнопки не относящиеся к перелистыванию,
        // это кнопки пригласи друга
        for (var i:int; i < getContainer().numChildren; i++) {
            var ch:DisplayObject = getContainer().getChildAt(i);
            if (ch is SimpleButton && ch.name != "next" && ch.name != "prev") {
                ch.addEventListener(MouseEvent.CLICK, onAddFriendsClick);
            }
        }
    }

    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        return new FriendAvatar(MovieClip(cell));
    }

    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }

    /**
     * обработчик клика по кнопке пригласить друзей
     */
    private function onAddFriendsClick(e:MouseEvent): void {
        var wrapper:Object = Singletons.context.getWrapper();
        if (wrapper != null) {
            wrapper.external.showInviteBox();
        }
    }
}
}