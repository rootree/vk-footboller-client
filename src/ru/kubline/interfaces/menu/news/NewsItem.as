package ru.kubline.interfaces.menu.news {
import ru.kubline.interfaces.menu.sponsors.*;

import flash.display.MovieClip;

import flash.text.TextField;

import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.News;
import ru.kubline.model.UserProfileHelper;

public class NewsItem extends UIMenuItem{

    private const LIMIT_LENGTH_TITLE:uint = 90;

    private var titleNewsText:TextField;

    /**
     *
     * @param container
     */
    public function NewsItem(container:MovieClip) {
        super(container);
        titleNewsText = TextField(container.getChildByName("titleNewsText"));
    }

    override public function setItem(value:Object):void {
        super.setItem(value);
        var item:News = News(value); 
        titleNewsText.text = UserProfileHelper.trim(item.title, LIMIT_LENGTH_TITLE);
        setSelectable((item != null));
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }
}
}