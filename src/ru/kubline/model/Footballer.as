package ru.kubline.model {
import ru.kubline.loader.ItemTypeStore;

public class Footballer {

    public static const ACTIVEED:uint = 1;
    public static const DEACTIVEED:uint = 2;

    public static const MAX_FOOTBALLER_LEVEL:uint = 10;
    public static const MAX_TEAM:uint = 11;
    public static const MAX_FRIENDS_IN_TEAM:uint = 11;
    public static const MAX_PARAMETER:uint = 99999;

    private var footballerName:String;

    private var level:uint;

    private var type:String;

    private var id:uint;

    private var isFriend:Boolean;

    private var isActive:Boolean;

    private var photoForFriend:String;

    private var teamName:String;

    private var price:uint;

    private var country_code:uint;

    private var year:uint;

    private var favorite:String;

    private var healthDown:uint;

    public function Footballer(footballerName:String, level:uint, type:String, id:uint, isFriend:Boolean, isActive:Boolean,
                               photoForFriend:String, price:uint, country_code:uint = 0, year:uint = 0 , favorite:String = "0", healthDown:uint = 0) {
        this.footballerName = footballerName ;
        this.level = level;
        this.type = type;
        this.id = id;
        this.isFriend = isFriend;
        this.isActive = isActive;
        this.photoForFriend = photoForFriend;
        this.price = price;
        this.country_code = country_code;
        this.year = year;
        this.favorite = favorite;
        this.healthDown = healthDown;
    }

    public function getFootballerName():String {
        return footballerName;
    }

    public function setFootballerName(value:String):void {
        footballerName = value;
    }

    public function getLevel():uint {
        if(level < 0) level = 0;
        return level;
    }

    public function setLevel(value:uint):void {
        if(value > TeamProfiler.MAX_FOOTBALLER_PARAM){
            return;
        }

        if(getIsActive()){

            switch(getType()){
                case ItemTypeStore.TYPE_FORWARD:
                    Application.teamProfiler.setParamForward(Application.teamProfiler.getParamForward() + value - getLevel());
                    break;
                case ItemTypeStore.TYPE_HALFSAFER:
                    Application.teamProfiler.setParamHalf(Application.teamProfiler.getParamHalf() + value - getLevel());
                    break;
                case ItemTypeStore.TYPE_SAFER:
                    Application.teamProfiler.setParamSafe(Application.teamProfiler.getParamSafe() + value - getLevel());
                    break;
                case ItemTypeStore.TYPE_GOALKEEPER:
                    break;
            }
        }

        level = value;
    }

    public function getType():String {
        return type;
    }

    public function getTypeToString():String {
        switch(getType()){
            case ItemTypeStore.TYPE_FORWARD:
                return "Нападающий";
                break;
            case ItemTypeStore.TYPE_HALFSAFER:
                return "Полузащитник";
                break;
            case ItemTypeStore.TYPE_SAFER:
                return "Защитник";
                break;
            case ItemTypeStore.TYPE_GOALKEEPER:
                return "Вратарь";
                break;
        }
        return "Не выбрано";              
    }

    public function setType(value:String):void {
        type = value;
    }

    public function getId():uint {
        return id;
    }

    public function setId(value:uint):void {
        id = value;
    }

    public function getIsFriend():Boolean {
        return isFriend;
    }

    public function setIsFriend(value:Boolean):void {
        isFriend = value;
    }

    public function getIsActive():Boolean {
        return isActive;
    }

    public function getPhoto():String {
        return photoForFriend;
    }

    public function getPrice():uint {
        return price;
    }

    public function setIsActive(value:Boolean):void {
        isActive = value;
    }

    public function getYear():uint{
        return year;
    }

    public function getCountryCode():uint {
        return country_code;
    }

    public function getTeamName():String {
        return teamName;
    }

    public function setYear(value:uint):void{
        year = value;
    }

    public function setCountryCode(value:uint):void {
        country_code = value;
    }

    public function setTeamName(value:String):void {
        teamName = value;
    }

    public function setFavorite(value:String):void {
        favorite = value;
    }

    public function getFavorite():String {
        return favorite;
    }

    public function isFavorite():Boolean {
        return Boolean(favorite == "1");
    }

    public function getHealthDown():uint {
        return healthDown;
    }

    public function setHealthDown(value:uint):void {
        healthDown = value;
    }
}
}