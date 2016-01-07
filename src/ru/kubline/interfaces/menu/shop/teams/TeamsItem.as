package ru.kubline.interfaces.menu.shop.teams {

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.errors.IllegalOperationError;
import flash.events.MouseEvent;
import flash.text.TextField;



import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.display.SimpleFootballer;
import ru.kubline.display.SimpleTeam;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.game.UIPriceContainer;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;

/**
 * Элемент основного магазина
 */
public class TeamsItem extends UIMenuItem {

    /**
     * Контейнер иконки элемента
     */
    private var iconPanel:MovieClip; 
    private var teamName:TextField;

    /**
     *
     * @param container
     */
    public function TeamsItem(container:MovieClip) {
        super(container); 

    }

    override protected function initComponent():void{
        super.initComponent();

        iconPanel = MovieClip(getChildByName("teamImg"));
        teamName = TextField(getChildByName("teamName"));
        container.addEventListener(MouseEvent.CLICK, this.onMouseClick);

    }


    /**
     * Настраиваем элемент магазина
     * @param value
     */
    override public function setItem(value:Object):void {

        super.setItem(value);
        var itemR:ItemResource = ItemResource(value);
        teamName.text = itemR.getName();

        new Gallery(iconPanel, Gallery.TYPE_TEAM, itemR.getId().toString());
        super.getContainer().visible = true;
 
        setSelectable(item != null);
        setDisabled(item == null); 
    }

    override public function destroy():void {
        container.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        setItem(null);
        super.destroy();
    }




}
}