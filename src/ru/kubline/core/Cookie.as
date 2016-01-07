package ru.kubline.core {
import flash.net.SharedObject;

import ru.kubline.logger.luminicbox.Logger;

/**
 * настройки пользовател€ хран€щиес€ в кукисах
 * Author: Oksana Shevchenko
 *   Date: 25.07.2010
 *   Time: 12:44:13
 */
public class Cookie {

    private static const COOKIE_NAME:String = "Footballer"; 

    private static const INSTANCE:Cookie = new Cookie();
 
    private var log:Logger = new Logger(Cookie);

    private var config:SharedObject;

    public static function getNumberValue(property:String, _default:Number = 0):Number {
        return getValue(property, _default) as Number;
    }

    public static function getStringValue(property:String, _default:String = null):String {
        return getValue(property, _default) as String;
    }

    public static function getBooleanValue(property:String, _default:Boolean = false):Boolean {
        return getValue(property, _default) as Boolean;
    }

    public static function getValue(property:String, _default:Object):Object {
        return INSTANCE.getValue(property, _default);
    }

    public function getValue(property:String, _default:Object):Object {
        return config ? (config.data[property]?  config.data[property] : _default) : _default;
    }

    public static function setValue(property:String, value:Object, saveImmediatly:Boolean = true):void {
        INSTANCE.setValue(property, value, saveImmediatly);
    }

    public function setValue(property:String, value:Object, saveImmediatly:Boolean = true):void {
        if (config) {
            config.data[property] = value;
            if (saveImmediatly) {
                try {
                    config.flush(10000);
                } catch (error:Error) {
                    log.error("Error...Could not write SharedObject to disk: " + COOKIE_NAME + "." + property + "=" + value);
                }
            }
        }
    }

    public function Cookie() {
        try {
            config = SharedObject.getLocal(COOKIE_NAME);
        } catch (error:Error) {
            log.error("Error...Could not read SharedObject " + COOKIE_NAME);
        }
    }

}
}