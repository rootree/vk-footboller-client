package ru.kubline.interfaces.menu.shop.teams {
import flash.events.Event;

import ru.kubline.loader.resources.ItemResource;
import ru.kubline.social.model.SocialAlbum;

/**
 * Событие рассылается при создании альбома
 * @author denis
 */
public class TeamSelectedEvent extends Event {

    public static const SELECTED:String = "SELECTED";

    /**
     * URL сервера для сохранения фото
     */
    public var team:ItemResource;

    public function TeamSelectedEvent(teamId:ItemResource) {
        super(SELECTED); 
        this.team = teamId;
    }
}
}