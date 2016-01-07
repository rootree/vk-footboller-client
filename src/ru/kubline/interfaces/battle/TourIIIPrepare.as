package ru.kubline.interfaces.battle {
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
import ru.kubline.interfaces.window.message.TourMessage;
import ru.kubline.loader.ClassLoader;
import ru.kubline.store.TourIIIStore;
import ru.kubline.loader.tour.LoadTourGroupEvent;
import ru.kubline.loader.tour.TourType;
import ru.kubline.model.TeamProfiler;
import ru.kubline.social.events.LoadCitiesEvent;
import ru.kubline.social.events.LoadCountriesEvent;
import ru.kubline.social.model.SocialCity;
import ru.kubline.social.model.SocialCountry;
import ru.kubline.utils.EndingUtils;

public class TourIIIPrepare extends UIWindow{

    public var tourResult:TourIIIResult;

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

    private var VKresultBtn:UISimpleButton;
    private var CountryResultBtn:UISimpleButton;
    private var CityResultBtn:UISimpleButton;
    private var UniResultBtn:UISimpleButton;

    private var VKRun:MovieClip;
    private var CountryRun:MovieClip;
    private var CityRun:MovieClip;
    private var UniRun:MovieClip;

    private var VKresult:MovieClip;
    private var CountryResult:MovieClip;
    private var CityResult:MovieClip;
    private var UniResult:MovieClip;

    private var VKRunBtn:UISimpleButton;
    private var CountryRunBtn:UISimpleButton;
    private var CityRunBtn:UISimpleButton;
    private var UniRunBtn:UISimpleButton;

    private var closeTextBtn:UISimpleButton;

    public function TourIIIPrepare() {
        super(ClassLoader.getNewInstance(Classes.PANEL_TUER_III_RESULT));
        tourResult = new TourIIIResult();
    }

    override protected function initComponent():void{
        super.initComponent();

        nameCountry = TextField(container.getChildByName("nameCountry"));
        nameCity = TextField(container.getChildByName("nameCity"));
        nameUin = TextField(container.getChildByName("nameUin"));

        accessVK = TextField(container.getChildByName("accessVK"));
        accessCountry = TextField(container.getChildByName("accessCountry"));
        accessCity = TextField(container.getChildByName("accessCity"));
        accessUNI = TextField(container.getChildByName("accessUNI"));

        tourIIICounter = TextField(container.getChildByName("tourIIICounter"));
        
        VKRun = MovieClip(container.getChildByName("VKRun"));
        CountryRun = MovieClip(container.getChildByName("CountryRun"));
        CityRun = MovieClip(container.getChildByName("CityRun"));
        UniRun = MovieClip(container.getChildByName("UniRun"));

        VKresult = MovieClip(container.getChildByName("VKResult"));
        CountryResult = MovieClip(container.getChildByName("CountryResult"));
        CityResult = MovieClip(container.getChildByName("CityResult"));
        UniResult = MovieClip(container.getChildByName("UniResult"));

  
        placeVK = TextField(VKRun.getChildByName("place"));
        placeCountry = TextField(CountryRun.getChildByName("place"));
        placeCity = TextField(CityRun.getChildByName("place"));
        placeUni = TextField(UniRun.getChildByName("place"));






        VKRunBtn = new UISimpleButton(SimpleButton(VKRun.getChildByName("runBtn")));
        VKRunBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnVKRun);
        VKRunBtn.setQtip("Результаты проведения турнира");

        CountryRunBtn = new UISimpleButton(SimpleButton(CountryRun.getChildByName("runBtn")));
        CountryRunBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnCountryRun);
        CountryRunBtn.setQtip("Результаты проведения турнира");

        CityRunBtn = new UISimpleButton(SimpleButton(CityRun.getChildByName("runBtn")));
        CityRunBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnCityRun);
        CityRunBtn.setQtip("Результаты проведения турнира");

        UniRunBtn = new UISimpleButton(SimpleButton(UniRun.getChildByName("runBtn")));
        UniRunBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnUniRun);
        UniRunBtn.setQtip("Результаты проведения турнира");



        VKresultBtn = new UISimpleButton(SimpleButton(VKresult.getChildByName("resultBtn")));
        VKresultBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnVKResult);
        VKresultBtn.setQtip("Результаты проведения турнира");

        CountryResultBtn = new UISimpleButton(SimpleButton(CountryResult.getChildByName("resultBtn")));
        CountryResultBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnCountryResult);
        CountryResultBtn.setQtip("Результаты проведения турнира");

        CityResultBtn = new UISimpleButton(SimpleButton(CityResult.getChildByName("resultBtn")));
        CityResultBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnCityResult);
        CityResultBtn.setQtip("Результаты проведения турнира");

        UniResultBtn = new UISimpleButton(SimpleButton(UniResult.getChildByName("resultBtn")));
        UniResultBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickOnUniResult);
        UniResultBtn.setQtip("Результаты проведения турнира");


        closeTextBtn = new UISimpleButton(SimpleButton(container.getChildByName("closeBtn")));
        closeTextBtn.addHandler(onCloseClick);

    }


    override public function destroy():void{

        super.destroy();

        VKRunBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnVKRun);
        CountryRunBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnCountryRun);
        CityRunBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnCityRun);
        UniRunBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnUniRun);

        VKresultBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnVKResult);
        CountryResultBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnCountryResult);
        CityResultBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnCityResult);
        UniResultBtn.getContainer().removeEventListener(MouseEvent.CLICK, onClickOnUniResult);

        closeTextBtn.removeHandler(onCloseClick);

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

    //-------------------------------------------------------

    private function onClickOnVKRun(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_VK);
    }

    private function onClickOnCountryRun(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_COUNTRY);
    }

    private function onClickOnCityRun(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_CITY);
    }

    private function onClickOnUniRun(event:MouseEvent):void {
        showGroups(TourType.TOUR_TYPE_UNI);
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

        TourIIIResult.tourType = tourType;

        hide();

        if(TourIIIStore.isLoaded(tourType)){
            if(TourIIIStore.isFilly(tourType)){
                tourResult.initStore(tourType);
                tourResult.show();
            }else{
                new TourMessage("Информация", "Данное мероприятия было отменено из-за отсутствия команд для проведения полноценого чемпионата", MessageBox.OK_BTN).show();
            }
        }else{
            TourIIIStore.instance.addEventListener(LoadTourGroupEvent.TOUR_GROUPS_LOADED, whenGroupsLoaded);
            TourIIIStore.loadGroups(tourType);
        }
    }

    override public function show():void{

        super.show(); 
        var teamProfiler:TeamProfiler = Application.teamProfiler;

        nameCountry.text = (teamProfiler.getSocialData().getCountryName()) ? teamProfiler.getSocialData().getCountryName() : '-';
        nameCity.text = (teamProfiler.getSocialData().getCityName()) ? teamProfiler.getSocialData().getCityName() : '-';
        nameUin.text = (teamProfiler.getSocialData().getUniversityName()) ? teamProfiler.getSocialData().getUniversityName() : '-';

        setPlace(placeVK, teamProfiler.getPlaceVK());
        setPlace(placeCountry, teamProfiler.getPlaceCountry());
        setPlace(placeCity, teamProfiler.getPlaceCity());
        setPlace(placeUni, teamProfiler.getPlaceUniversity());
       
        showAccess(accessVK, teamProfiler.getPlaceVK(), VKRun, VKresult, TourType.TOUR_TYPE_VK);
        showAccess(accessCountry, teamProfiler.getPlaceCountry(), CountryRun, CountryResult, TourType.TOUR_TYPE_COUNTRY);
        showAccess(accessCity, teamProfiler.getPlaceCity(), CityRun, CityResult, TourType.TOUR_TYPE_CITY);
        showAccess(accessUNI, teamProfiler.getPlaceUniversity(), UniRun, UniResult, TourType.TOUR_TYPE_UNI);

        tourIIICounter.text = teamProfiler.getTourIII().toString() +  EndingUtils.chooseEnding(teamProfiler.getTourIII(), " проходных баллов", " проходной балл", " проходных балла") ;


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

    private function showAccess(text:TextField, place:uint, ResultBtn:MovieClip, RunBtn:MovieClip, tourType:uint):void{

        ResultBtn.visible = !(place > 32 || place == 0);
        RunBtn.visible = (place > 32 || place == 0);

        if(place > 32){
            text.textColor = 0xCCCCCC;
            text.text = "Вы не проходите отборочные соревнования";
        } else {
            if(place == 0){
                text.textColor = 0xCCCCCC;
                text.text = "Вы не участвуете в этом соревновании";
            }else{
                text.textColor = 0xEAEAEA;
                text.text = "вы проходите отборочные соревнования";
 
                if(TourIIIStore.isLoaded(tourType)){

                    if(TourIIIStore.isCompleteCurrentTour(tourType)){
                        text.text = "Вы прошли групповые соревнования";
                        ResultBtn.visible =(true);
                        RunBtn.visible =(false);
                    } 
                } 
            }
        }
    }

}
}