package ru.kubline.social.model {

/**
 * Описание альбома в социальной сети
 * @author denis
 */
public class SocialCountry {

    /**
     * id альбома
     */
    private var cid:uint;

    private var title:String;


    public function SocialCountry() {
    }

    public function getCid():uint {
        return cid;
    }

    public function setCid(value:uint):void {
        cid = value;
    }

    public function getTitle():String {
        return title;
    }

    public function setTitle(value:String):void {
        title = value;
    }

}

}