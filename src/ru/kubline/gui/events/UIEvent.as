package ru.kubline.gui.events {

/**
 * класс в котором необходимо определять
 * все константы расслылаемых событий от GUI
 *
 * @autor denis
 */
public class UIEvent {

    /**
     * выбрана ячейка меню
     */
    public static const MENU_ITEM_SELECT:String = "MENU_ITEM_SELECT";


    /**
     * если клинкнули по ячейке, даже если она недоступна
     */
    public static const MENU_ITEM_CLICK:String = "MENU_ITEM_CLICK";
    public static const MENU_ITEM_DOUBLE_CLICK:String = "MENU_ITEM_DOUBLE_CLICK";

    /**
     * окно закрыто по кнопке close
     */
    public static const WINDOW_CLOSE:String = "WINDOW_CLOSE";

    /**
     * при появлении окна
     */
    public static const WINDOW_SHOW:String = "WINDOW_SHOW";

    /**
     * при появлении окна
     */
    public static const ELEMENT_CHANGED:String = "ELEMENT_CHANGED";

    public function UIEvent() {
    }
}
}