package ru.kubline.gui.controls {
import flash.events.IEventDispatcher;

/**
 * базовый интерфейс всех компонент
 */
public interface IUIComponent extends IEventDispatcher {

    /**
     * здесь должны освобождаться все ресурсы.
     */
    function destroy():void;

    function setVisible(visible:Boolean):void;

    function isVisible():Boolean;

    function setDisabled(disabled:Boolean):void;

    function isDisabled():Boolean;

    /**
     * задать текст всплывающей подсказки
     * @param value
     */
    function setQtip(value:String):void;

}
}