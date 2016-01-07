package ru.kubline.interfaces.menu.friends.mainmenu {
import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.events.Event;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.game.UserAvatar;
import ru.kubline.interfaces.hint.TeamHint;
import ru.kubline.interfaces.menu.team.UserPlayersMenu;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.utils.MCUtils;

public class FriendsItemInMM extends UserAvatar implements IUIMenuItem, IHintProvider{


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
    private var medal:MovieClip;

    private var friendName:TextField;
    private var place:TextField;

    private var hintable:Hintable;

    /**
     * инстанс хинта
     */
    private var hint:TeamHint = null;

    /**
     *
     * @param container
     */
    public function FriendsItemInMM(container:MovieClip) {

        super(container);
        MCUtils.enableMouser(container);

        selectable = false;

        friendName = TextField(container.getChildByName("teamName"));
        place = TextField(container.getChildByName("place"));
        selection = MovieClip(container.getChildByName("selection"));
        medal = MovieClip(container.getChildByName("medal"));

        container.addEventListener(MouseEvent.CLICK, this.onMouseClick); 

        hintable = new Hintable(container);
        hintable.setHintProvider(this);

    }


    /**
     * отображает hint при наведениии мышки на аватарку
     * <b>данный метод должен всегда возвращать
     * один и тот же инстанс хинта</b>
     */
    public function getHint(): DisplayObject {
        if (hint == null) {
            hint = new TeamHint(); 
            if (userProfile) {
                hint.updateHint(userProfile);
            }
        }
        return hint.getContainer();
    }


    /**
     * Настраиваем элемент магазина
     * @param value
     */
    public function setItem(value:Object):void {

        if(hint){
            hint = null;
        }

        if (value) {
            var userProfile:TeamProfiler = TeamProfiler(value);

            if(userProfile.getSocialUserId() != Application.teamProfiler.getSocialUserId()){
                super.setProfile(userProfile);
                friendName.text = this.userProfile.getTeamName();
                place.text = !(this.userProfile.getPlaceForFriend() > 3) ? this.userProfile.getPlaceForFriend().toString() : "";
                medal.visible = !(this.userProfile.getPlaceForFriend() > 3);

                medal.gotoAndStop("place" + this.userProfile.getPlaceForFriend())  ;
                super.getContainer().visible = true;

            }else{
                super.getContainer().visible = false;
            }

        } else {
            super.getContainer().visible = false;
        }
         setSelected(false);
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
           
        }
    }
 

}
}