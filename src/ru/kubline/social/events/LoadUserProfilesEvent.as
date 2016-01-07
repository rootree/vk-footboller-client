package ru.kubline.social.events {
import flash.events.Event;

/**
 * Класс события загрузки
 * списка профайлов пользователя
 *
 * User: denis
 * Date: 05.11.2009
 * Time: 23:12:39
 */
public class LoadUserProfilesEvent extends Event{

    /**
     *  информация об ошибке если произошла ошибка
     */
    private var errorMsg:String;

    /**
     * мапа обектов SocialUserData с ключом id
     */
    private var usersProfiles:Object;

    /**
     * Успешная загрузка профайлов пользователя
     */
    public static const SUCCESSFULL:String = "successfull";

    /**
     * при ошибки загрузки списка друзей будет сгенерировано данное событие
     */
    public static const ERROR:String = "ERROR";

    public function LoadUserProfilesEvent(usersProfiles:Object, errorMsg:String, type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.usersProfiles = usersProfiles;
        this.errorMsg = errorMsg;
    }

    /**
     * @return информация об ошибке если произошла ошибка
     */
    public function getErrorMessage():String {
        return errorMsg;
    }

    /**
     * @return мапа обектов SocialUserData с ключом id которые добавили себе данное приложение
     */
    public function getUsersProfiles():Object {
        return usersProfiles;
    }

    public override function clone(): Event {
        return new LoadUserProfilesEvent(usersProfiles, errorMsg, type, bubbles, cancelable);
    }

    public override function toString():String {
        if (errorMsg != null) {
            return errorMsg;
        } else if (usersProfiles != null) {
            return usersProfiles.toString();
        } else {
            return "null";
        }
    }
}
}