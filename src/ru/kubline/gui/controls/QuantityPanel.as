package ru.kubline.gui.controls {
import flash.display.DisplayObject;
import flash.display.MovieClip;

/**
 * панелька отображающая кол-во через маску, например ветер, кол-во опыта...
 */
public class QuantityPanel extends UIComponent {

    /**
     * объект маска
     */
    private var mask:DisplayObject;

    /**
     * макс ширина маски
     */
    private var maskMaxWidth:int;

    /**
     * макс занчение
     */
    private var maxValue:Number;

    public function QuantityPanel(container:MovieClip, maxValue:Number = 1) {
        super(container);
        this.mask = getChildByName("mask_panel");
        this.maskMaxWidth = mask.width;
        this.maxValue = maxValue;
    }

    public function setMaxValue(value:Number):void {
        maxValue = value;
    }

    public function setValue(value:Number):void {
        mask.width = maskMaxWidth * value / maxValue;
    }

    public function getMaxMask():Number {
        return maskMaxWidth;
    }

    public function setMaxMask(value:Number):void {
         maskMaxWidth = value;
    }
}
}