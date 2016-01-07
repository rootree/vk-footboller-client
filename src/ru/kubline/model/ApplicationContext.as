package ru.kubline.model {
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;

/**
 * Контекст приложения
 * @author denis
 */
public class ApplicationContext {

    private static const AUTH_KEY_NAME:String = "auth_key";

    private static const USER_ID_NAME:String = "viewer_id";

    private static const GROUP_ID_NAME:String = "group_id";

    /**
     * Базовый URL для загрузки ресурсов
     */
    private var baseUrl:String = "./";

    /**
     * id анкеты игрока который привел данного в игру
     */
    private var referrerId:uint = 0;

    /**
     * параметры окружения которые передал нам сайт
     */
    private var flashVars:Object;

    /**
     * flash контейнер от контакта
     */
    private var wrapper:Object;

    private var tourTimer:uint;


    private var tourStartAt:Date;

    private var tourFinishedAt:Date;

    
    public function getTourTimer():uint {
        return tourTimer;
    }

    public function setTourTimer(value:uint):void {
        tourTimer = value;
    }

    private var loaderContext:LoaderContext;

    public function ApplicationContext() {
    }

    public function getBaseUrl():String {
        return baseUrl;
    }

    public function setBaseUrl(value:String):void {
        baseUrl = value;
    }

    public function getReferrerId():uint {
        return referrerId;
    }

    public function setReferrerId(value:uint):void {
        referrerId = value;
    }

    public function getAuthKey():String {
        return getFlashVars()[AUTH_KEY_NAME];
    }

    public function getGroupSource():String {
        return getFlashVars()[GROUP_ID_NAME];
    }

    public function getUserId():String {
        return getFlashVars()[USER_ID_NAME];
    }

    public function getFlashVars():Object {
        if (wrapper != null) {
            return wrapper.application.parameters;
        } else {
            return flashVars;
        }
    }

    public function setFlashVars(value:Object):void {
        flashVars = value;
    }

    public function getWrapper():Object {
        return wrapper;
    }

    public function setWrapper(value:Object):void {
        wrapper = value;
    }

    /**
     * возвращает контекст загрузки ресурсов
     */
    public function getLoaderContext():LoaderContext {
        if (!loaderContext) {
            if (baseUrl.toLowerCase().indexOf("http") >= 0) {
                loaderContext = new LoaderContext(true,
                        new ApplicationDomain(ApplicationDomain.currentDomain),
                        SecurityDomain.currentDomain);
            } else {
                loaderContext = new LoaderContext(true,
                        new ApplicationDomain(ApplicationDomain.currentDomain));
            }
        }
        return loaderContext;
    }



    public function getTourStartAt():Date {
        return tourStartAt;
    }

    public function setTourStartAt(value:uint):void {
        tourStartAt = new Date(value * 1000);;
    }

    public function getTourFinishedAt():Date {
        return tourFinishedAt;
    }

    public function setTourFinishedAt(value:uint):void {
        tourFinishedAt = new Date(value * 1000); 
    }
}
}