package ru.kubline.interfaces {
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.model.Price;
import ru.kubline.utils.NumberUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:45:16 PM
 */

public class PriceContainer {

    public const COLOR_AVABLE_ITEM:uint = 0x3A4058;
    public const COLOR_UNAVABLE_ITEM:uint = 0x9198B7;
    public const COLOR_WFITE:uint = 0xFFFFFF;

    public var standartColor:uint;

    private var price:TextField;
    private var priceReal:TextField;

    public function PriceContainer(container:MovieClip) {

        price = TextField(MovieClip(container.getChildByName("price")).getChildByName("value"));
        priceReal = TextField(MovieClip(container.getChildByName("realPrice")).getChildByName("value"));

        standartColor = price.textColor;

    }

    public function setPrice(priceSet:Price, showIfAnenabled:Boolean = false, isDiscount:Boolean = false):void{
 
        price.text = NumberUtils.toNumberFormat((isDiscount ? (Math.floor(priceSet.price - priceSet.price * Application.teamProfiler.getTourBonus() / 100)) : priceSet.price)).toString();
        priceReal.text = NumberUtils.toNumberFormat((isDiscount ? (Math.floor(priceSet.realPrice - priceSet.realPrice * Application.teamProfiler.getTourBonus() / 100)) : priceSet.realPrice)).toString();

        if(showIfAnenabled){
            if(Application.teamProfiler.getMoney() >= priceSet.price ){
                price.textColor = standartColor;
            }else{
                price.textColor = COLOR_UNAVABLE_ITEM;
            }
        }

    }

    public function setColor(color:uint):void{
        price.textColor = color;
        priceReal.textColor = color;
    }
}
}