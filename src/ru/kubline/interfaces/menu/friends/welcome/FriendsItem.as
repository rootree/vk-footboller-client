package ru.kubline.interfaces.menu.friends.welcome {
import flash.display.MovieClip;

import flash.events.Event;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.game.UserAvatar;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;

public class FriendsItem extends UserAvatar implements IUIMenuItem{


    /**
     * Контейнер иконки элемента
     */
    private var iconPanel:MovieClip;

    /**
     * Иконка элемента
     */
    private var elementIcon:MovieClip;

    private var selectable:Boolean;

    private var selection:MovieClip;

    private var friendName:TextField;

    /**
     *
     * @param container
     */
    public function FriendsItem(container:MovieClip) {

        super(container);

        selectable = false;

        friendName = TextField(container.getChildByName("teamName"));
        selection = MovieClip(container.getChildByName("selection"));

        container.addEventListener(MouseEvent.CLICK, this.onMouseClick);
        if (selectable) {
            setSelected(selectable);
        }

    }

    /**
     * Настраиваем элемент магазина
     * @param value
     */
    public function setItem(value:Object):void {

        if (value) {
            var userProfile:TeamProfiler = TeamProfiler(value);
            super.setProfile(userProfile);
            friendName.text = UserProfileHelper.getNameTextByProfile(userProfile);
            super.getContainer().visible = true;

            if(Application.teamProfiler.getFootballerById(this.userProfile.getSocialUserId())){
                setSelected(true);
            }else{
                setSelected(false);
            }

        } else {

            new Gallery(avatar, Gallery.TYPE_OTHER, Gallery.ADD_PLAYER); 

            //super.setProfile(null);
            friendName.text = 'В игру';
            setSelected(false);

        }
    }

    public function getItem():Object {
        return getUserProfile();
    }

    public function setSelected(selected:Boolean):void {
        this.selectable = selected;
        highlight(selected);
    }

    public function isSelected():Boolean {
        return selectable;
    }

    public function setSelectable(value:Boolean):void {
        selectable = value;
    }

    public function isSelectable():Boolean {
        return selectable;
    }

    /**
     * подсвечивает ячейку(при наведении/выборе)
     */
    private function highlight(highlight:Boolean):void {
        if (selection) {
            selection.visible = highlight;
        }
    }

   private function onMouseClick(event:MouseEvent):void {
        this.dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));
        if (!disabled && selectable) {
            if (!selectable) {
                this.dispatchEvent(new Event(UIEvent.MENU_ITEM_SELECT));
            }
            setSelected(true);
        }
    }

}
}