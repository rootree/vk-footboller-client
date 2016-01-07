package ru.kubline.interfaces.menu.sponsors {
import flash.display.MovieClip;

import flash.text.TextField;

import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;

public class SponsorItem extends UIMenuItem{

    private var iconPanel:MovieClip;
    private var energyBonus:TextField;

    /**
     *
     * @param container
     */
    public function SponsorItem(container:MovieClip) {
        super(container);
        iconPanel = MovieClip(container.getChildByName("icon"));
        energyBonus = TextField(container.getChildByName("energyBonus"));
    }

    override public function setItem(value:Object):void {
        super.setItem(value);
        var item:ItemResource = ItemResource(value);
        if (item) {
            new Gallery(iconPanel, Gallery.TYPE_SPONSOR, item.getId().toString());
            super.getContainer().visible = true;
            if(item.getRequiredLevel() > Application.teamProfiler.getLevel()){
                setDisabled(true);
                setQtip("Для поддержки этого спонсора вам необходим " + item.getRequiredLevel() + " уровень");
            }else if(Application.teamProfiler.getSponsorById(item.getId())){
                setDisabled(true);
                setQtip("Данный спонсор уже с вами");
                Application.teamProfiler.getSponsorById(item.getId()).setItemElement(this);
            }else{
                setQtip(item.getName());
                setDisabled(false);
            }
               
            energyBonus.text = SingleSponsor.formatEnergy(item.getParams().energy);
        } else {
            setDisabled(false);
        }
        setSelectable((item != null));
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }
}
}