package ru.kubline.social.events {
import flash.events.Event;

import ru.kubline.social.model.SocialAlbum;

/**
 * Событие рассылается при создании альбома
 * @author denis
 */
public class CreateAlbumEvent extends Event {

    public static const CREATE_ALMBUM:String = "CREATE_ALMBUM";

    /**
     * URL сервера для сохранения фото
     */
    public var socialAlbum:SocialAlbum;

    public var success:Boolean;

    public function CreateAlbumEvent(success:Boolean, socialAlbum:SocialAlbum = null) {
        super(CREATE_ALMBUM);
        this.socialAlbum = socialAlbum;
        this.success = success;
    }
}
}