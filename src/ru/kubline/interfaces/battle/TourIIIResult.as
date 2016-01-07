package ru.kubline.interfaces.battle {
import flash.display.SimpleButton;

import flash.events.Event;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.battle.fight.FightProcess;
import ru.kubline.interfaces.battle.fight.GroupsFightPanel;
import ru.kubline.interfaces.battle.groups.*;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.interfaces.battle.playoff.PlayOffPanel;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.tour.TourType;
import ru.kubline.store.TourIIIStore;
import ru.kubline.utils.ObjectUtils;

public class TourIIIResult extends UIWindow  {

    private var groupBtn:UIButton;
    private var playOffBtn:UIButton;
    private var championsBtn:UIButton;

    private var windowTitle:TextField;

    private var closeTextBtn:UISimpleButton;

    private var groupsPanel:GroupsList;
    private var playOffPanel:PlayOffPanel;
    private var championatsPanel:ChampionatsPanel;

    private var fightGroups:GroupsFightPanel;

    public static var tourType:uint;

    public function TourIIIResult() {

        super(ClassLoader.getNewInstance(Classes.PANEL_TUER_GROUPS));

        groupsPanel = new GroupsList(MovieClip(container.getChildByName("groupsPanel")));
        playOffPanel = new PlayOffPanel(MovieClip(container.getChildByName("playOffPanel")));
        championatsPanel = new ChampionatsPanel(MovieClip(container.getChildByName("championsPanel")));

        fightGroups = new GroupsFightPanel(MovieClip(container.getChildByName("GroupsFightPanel")));

    }

    override protected function onCloseClick(event:MouseEvent):void {
        fightGroups.removeEventListener(GroupsFightPanel.SHOW_TOUR, showTourWindow);
        playOffPanel.removeEventListener(GroupsFightPanel.SHOW_TOUR, showTourWindow); 
        Application.mainMenu.championnats.showTour();
        super.onCloseClick(event);
    }

    private function hideTourWindow(event:Event):void {
        hide();
    }

    private function showTourWindow(event:Event):void {
        Application.mainMenu.championnats.getTourIIIStarted().tourResult.show();
    }

    public function getCurrentGroupsFight():FightProcess {
        return fightGroups;
    }

    public function getCurrentPlayOffFight():FightProcess {
        return playOffPanel;
    }

    override protected function initComponent():void{
        super.initComponent();

        fightGroups.addEventListener(GroupsFightPanel.HIDE_TOUR, hideTourWindow);
        fightGroups.addEventListener(GroupsFightPanel.SHOW_TOUR, showTourWindow);

        playOffPanel.addEventListener(GroupsFightPanel.HIDE_TOUR, hideTourWindow);
        playOffPanel.addEventListener(GroupsFightPanel.SHOW_TOUR, showTourWindow);

        windowTitle = TextField(container.getChildByName("windowTitle"));

        groupBtn = new UIButton(MovieClip(container.getChildByName("groupBtn")));
        groupBtn.addHandler(clickOnGroupsBtn);

        playOffBtn = new UIButton(MovieClip(container.getChildByName("playOffBtn")));
        playOffBtn.addHandler(clickOnPlayOffBtn);

        championsBtn = new UIButton(MovieClip(container.getChildByName("championsBtn")));
        championsBtn.addHandler(clickOnChampionatsBtn);

        closeTextBtn = new UISimpleButton(SimpleButton(container.getChildByName("closeBtn")));
        closeTextBtn.addHandler(onCloseClick);

        hideAllPanels();
    }

    override public function destroy():void{
        super.destroy();

        fightGroups.removeEventListener(GroupsFightPanel.HIDE_TOUR, hideTourWindow);
        playOffPanel.removeEventListener(GroupsFightPanel.HIDE_TOUR, hideTourWindow);

        closeTextBtn.removeHandler(onCloseClick);
        championsBtn.removeHandler(clickOnChampionatsBtn);
        playOffBtn.removeHandler(clickOnPlayOffBtn);
        groupBtn.removeHandler(clickOnGroupsBtn);
    }

    private function hideAllPanels():void {

        groupsPanel.setVisible(false);
        playOffPanel.setVisible(false);
        championatsPanel.setVisible(false);
        fightGroups.setVisible(false);

        groupBtn.setDisabled(false);
        playOffBtn.setDisabled(false);
        championsBtn.setDisabled(false);

        // windowTitle.text = getSocialByType();

    }

    private function clickOnGroupsBtn(event:MouseEvent):void {
        hideAllPanels();
        groupsPanel.setVisible(true);
        groupBtn.setDisabled(true);
        windowTitle.text = "Групповой турнир - " + getSocialByType();

        checkShowChampions();

    }

    private function checkShowChampions():void{ 
        if(!TourIIIStore.isCompleteCurrentTour() && !Application.teamProfiler.isNewTour()){
            championsBtn.setDisabled(true);
        }else{
            championsBtn.setDisabled(false);
        }
    }

    private function clickOnPlayOffBtn(event:MouseEvent):void {
        hideAllPanels();
        playOffPanel.setVisible(true);
        playOffBtn.setDisabled(true);
        windowTitle.text = "Плей-Офф - " + getSocialByType();
        checkShowChampions();
    }

    private function clickOnChampionatsBtn(event:MouseEvent):void {
        hideAllPanels();
        championatsPanel.setVisible(true);

        championsBtn.setDisabled(true);
        windowTitle.text = "Победители - " + getSocialByType();
    }

    private function getSocialByType():String{
        switch(tourType){
            case TourType.TOUR_TYPE_UNI     : return Application.teamProfiler.getSocialData().getUniversityName();
            case TourType.TOUR_TYPE_CITY    : return Application.teamProfiler.getSocialData().getCityName();
            case TourType.TOUR_TYPE_COUNTRY : return Application.teamProfiler.getSocialData().getCountryName();
            case TourType.TOUR_TYPE_VK      : return "ВКонтакт";
            default: return "Футболлер";
        }
    }

    override public function show():void {

        super.show();

        hideAllPanels();

        var groupsSteps:Object = TourIIIStore.getGroupsStepByType(TourIIIResult.tourType);

        if(ObjectUtils.count(groupsSteps) > 0){

            fightGroups.setVisible(true);

            groupBtn.setDisabled(true);
            playOffBtn.setDisabled(true);
            championsBtn.setDisabled(true);

            windowTitle.text = "Групповой турнир - " + getSocialByType();

        }else{

            groupsSteps = TourIIIStore.getPlayOffStepByType(TourIIIResult.tourType);

            if(ObjectUtils.count(groupsSteps) > 0 && !Application.teamProfiler.isNewTour()){
                playOffPanel.setVisible(true);
                playOffBtn.setDisabled(true);
                championsBtn.setDisabled(true);

                windowTitle.text = "Плей-Офф - " + getSocialByType();

            }else{
                
                championatsPanel.setVisible(true); 
                championsBtn.setDisabled(true);

                windowTitle.text = "Победители - " + getSocialByType();
            }

            groupsPanel.initStore(tourType);
            playOffPanel.initStore(tourType); 
            championatsPanel.initTeams(tourType);

        }

    }

    public function initStore(tourType:uint):void {
        TourIIIResult.tourType = tourType;
    }

}
}