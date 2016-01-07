package ru.kubline.interfaces.menu.sponsors {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.text.TextField;

import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 2:13:29 PM
 */

public class SingleSponsor extends UIComponent {

    public static const DELETE:String = "deleteSponsor";

    private var unchooseBtn:UISimpleButton;

    private var sponsorImg:MovieClip;

    private var energyBonus:TextField;

    private var menuItem:UIMenuItem;

    private var id:uint;

    public function SingleSponsor(container:MovieClip) {
        super(container);

    }

    override protected function initComponent():void{
        super.initComponent();
        this.container.visible = false;
        unchooseBtn = new UISimpleButton(SimpleButton(container.getChildByName("unchooseBtn")));
        unchooseBtn.addHandler(onDelete);
        sponsorImg = container.getChildByName("sponsorImg") as MovieClip;
        energyBonus = TextField(container.getChildByName("energyBonus")); 
    }

    override public function destroy():void{
        super.destroy();
        unchooseBtn.removeHandler(onDelete); 
    }

    private function onDelete(e:Event):void{
        this.container.visible = false;
        dispatchEvent(new Event(SingleSponsor.DELETE));    
    }

    public function initData(item:ItemResource):void{
        energyBonus.text = SingleSponsor.formatEnergy(item.getParams().energy);
        InterfaceUtils.eraceChildren(sponsorImg) ;
        this.container.visible = true;
        id = item.getId();
        new Gallery(sponsorImg, Gallery.TYPE_SPONSOR, item.getId().toString());
    }
  
    public function getId():uint{
        return id;
    }

    public static function formatEnergy(energy:Number):String{
        return "+" + (Math.round(energy * 100) - 100) + "%";
    }

    public function getMenuItem():UIMenuItem {
        return menuItem;
    }

    public function setMenuItem(value:UIMenuItem):void {
        menuItem = value;
    }
}
}