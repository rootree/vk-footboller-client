package ru.kubline.interfaces.menu.shop.cups {
import flash.events.Event;

import ru.kubline.loader.resources.ItemResource;
import ru.kubline.social.model.SocialAlbum;

/**
 * Событие рассылается при создании альбома
 * @author denis
 */
public class CupSelectedEvent extends Event {

    public static const SELECTED:String = "SELECTED";

    /**
     * URL сервера для сохранения фото
     */
    public var cup:ItemResource;

    public function CupSelectedEvent(cupId:ItemResource) {
        super(SELECTED); 
        this.cup = cupId;
    }
}
}