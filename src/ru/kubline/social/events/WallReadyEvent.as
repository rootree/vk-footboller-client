package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться при сохранении фото на сервере
 */
public class WallReadyEvent extends Event {

    public static const WALL_READY:String = "WALL_READY";

    public var success:Boolean;

    public var hash:String;

    public function WallReadyEvent(success:Boolean, hash:String) {
        super(WALL_READY);
        this.success = success;
        this.hash = hash;
    }
}

}