package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться при сохранении фото на сервере
 */
public class PhotoSaveEvent extends Event {

    public static const PHOTO_SAVE:String = "PHOTO_SAVE";

    public var success:Boolean;

    public function PhotoSaveEvent(success:Boolean) {
        super(PHOTO_SAVE);
        this.success = success;
    }
}

}