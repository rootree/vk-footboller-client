package ru.kubline.gui.controls.hint {

import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * компонент с хинтом
 * @see HintProvider
 */
public class Hintable {

    private var container:DisplayObject;

    /**
     * нужно ли добавить hint
     */
    private var needAddHint:Boolean = false;

    /**
     * добавлен ли hint к сцене
     */
    private var hintAdded:Boolean = false;

    public var hintProvider:IHintProvider;

    public function Hintable(container:DisplayObject) {
        this.container = container;
    }

    public function setHintProvider(hintProvider:IHintProvider):void {
        this.hintProvider = hintProvider;
        container.addEventListener(MouseEvent.MOUSE_MOVE, this.hintOnMouseMove);
        container.addEventListener(MouseEvent.ROLL_OUT, this.hintOnMouseOut);
    }

    public function removeHintProvider():void {
        if (hintProvider) {
            container.removeEventListener(MouseEvent.MOUSE_MOVE, this.hintOnMouseMove);
            container.removeEventListener(MouseEvent.ROLL_OUT, this.hintOnMouseOut);
            hintAdded = false;
            this.hintProvider = null;
        }
    }

    /**
     * по данному событию будем отображать hint
     */
    public function hintOnMouseMove(e:MouseEvent): void {
        if (!hintAdded) {
            var hint:DisplayObject = hintProvider.getHint();
            //если hint выходит за экран по оси Х
            if (e.stageX + hint.width > Application.stageWidth) {
                hint.x = e.stageX - hint.width - 10;
            } else {
                hint.x = e.stageX + 5;
            }
            //если hint выходит за экран по оси У
            if (e.stageY + hint.height > Application.stageHeight) {
                hint.y = Application.stageHeight - hint.height - 10;
            } else {
                hint.y = e.stageY;
            }

            //говорим что нужно добавить hint
            needAddHint = true;
            //ставим задачу на добавление
            var timer:Timer = new Timer(500);
            timer.start();
            timer.addEventListener(TimerEvent.TIMER, function():void {
                //если все еще есть такая необходимость, то добавляем
                if (needAddHint) {
                    hintAdded = true;
                   // TweenMax.from(hint, 1, {alpha:1, delay:0.4});
                    hint.alpha = 0;
                     TweenMax.to(hint, 0.3, {alpha:1});
                    Application.instance.addChild(hint);
                }
                timer.stop();
            });
        }
    }

    /**
     * по данному событию будем убирать hint
     */
    public function hintOnMouseOut(e:MouseEvent): void {
        needAddHint = false;
        //если hint был таки добавлен то удаляем его
        if (Application.instance.contains(hintProvider.getHint())) {  
            Application.instance.removeChild(hintProvider.getHint());
            hintAdded = false;
        }
    }

}
}