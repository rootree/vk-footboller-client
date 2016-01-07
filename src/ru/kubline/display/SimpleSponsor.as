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
public class SimpleSponsor extends AbstractItem{

    private var energy:Number;

    public function SimpleSponsor(building:ItemResource) {
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


    public function getEnergy():Number {
        return energy;
    }

    public function setEnergy(value:Number):void {
        energy = value;
    }
}
}