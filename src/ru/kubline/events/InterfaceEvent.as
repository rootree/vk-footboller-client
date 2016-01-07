package ru.kubline.events {

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:42:49 PM
 */

public class InterfaceEvent {
 
    /**
     * сообщение рассылаеться когда
     * палзунок слайдера сдвинулся
     */
    public static const SLIDE_MOVE:String = "SlideMove";

    /**
     * меню закрылось по кнопке ok
     */
    public static const MENU_OK:String = "MENU_OK";

    /**
     * нажата кнопка в банке купить рубины
     */
    public static const BUY_CURRENCY:String = "BUY_CURRENCY";

    /**
     * нажата кнопка в банке положить голоса
     */
    public static const CHANGE_BALANCE:String = "CHANGE_BALANCE";

    public static const STADY_POINT_EXHAUSTED:String = "STADY_POINT_EXHAUSTED";

    public static const LOCK_UP_BUTTON:String = "LOCK_UP_BUTTONS";

    public static const GLOBAL_LOCK_UP_BUTTONS:String = "GLOBAL_LOCK_UP_BUTTONS";


    public function InterfaceEvent() {
    }
}
}