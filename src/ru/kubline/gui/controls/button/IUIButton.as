package ru.kubline.gui.controls.button {
import ru.kubline.gui.controls.IUIComponent;

/**
 * базовый интерфейс кнопок
 */
public interface IUIButton extends IUIComponent {

    function addHandler(handler:Function):void;
    
    function removeHandler(handler:Function):void;
}
}