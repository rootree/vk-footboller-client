package ru.kubline.interfaces.game {
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.model.Price;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.utils.InterfaceUtils;

public class UIPriceContainer extends UIComponent {

    private var priceField:UIMoney;

    private var realPriceField:UIMoney;

    private var orLabel:TextField;

    private const orLabelName:String = "orLabel";

    public function UIPriceContainer(container:MovieClip) {
        super(container);

        priceField = new UIMoney(MovieClip(getChildByName("price")));
        realPriceField = new UIMoney(MovieClip(getChildByName("realPrice")));

        orLabel = TextField(getChildByName(orLabelName));
    }

    public function setPrice(itemPrice:Price):void {
        var priceExist:Boolean = itemPrice.price > 0;
        priceField.setVisible(priceExist);
        priceField.setValue(itemPrice.price);

        var realPriceExist:Boolean = itemPrice.realPrice > 0;
        realPriceField.setVisible(realPriceExist);
        realPriceField.setValue(itemPrice.realPrice);

        if(orLabel) {
            orLabel.visible = realPriceExist && priceExist;
        }

        if (realPriceExist && priceExist) {
            if(orLabel){
                InterfaceUtils.distributeAfter(orLabel, priceField.getContainer());
                InterfaceUtils.distributeAfter(realPriceField.getContainer(), orLabel);
            } else {
                InterfaceUtils.distributeAfter(realPriceField.getContainer(), priceField.getContainer());
            }
        } else {
            realPriceField.getContainer().x = priceField.getContainer().x;
        }

    }
}

}