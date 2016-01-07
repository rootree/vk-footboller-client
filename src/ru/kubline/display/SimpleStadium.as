package ru.kubline.display {

import com.greensock.TweenMax;


import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.events.MouseEvent;

import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

/**
 * Класс описывает дорогу на сцене
 * @author lelka
 */
public class SimpleStadium extends AbstractItem{

    private var city:String;

    private var tytle:String;

    private var daily:uint;

    private var rating:uint;

    public function SimpleStadium(building:ItemResource) {
        super(building); 
        init();
    }

    /*
     * фукнция инициализации эклемпляра изо-элемента.
     * */
    private function init():void {
        var params:Object = ItemTypeStore.getItemResourceById(getClassId()).getParams();
        for (var param:String in params) {
            this[param] = params[param];
        }
   }


    public function getCity():String {
        return city;
    }

    public function getTytle():String {
        return tytle;
    }


    public function getDaily():uint {
        return daily;
    }

    public function getRating():uint {
        return rating;
    }
}
}

