package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться после того как альбомы были зангружены
 *
 * @author denis
 */
public class LoadCitiesEvent extends Event {

    public static const LOAD_CITIES:String = "LOAD_CITIES";

    /**
     * массив объектов SocialAlbum
     */
    public var socialCities:Array;

    public var success:Boolean;

    public function LoadCitiesEvent(success:Boolean, socialCities:Array = null) {
        super(LOAD_CITIES);
        this.socialCities = socialCities;
        this.success = success;
    }
}
}