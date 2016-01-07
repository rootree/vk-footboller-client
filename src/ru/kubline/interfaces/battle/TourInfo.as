/**
 * Created by IntelliJ IDEA.
 * User: Ivan Chura
 * Date: 01.02.11
 * Time: 15:11
 * To change this template use File | Settings | File Templates.
 */
package ru.kubline.interfaces.battle {
import flash.display.MovieClip;
import flash.text.TextField;

public class TourInfo {

    private var placeVK:TextField;
    private var placeLabel:TextField;
    private var loseLabel:TextField;

    public function TourInfo(container:MovieClip) {
        placeVK = TextField(container.getChildByName("placeVK"));
        placeLabel = TextField(container.getChildByName("placeLabel"));
        loseLabel = TextField(container.getChildByName("loseLabel"));
    }

    public function init(place:uint):void{
        placeVK.text = place.toString();

        placeVK.visible = Boolean(place);
        placeLabel.visible = Boolean(place);
        loseLabel.visible = !Boolean(place);
    }
}
}
