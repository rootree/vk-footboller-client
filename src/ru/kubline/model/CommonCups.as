package ru.kubline.model {
public class CommonCups {

    private var title:String;
    private var countryCode:uint;
    private var idCups:uint;

    public function CommonCups(title:String, countryCode:uint, idCups:uint) {
        this.title = title;
        this.countryCode = countryCode; 
        this.idCups = idCups;
    }

    public function getTitle():String {
        return title;
    }

    public function setTitle(value:String):void {
        title = value;
    }

    public function getCountryCode():uint {
        return countryCode;
    }

    public function setCountryCode(value:uint):void {
        countryCode = value;
    }

    public function getIdCups():uint {
        return idCups;
    }

    public function setIdCups(value:uint):void {
        idCups = value;
    }
}
}