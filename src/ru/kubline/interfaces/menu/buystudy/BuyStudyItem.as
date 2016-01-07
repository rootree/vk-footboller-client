package ru.kubline.interfaces.menu.buystudy {

import com.greensock.TweenMax;

import com.greensock.easing.Expo;

import flash.events.MouseEvent;

import ru.kubline.interfaces.PriceContainer;
import flash.display.MovieClip;
import flash.text.TextField;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.model.StudyPayment;
import ru.kubline.utils.MCUtils;

public class BuyStudyItem extends UIMenuItem{

    private const LIMIT_LENGTH_TITLE:uint = 90;

    private var studyCount:TextField;
    private var studyBG:MovieClip;

    private var peoplePrice:PriceContainer;

    /**
     *
     * @param container
     */
    public function BuyStudyItem(container:MovieClip) {
        super(container);
        studyCount = TextField(container.getChildByName("studyCount"));
        studyBG = MovieClip(container.getChildByName("studyBG"));
        peoplePrice = new PriceContainer(MovieClip(getChildByName("price")));
        peoplePrice.setColor(peoplePrice.COLOR_WFITE); 
    }

    override public function setItem(value:Object):void {
        super.setItem(value);
        var item:StudyPayment = StudyPayment(value); 

        MCUtils.enableMouser(studyBG);

        peoplePrice.setPrice(item.price, true);
        studyCount.text = item.studyCount.toString();

        getContainer().addEventListener(MouseEvent.MOUSE_OVER, function():void{
            higthLight(item.hoverColor);
        });
        getContainer().addEventListener(MouseEvent.MOUSE_OUT, function():void{
            higthLight(item.normalColor);
        });
        higthLight(item.normalColor);
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }
 
    private function higthLight(color:uint ):void {
        TweenMax.to(studyBG, 0.25, {colorTransform:{tint:color}});
    }
 

}
}