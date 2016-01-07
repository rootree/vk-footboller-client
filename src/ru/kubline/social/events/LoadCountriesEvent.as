package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться после того как альбомы были зангружены
 *
 * @author denis
 */
public class LoadCountriesEvent extends Event {

    public static const LOAD_COUNTRIES:String = "LOAD_COUNTRIES";

    /**
     * массив объектов SocialAlbum
     */
    public var socialCountries:Array;

    public var success:Boolean;

    public function LoadCountriesEvent(success:Boolean, socialCountries:Array = null) {
        super(LOAD_COUNTRIES);
        this.socialCountries = socialCountries;
        this.success = success;
    }
}
}