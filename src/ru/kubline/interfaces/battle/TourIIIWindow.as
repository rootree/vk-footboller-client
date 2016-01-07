package ru.kubline.interfaces.battle {
import flash.events.Event;

import flash.text.TextField;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.stadium.*;
import ru.kubline.gui.controls.UIWindow;

import flash.display.SimpleButton;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.loader.ClassLoader;
import ru.kubline.model.TeamProfiler;
import ru.kubline.social.events.LoadCitiesEvent;
import ru.kubline.social.events.LoadCountriesEvent;
import ru.kubline.social.model.SocialCity;
import ru.kubline.social.model.SocialCountry;
import ru.kubline.utils.EndingUtils;

public class TourIIIWindow extends UIWindow{
 
    public var stadiumShop:StadiumShopMenu;

    private var closeBtn:UISimpleButton;

    private var placeVK:TextField;
    private var placeCountry:TextField;
    private var placeCity:TextField;
    private var placeUni:TextField;

    private var accessVK:TextField;
    private var accessCountry:TextField;
    private var accessCity:TextField;
    private var accessUNI:TextField;
    
    private var nameCountry:TextField;
    private var nameCity:TextField;
    private var nameUin:TextField;
    
    private var tourIIICounter:TextField;

    public function TourIIIWindow() { 
        super(ClassLoader.getNewInstance(Classes.PANEL_TUER_III));
    }   

    override protected function initComponent():void{
        super.initComponent();

        placeVK = TextField(container.getChildByName("placeVK"));
        placeCountry = TextField(container.getChildByName("placeCountry"));
        placeCity = TextField(container.getChildByName("placeCity"));
        placeUni = TextField(container.getChildByName("placeUni"));

        nameCountry = TextField(container.getChildByName("nameCountry"));
        nameCity = TextField(container.getChildByName("nameCity"));
        nameUin = TextField(container.getChildByName("nameUin"));

        accessVK = TextField(container.getChildByName("accessVK"));
        accessCountry = TextField(container.getChildByName("accessCountry"));
        accessCity = TextField(container.getChildByName("accessCity"));
        accessUNI = TextField(container.getChildByName("accessUNI"));

        tourIIICounter = TextField(container.getChildByName("tourIIICounter"));

    }

    override public function destroy():void{
        super.destroy();
    }
 

    override public function show():void{

        super.show();
        
        var teamProfiler:TeamProfiler = Application.teamProfiler;

        var userCountry:String = (teamProfiler.getSocialData() && teamProfiler.getSocialData().getCountryName()) ? teamProfiler.getSocialData().getCountryName() : "N/A" ;
        var userCity:String = (teamProfiler.getSocialData() && teamProfiler.getSocialData().getCityName()) ? teamProfiler.getSocialData().getCityName() : "N/A" ;
        var userUin:String = (teamProfiler.getSocialData() && teamProfiler.getSocialData().getUniversityName()) ? teamProfiler.getSocialData().getUniversityName() : "N/A" ;

        nameCountry.text = userCountry;
        nameCity.text = userCity ;
        nameUin.text = userUin ;

        setPlace(placeVK, teamProfiler.getPlaceVK());
        setPlace(placeCountry, teamProfiler.getPlaceCountry());
        setPlace(placeCity, teamProfiler.getPlaceCity());
        setPlace(placeUni, teamProfiler.getPlaceUniversity());

        showAccess(accessVK, teamProfiler.getPlaceVK());
        showAccess(accessCountry, teamProfiler.getPlaceCountry());
        showAccess(accessCity, teamProfiler.getPlaceCity());
        showAccess(accessUNI, teamProfiler.getPlaceUniversity());

        tourIIICounter.text = teamProfiler.getTourIII().toString() + EndingUtils.chooseEnding(teamProfiler.getTourIII(), " баллов", " балл", " балла") ; 
    }

    private function setPlace(text:TextField, place:uint):void{ 
        if(place == 0){
            text.textColor = 0xCCCCCC;
            text.text = "-";
        }else{
            text.textColor = 0xEAEAEA;
            text.text = place.toString();
        } 
    }

    private function showAccess(text:TextField, place:uint):void{
        if(place > 32){
            text.textColor = 0xCCCCCC;
            text.text = "вы не проходите отборочные соревнования";
        } else {
            if(place == 0){
                text.textColor = 0xCCCCCC;
                text.text = "Вы не участвуете в этом соревновании";
            }else{
                text.textColor = 0xEAEAEA;
                text.text = "вы проходите отборочные соревнования";
            }
        }
    }

}
}