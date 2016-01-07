package ru.kubline.model {
import flash.display.MovieClip;

import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

public class Stadium {

    private var stadiumName:String;

    private var cityName:String;

    private var dailyBonus:uint;

    private var rating:uint;

    private var price:Price;

    private var id:uint;

    private var photo:String;

    public function getCityName():String {
        return cityName;
    }

    public function setCityName(value:String):void {
        cityName = value;
    }

    public function getName():String {
        return stadiumName;
    }

    public function getRating():uint {
        return rating;
    }

    public function setName(value:String):void {
        stadiumName = value;
    }

    public function getDailyBonus():uint {
        return dailyBonus;
    }

    public function setDailyBonus(value:uint):void {
        dailyBonus = value;
    }

    public function Stadium(id:uint):void {

        if(id){
            init(id);
        } else {
            this.id = 0;
        }
    }

    public function init(id:uint):void {

        if(id){
            var stadium:ItemResource = ItemTypeStore.getItemResourceById(id);
            this.stadiumName = stadium.getParams().tytle;
            this.cityName = stadium.getParams().city
            this.id = stadium.getId();
            this.photo = stadium.getDisplayClass();
            this.dailyBonus = stadium.getParams().daily;
            this.rating = stadium.getParams().rating
            this.price = stadium.getPrice();
        } 
    }

    public function getId():uint {
        return id;
    }

    public function setId(value:uint):void {
        id = value;
    }
}
}