package ru.kubline.social.events {
import flash.events.Event;

/**
 * событие рассылаеться при успешной загрузки URL сервера для сохранения фото
 * @author denis
 */
public class GetUploadServerEvent extends Event {

    public static const UPLOAD_SERVER:String = "UPLOAD_SERVER";

    /**
     * URL сервера для сохранения фото
     */
    public var uploadServer:String;

    public var success:Boolean;

    public function GetUploadServerEvent(success:Boolean, uploadServer:String = "") {
        super(UPLOAD_SERVER);
        this.uploadServer = uploadServer;
        this.success = success;
    }
}
}