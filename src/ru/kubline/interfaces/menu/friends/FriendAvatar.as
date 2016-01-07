package ru.kubline.interfaces.menu.friends {
import flash.display.MovieClip;

import flash.events.MouseEvent;

import flash.text.TextFormat;

import ru.kubline.interfaces.game.UserAvatar;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPopupMenu;
import ru.kubline.gui.controls.menu.UIPopupMenuItem;

/**
 * класс аватарки игрока
 * рассширяем базовый класс UserAvatar т.к возможно
 * в списке друзей нам в будующем потребуеться выводить еще что-то
 * @author denis
 */
public class FriendAvatar extends UserAvatar implements IUIMenuItem {
 
    public function FriendAvatar(container:MovieClip) {
        super(container);

    }


    private function showUserPage():void {
        UserProfileHelper.showUserPage(getUserProfile());
    }

    public function setItem(value:Object):void {
        setProfile(TeamProfiler(value));
    }

    public function getItem():Object {
        return getUserProfile();
    }

    public function setSelected(selected:Boolean):void {
    }

    public function isSelected():Boolean {
        return false;
    }

    public function setSelectable(value:Boolean):void {
    }

    public function isSelectable():Boolean {
        return false;
    }
}

}