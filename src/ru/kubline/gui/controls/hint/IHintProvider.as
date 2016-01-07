package ru.kubline.gui.controls.hint {
import flash.display.DisplayObject;

/**
 * компонент с хинтом должен реализовывать этот интерфейс
 */
public interface IHintProvider {

    function getHint():DisplayObject;
}
}