package ru.kubline.gui.controls {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.core.UIClasses;
import ru.kubline.loader.ClassLoader;

/**
 * класс текстовой подсказки
 */
public class Qtip implements IHintProvider {

    private const padding_h:int = 35;

    private const padding_v:int = 20;

    private var hint:MovieClip;

    public function Qtip(htmlText:String) {
        hint = ClassLoader.getNewInstance(UIClasses.QTIP);

        var text:TextField = TextField(hint.getChildByName("text"));
        text.autoSize = TextFieldAutoSize.CENTER;
        text.htmlText = htmlText;

        var panel:MovieClip = MovieClip(hint.getChildByName("panel"));
        panel.height = 2 * text.y + text.height;
    }


    public function getHint():DisplayObject {
        return hint;
    }
}
}