package ru.kubline.interfaces.stadium {
import ru.kubline.interfaces.menu.sponsors.*;

import flash.display.MovieClip;

import flash.text.TextField;

import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;

public class StadiumShopItem extends UIMenuItem{

    private var stadiumPhoto:MovieClip;
    private var stadiumTytle:TextField;

    private var lockLevel:TextField;
    private var lock:MovieClip;

    /**
     *
     * @param container
     */
    public function StadiumShopItem(container:MovieClip) {
        super(container);
        stadiumPhoto = MovieClip(container.getChildByName("stadiumPhoto"));
        stadiumTytle = TextField(container.getChildByName("stadiumTytle"));

        lock = MovieClip(getChildByName("lock"));
        lockLevel = TextField(lock.getChildByName("level"));
    }

    override public function setItem(value:Object):void {
        super.setItem(value);
        var item:ItemResource = ItemResource(value);
        if (item) {
            new Gallery(stadiumPhoto, Gallery.TYPE_STADIUM, item.getId().toString(), true);
            super.getContainer().visible = true; 
            stadiumTytle.text = item.getParams().tytle;

            if(Application.teamProfiler.getLevel() >= item.getRequiredLevel()){
                lock.visible = false;
            }else{
                lock.visible = true;
                lockLevel.text = item.getRequiredLevel().toString();
            }

        } else {
            setDisabled(false);
        } 
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }
}
}