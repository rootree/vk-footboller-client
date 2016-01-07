package ru.kubline.social.model {

/**
 * Описание альбома в социальной сети
 * @author denis
 */
public class SocialAlbum {

    /**
     * id альбома
     */
    private var aid:String;

    private var ownerId:String;

    private var title:String;

    private var description:String;

    public function SocialAlbum() {
    }

    public function getAid():String {
        return aid;
    }

    public function setAid(value:String):void {
        aid = value;
    }

    public function getOwnerId():String {
        return ownerId;
    }

    public function setOwnerId(value:String):void {
        ownerId = value;
    }

    public function getTitle():String {
        return title;
    }

    public function setTitle(value:String):void {
        title = value;
    }

    public function getDescription():String {
        return description;
    }

    public function setDescription(value:String):void {
        description = value;
    }
}

}