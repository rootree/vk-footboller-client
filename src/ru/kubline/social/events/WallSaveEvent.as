package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться при сохранении фото на сервере
 */
public class WallSaveEvent extends Event {

    public static const PHOTO_SAVE_WALL:String = "PHOTO_SAVE_ON_WALL";

    public var success:Boolean;
    public var server:Object;
    public var hash:Object;
    public var photo:Object;

    public function WallSaveEvent(server:Object, photo:Object, hash:Object) {
        super(WallSaveEvent.PHOTO_SAVE_WALL);
        this.server = server;
        this.photo = photo;
        this.hash = hash;
    }
}

}