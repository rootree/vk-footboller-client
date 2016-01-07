package ru.kubline.interfaces.menu.shop.footballes {
import flash.events.Event;

import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.social.model.SocialAlbum;

/**
 * Событие рассылается при создании альбома
 * @author denis
 */
public class FootballerSelectedEvent extends Event {

    public static const SELECTED:String = "SELECTED";

    /**
     * URL сервера для сохранения фото
     */
    public var footballer:ItemResource;

    public var footballerItem:UIMenuItem;

    public function FootballerSelectedEvent(footballer:ItemResource, footballerItem:UIMenuItem) {
        super(SELECTED); 
        this.footballer = footballer;
        this.footballerItem = footballerItem;
    }
}
}