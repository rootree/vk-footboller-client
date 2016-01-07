package ru.kubline.gui.controls.button {

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;

public class ButtonFactory {

    /**
     * созжает нужный класс кнопки в зависиомти от поданного класса
     * @param btn
     * @return
     */
    public static function createButton(btn:DisplayObject):IUIButton {
        if(btn is SimpleButton) {
            return new UISimpleButton(SimpleButton(btn));
        } else if(btn is MovieClip) {
            return new UIButton(MovieClip(btn));
        }
        return null;
    }

    public function ButtonFactory() {
    }
}
}