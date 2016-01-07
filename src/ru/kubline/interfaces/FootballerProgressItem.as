package ru.kubline.interfaces {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.interfaces.menu.team.UserPlayersItem;
import ru.kubline.loader.ClassLoader;
import ru.kubline.model.Footballer;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 2:02:27 PM
 */

public class FootballerProgressItem  implements IHintProvider {

    private var container:MovieClip;

    private var fType:MovieClip;
    private var star:MovieClip;

    private var footballerName:TextField;

    private var hintable:Hintable;

    protected var item:Object = null;

    /**
     * инстанс хинта
     */
    private var hint:MovieClip = null;

    public function FootballerProgressItem(container:MovieClip) {
        this.container = container;
        footballerName = TextField(container.getChildByName("footballerName"));
        fType = MovieClip(container.getChildByName("fType"));
        star = MovieClip(container.getChildByName("star"));
 
        hint = null;

        hintable = new Hintable(container);
        hintable.setHintProvider(this);

    }

    public function init(footballer:Footballer):void {
        item = footballer;
        if(footballer.getFootballerName()){
            footballerName.text = footballer.getFootballerName();
        }else{
            footballerName.text = "N/A";
        }

        star.visible = footballer.isFavorite();
        fType.gotoAndStop("type" + footballer.getType());
    }


    /**
     * отображает hint при наведениии мышки на аватарку
     * <b>данный метод должен всегда возвращать
     * один и тот же инстанс хинта</b>
     */
    public function getHint(): DisplayObject {
        if (hint == null) {
            hint = ClassLoader.getNewInstance(Classes.FOOTBOLLER_HINT);
            if (item) {
                UserPlayersItem.updateHint(item, hint);
            }
        }
        return hint;
    }



}
}