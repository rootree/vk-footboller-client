package ru.kubline.social.events {
import flash.events.Event;

/**
 * Событие рассылаеться после того как альбомы были зангружены
 *
 * @author denis
 */
public class LoadAlbumsEvent extends Event {

    public static const LOAD_ALBUMS:String = "LOAD_ALBUMS";

    /**
     * массив объектов SocialAlbum
     */
    public var socialAlbums:Array;

    public var success:Boolean;

    public function LoadAlbumsEvent(success:Boolean, socialAlbums:Array = null) {
        super(LOAD_ALBUMS);
        this.socialAlbums = socialAlbums;
        this.success = success;
    }
}
}