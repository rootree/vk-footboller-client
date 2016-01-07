package ru.kubline.interfaces {
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.gui.controls.QuantityPanel;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 2:02:41 PM
 */

public class ResultSingleStatic {

    private var userQuantity:QuantityPanel;
    private var enemyQuantity:QuantityPanel;

    private var userParam:TextField;
    private var enemyParam:TextField;


    public function ResultSingleStatic(container:MovieClip, userParamName:String, enemyParamName:String) :void{

        userParam = container.getChildByName(userParamName) as TextField;
        enemyParam = container.getChildByName(enemyParamName) as TextField;

        userQuantity = new QuantityPanel(MovieClip(container.getChildByName(userParamName + "Quantity")));
        enemyQuantity = new QuantityPanel(MovieClip(container.getChildByName(enemyParamName + "Quantity")));
        invertBar(MovieClip(userQuantity.getContainer()));
    }

    public function setValues(userValue:uint, enemyValue:uint):void{

        var maxQuValue:uint = (userValue > enemyValue) ? userValue : enemyValue;

        if(maxQuValue > 50){
            maxQuValue += 10;
        }else{
            if(maxQuValue > 10){
                maxQuValue += 5;
            }else{
                maxQuValue += 2;
            }
        }

        userQuantity.setMaxValue(maxQuValue);
        enemyQuantity.setMaxValue(maxQuValue);

        userQuantity.setValue(userValue);
        enemyQuantity.setValue(enemyValue);

        userParam.text = userValue.toString();
        enemyParam.text = enemyValue.toString();
    }

    private function invertBar(bar:MovieClip):void{ 
        bar.x += bar.width;
        bar.y += bar.height;
        bar.rotation = 180;
    }
}
}