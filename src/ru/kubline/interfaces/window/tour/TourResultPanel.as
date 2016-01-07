package ru.kubline.interfaces.window.tour {
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.interfaces.battle.*;

import flash.display.MovieClip;
import flash.events.Event;

import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.battle.TourIIIResult;
import ru.kubline.interfaces.stadium.*;
import ru.kubline.gui.controls.UIWindow;

import flash.display.SimpleButton;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.store.TourIIIStore;
import ru.kubline.loader.tour.LoadTourGroupEvent;
import ru.kubline.loader.tour.TourType;
import ru.kubline.model.TeamProfiler;

public class TourResultPanel extends UIComponent{

    public var tourResult:TourIIIResult;

    private var closeBtn:UISimpleButton;

    private var cupVK:MovieClip;
    private var cupCountry:MovieClip;
    private var cupCity:MovieClip;
    private var cupUni:MovieClip;

    private var placeVK:TourInfo;
    private var placeCountry:TourInfo;
    private var placeCity:TourInfo;
    private var placeUni:TourInfo;

    private var nameCountry:TextField;
    private var nameCity:TextField;
    private var nameUin:TextField;

    private var VKresultBtn:UISimpleButton;
    private var CountryResultBtn:UISimpleButton;
    private var CityResultBtn:UISimpleButton;
    private var UniResultBtn:UISimpleButton;

    private var closeTextBtn:UISimpleButton;

    public function TourResultPanel(container:MovieClip) {
        super(container);
        tourResult = new TourIIIResult();
    }

    override protected function initComponent():void{
        super.initComponent();

        placeVK = new TourInfo(MovieClip(container.getChildByName("placeVK")));
        placeCountry = new TourInfo(MovieClip(container.getChildByName("placeCountry")));
        placeCity = new TourInfo(MovieClip(container.getChildByName("placeCity")));
        placeUni = new TourInfo(MovieClip(container.getChildByName("placeUni")));

        nameCountry = TextField(container.getChildByName("nameCountry"));
        nameCity = TextField(container.getChildByName("nameCity"));
        nameUin = TextField(container.getChildByName("nameUin"));
 
        VKresultBtn = new UISimpleButton(SimpleButton(getChildByName("VKresultBtn")));
        VKresultBtn.addHandler(onClickOnVKResult);
        VKresultBtn.setQtip("Результаты проведения турнира");

        CountryResultBtn = new UISimpleButton(SimpleButton(getChildByName("CountryResultBtn")));
        CountryResultBtn.addHandler(onClickOnCountryResult);
        CountryResultBtn.setQtip("Результаты проведения турнира");

        CityResultBtn = new UISimpleButton(SimpleButton(getChildByName("CityResultBtn")));
        CityResultBtn.addHandler(onClickOnCityResult);
        CityResultBtn.setQtip("Результаты проведения турнира");

        UniResultBtn = new UISimpleButton(SimpleButton(getChildByName("UniResultBtn")));
        UniResultBtn.addHandler(onClickOnUniResult);
        UniResultBtn.setQtip("Результаты проведения турнира");
 
        cupVK = MovieClip(getChildByName("cupVK"));
        cupCountry = MovieClip(getChildByName("cupCountry"));
        cupCity = MovieClip(getChildByName("cupCity"));
        cupUni = MovieClip(getChildByName("cupUni"));

        initData();
    }

    override public function destroy():void{

        super.destroy();

        VKresultBtn.removeHandler(onClickOnVKResult);
        CountryResultBtn.removeHandler(onClickOnCountryResult);
        CityResultBtn.removeHandler(onClickOnCityResult);
        UniResultBtn.removeHandler(onClickOnUniResult); 
    }

    private function whenGroupsLoaded(event:LoadTourGroupEvent):void {
        TourIIIStore.instance.removeEventListener(LoadTourGroupEvent.TOUR_GROUPS_LOADED, whenGroupsLoaded);

        if(TourIIIStore.getChampionsByType(event.groupType) == null){

            var message:String = "К сожалению турнир \nне проводился, \nтак как не набралось достаточного \nколичества участвующих команд ";
            new MessageBox("Сообщение", message, MessageBox.OK_BTN).show();

        }else{
            tourResult.initStore(event.groupType);
            tourResult.show();
        } 
    }


    ///--------------------------------------

    private function onClickOnVKResult(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_VK);
    }

    private function onClickOnCountryResult(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_COUNTRY);
    }

    private function onClickOnCityResult(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_CITY);
    }

    private function onClickOnUniResult(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_UNI);
    }

    private function showGroups(tourType:uint): void {

        if(TourIIIStore.isLoaded(tourType)){
            if(TourIIIStore.isFilly(tourType)){
                tourResult.initStore(tourType);
                tourResult.show();
            }else{
                new MessageBox("Информация", "Данное мероприятия было отменено из-за отсутствия команд для проведения полноценого чемпионата", MessageBox.OK_BTN).show();
            }
        }else{
            TourIIIStore.instance.addEventListener(LoadTourGroupEvent.TOUR_GROUPS_LOADED, whenGroupsLoaded);
            TourIIIStore.loadGroups(tourType);
        }
    }

    public function initData():void{
 
        var teamProfiler:TeamProfiler = Application.teamProfiler;

        nameCountry.text = (teamProfiler.getSocialData().getCountryName()) ? teamProfiler.getSocialData().getCountryName() : '-';
        nameCity.text = (teamProfiler.getSocialData().getCityName()) ? teamProfiler.getSocialData().getCityName() : '-';
        nameUin.text = (teamProfiler.getSocialData().getUniversityName()) ? teamProfiler.getSocialData().getUniversityName() : '-';
 
        setPlace(placeVK, teamProfiler.getTourPlaceVK(), cupVK);
        setPlace(placeCountry, teamProfiler.getTourPlaceCountry(), cupCountry);
        setPlace(placeCity, teamProfiler.getTourPlaceCity(), cupCity);
        setPlace(placeUni, teamProfiler.getTourPlaceUniversity(), cupUni);

    }

    private function setPlace(text:TourInfo, place:uint, cup:MovieClip):void{
        text.init(place);
        if(place == 0){
            cup.visible = false;
        }else{
            cup.visible = true;
            cup.gotoAndStop("place" + place);
        }
    }

}
}