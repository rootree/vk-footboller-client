package ru.kubline.model {
import flash.display.MovieClip;

import ru.kubline.interfaces.menu.sponsors.SponsorItem;

public class Sponsor {

    public static const SPONSORS_LIMIT:uint = 3;

    private var sponsorName:String;

    private var energy:Number;

    private var sponsorItem:SponsorItem;

    private var id:uint;

    public function Sponsor(sponsorName:String, energy:Number, id:uint) {
        this.sponsorName = sponsorName;
        this.energy = energy;
        this.id = id;
    }
    
    public function getSponsorName():String {
        return sponsorName;
    }

    public function setSponsorName(value:String):void {
        sponsorName = value;
    }

    public function getEnergy():Number {
        return energy;
    }

    public function setEnergy(value:Number):void {
        energy = value;
    }

    public function getId():uint {
        return id;
    }

    public function setId(value:uint):void {
        id = value;
    }

    public function setItemElement(value:SponsorItem):void {
        sponsorItem = value;
    }

    public function getItemElement():SponsorItem {
        return sponsorItem;
    }
}
}