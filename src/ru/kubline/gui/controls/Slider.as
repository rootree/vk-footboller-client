package ru.kubline.gui.controls {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.kubline.gui.controls.button.UISimpleButton;

public class Slider extends UIComponent {

    private var btn:UISimpleButton;

    private var minValue:int = 0;
    private var maxValue:int = 100;

    private var vertical:Boolean;
    private var maxPos:int;

    private var value:int;

    private var prevPoint:Point;

    public function Slider(container:MovieClip, vertical:Boolean = true) {
        super(container);
        btn = new UISimpleButton(SimpleButton(getChildByName("btn")));

        this.vertical = vertical;
        if (vertical) {
            maxPos = container.height - btn.getContainer().height;
        } else {
            maxPos = container.width - btn.getContainer().width;
        }

        container.parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    public function setMinValue(value:int):void {
        minValue = value;
    }

    public function setMaxValue(value:int):void {
        maxValue = value;
        setDisabled(maxValue == 0);
    }

    public function getMaxValue():int {
        return maxValue;
    }

    public function getValue():int {
        return value;
    }

    public function setValue(value:int):void {
        this.value = value;
        var pos:int = (value - minValue) * maxPos / (maxValue - minValue);
        setBtnPosition(pos);
    }

    override public function setDisabled(disabled:Boolean):void {
        this.btn.setDisabled(disabled);
        super.setDisabled(disabled);
    }

    private function onMouseMove(event:MouseEvent):void {
        if (!disabled && event.buttonDown) {
            var p:Point = new Point(event.stageX, event.stageY);
            var nextPoint:Point = container.globalToLocal(p);
            var pos:int = vertical ? nextPoint.y : nextPoint.x;
            if (pos > maxPos) {
                pos = maxPos;
            } else if (pos < 0) {
                pos = 0;
            }

            value = minValue + Math.ceil((maxValue - minValue) * pos / maxPos);
            setBtnPosition(pos);
            this.dispatchEvent(new Event(Event.CHANGE));
        }
    }

    private function setBtnPosition(pos:int):void {
        if (vertical) {
            btn.getContainer().y = pos;
        } else {
            btn.getContainer().x = pos;
        }
    }


}
}