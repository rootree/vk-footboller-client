package ru.kubline.interfaces.menu.shop.cups {

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.errors.IllegalOperationError;
import flash.events.MouseEvent;
import flash.text.TextField;



import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.display.SimpleCup;
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
 * Р­Р»РµРјРµРЅС‚ РѕСЃРЅРѕРІРЅРѕРіРѕ РјР°РіР°Р·РёРЅР°
 */
public class CupsItem extends UIMenuItem{

    private var cupTitle:TextField;
    private var lockLevel:TextField;

    private var country:MovieClip;
    private var lock:MovieClip;
    /**
     *
     * @param container
     */
    public function CupsItem(container:MovieClip) {
        super(container);

    }

    override protected function initComponent():void{
        super.initComponent();

        cupTitle = TextField(getChildByName("cupTitle"));
        country = MovieClip(getChildByName("country"));
        lock = MovieClip(getChildByName("lock"));
        lockLevel = TextField(lock.getChildByName("level"));

    }
 
 
    /**
     * РќР°СЃС‚СЂР°РёРІР°РµРј СЌР»РµРјРµРЅС‚ РјР°РіР°Р·РёРЅР°
     * @param value
     */
    override public function setItem(value:Object):void {

      //  initComponent();

        super.setItem(value);
        var itemR:ItemResource = ItemResource(value);

        country.gotoAndStop("country" + itemR.getParams().ccode);
        cupTitle.text = itemR.getName();

        if((Application.teamProfiler.getLevel() + 1) >= (itemR.getRequiredLevel() ) ||  (Application.teamProfiler.isDiscount())){
            lock.visible = false; 
            container.addEventListener(MouseEvent.CLICK, this.onMouseClick);
        }else{
            lock.visible = true;
            lockLevel.text = itemR.getRequiredLevel().toString();
            container.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        }

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