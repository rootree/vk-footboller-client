package ru.kubline.interfaces.menu {
import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.gui.controls.UIComponent;
import ru.kubline.model.Footballer;
import ru.kubline.utils.MCUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:53:08 PM
 */

public class SelectLineMenu extends UIComponent {

    public static const LINE_SELECTED:String = "LineSelected";
 
    private var helpLine:TextField;

    private var fType1:MovieClip;
    private var fType2:MovieClip;
    private var fType3:MovieClip;
    private var fType4:MovieClip;

    private var fNumber:uint;

    public function SelectLineMenu(container:MovieClip) {
        super(container);
    }

    override public function setVisible(visible:Boolean):void {
        if(visible){
            initComponent();
        }else{
            destroy();
        }
        container.visible = visible;
    }

    override protected function initComponent():void{
        super.initComponent();

        helpLine = TextField(container.getChildByName("helpLine"));;
        fType1 = MovieClip(container.getChildByName("fType1"));;
        fType2 = MovieClip(container.getChildByName("fType2"));;
        fType3 = MovieClip(container.getChildByName("fType3"));;
        fType4 = MovieClip(container.getChildByName("fType4"));;

        fType1.gotoAndStop("type1");
        fType2.gotoAndStop("type2");
        fType3.gotoAndStop("type3");
        fType4.gotoAndStop("type4");

        MCUtils.enableMouser(fType1);
        MCUtils.enableMouser(fType2);
        MCUtils.enableMouser(fType3);
        MCUtils.enableMouser(fType4);
         
        fType1.addEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType1.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType1.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType2.addEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType2.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType2.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType3.addEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType3.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType3.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType4.addEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType4.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType4.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

    }

    override public function destroy():void{

        fType1.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType1.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType1.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType2.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType2.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType2.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType3.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType3.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType3.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        fType4.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
        fType4.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
        fType4.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        super.destroy();
    }

    public function getSelectedLine():uint{
        return fNumber;   
    }

    private function whenSelectedLine(event:MouseEvent):void {
        fNumber = uint(event.target.name.substr(5,1));
        dispatchEvent(new Event(SelectLineMenu.LINE_SELECTED)); 
        unHightLight(event) ;
    }

    private function higthLight(bnt:Object):void {
        TweenMax.to(bnt, 0.25, {
            alpha:1,
            glowFilter:{color:0xffffff, alpha:1, blurX:2, blurY:2, strength:24}/*,
            onStartListener  : function():void{
                TweenMax.to(bnt, 0.75, {bevelFilter:{blurX:10, blurY:10, strength:1, distance:10}});
            }*/
        }) ;
    }

    private function unHightLight(event:MouseEvent):void {
        tweenerOff(fType4);
        tweenerOff(fType3);
        tweenerOff(fType2);
        tweenerOff(fType1);
        updateHelper("TEST");
    }

    private function tweenerOff(bnt:Object):void {
        bnt.filters = [];
        TweenMax.killTweensOf(bnt);
    }

    private function onShowHint(event:MouseEvent):void {
        higthLight(event.target);
        updateHelper(event.target.name);
    }

    private function updateHelper(nameFType:String):void {

        var fNumber:uint = uint(nameFType.substr(5,1));
        switch(fNumber){
            case 1: helpLine.text = "Нападающий"; break;
            case 2: helpLine.text = "Защитник"; break;
            case 3: helpLine.text = "Полузащитник"; break;
            case 4: helpLine.text = "Вратарь"; break;
            default: helpLine.text = "Выберите амплуа"; break;
        }

    }

 /*   public function set visible(vis:Boolean):void{
        container.visible = vis;

        if(vis){

            fType1.addEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType1.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType1.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType2.addEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType2.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType2.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType3.addEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType3.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType3.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType4.addEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType4.addEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType4.addEventListener(MouseEvent.MOUSE_OUT, unHightLight);
        }else{

            fType1.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType1.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType1.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType2.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType2.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType2.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType3.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType3.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType3.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);

            fType4.removeEventListener(MouseEvent.CLICK, whenSelectedLine);
            fType4.removeEventListener(MouseEvent.MOUSE_OVER, onShowHint);
            fType4.removeEventListener(MouseEvent.MOUSE_OUT, unHightLight);
        }

    }

    public function get visible():Boolean{
        return container.visible;
    }    */
}
}