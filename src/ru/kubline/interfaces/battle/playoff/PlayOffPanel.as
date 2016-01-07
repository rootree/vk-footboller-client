package ru.kubline.interfaces.battle.playoff {
import flash.events.Event;

import ru.kubline.events.FightStartEvent;
import ru.kubline.gui.controls.UIComponent;
import flash.display.MovieClip;

import ru.kubline.interfaces.battle.TourIIIResult;
import ru.kubline.interfaces.battle.fight.FightProcess;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.interfaces.window.message.WinTourlMessage;
import ru.kubline.model.CupPlaces;
import ru.kubline.net.HTTPConnection;
import ru.kubline.store.TourIIIStore;


public class PlayOffPanel extends FightProcess  {

    private var playOffFinalBG:MovieClip;

    private var step16:MovieClip;
    private var step8:MovieClip;
    private var step4:MovieClip;
    private var step2:MovieClip;
    private var stepThird:MovieClip;

    private var playOffStore:Array;

    private var currentPlayOffStep:uint;

    public function PlayOffPanel(container:MovieClip) {
        super(container);
        playOffStore = new Array();
    }

    override protected function initComponent():void{
        super.initComponent();

        playOffFinalBG = MovieClip(container.getChildByName("playOffFinalBG"));
        
        step16 = MovieClip(container.getChildByName("step16"));
        step8 = MovieClip(container.getChildByName("step8"));
        step4 = MovieClip(container.getChildByName("step4"));
        step2 = MovieClip(container.getChildByName("step2"));
        stepThird = MovieClip(container.getChildByName("stepThird"));

    }

    override public function destroy():void{
        for (var key:String in playOffStore) {
            PlayOffCell(playOffStore[key]).removeEventListener(FightStartEvent.START, onStartFight);
        }
        super.destroy();
    }

    public function initStore(tourType:uint):void {

        step16.visible = true;
        step8.visible = true;
        step4.visible = true;
        step2.visible = true;
        stepThird.visible = true;
        playOffFinalBG.visible = true;

        var data:Array;
        data = TourIIIStore.getPlayOffStoreByType(tourType);

        var playOffContainer:MovieClip;
        var chuldIndex:uint;
        var playOffData:Object;
        var playOffCell:PlayOffCell;
        var subKey:String;

        var groupsSteps:Object = TourIIIStore.getPlayOffStepByType(TourIIIResult.tourType);

        var fightMode:Boolean = false;
        var stepObject:Object = new Object();
        if(groupsSteps[4] && groupsSteps[4].finished == '0'){
            fightMode = true;
            stepObject = groupsSteps[4];
            currentPlayOffStep = 4;
        }

        for (subKey in data[4]) {
            chuldIndex = parseInt(subKey);
            playOffContainer = MovieClip(step16.getChildByName("playOffCell" + chuldIndex));

            playOffData = data[4][subKey];

            playOffCell = new PlayOffCell(playOffContainer, fightMode, stepObject);
            playOffCell.initData(playOffData);
            playOffCell.addEventListener(FightStartEvent.START, onStartFight);
            playOffStore.push(playOffCell);

        }

        if(fightMode){
            step8.visible = false;
            step4.visible = false;
            step2.visible = false;
            stepThird.visible = false;
            playOffFinalBG.visible = false;
            return;
        }

        fightMode = false;
        stepObject = new Object();
        if(groupsSteps[3] && groupsSteps[3].finished == '0'){
            fightMode = true;
            stepObject = groupsSteps[3];
            currentPlayOffStep = 3;
        }
        for (subKey in data[3]) {
            chuldIndex = parseInt(subKey);
            playOffContainer = MovieClip(step8.getChildByName("playOffCell" + chuldIndex));

            playOffData = data[3][subKey];

            playOffCell = new PlayOffCell(playOffContainer, fightMode, stepObject);
            playOffCell.initData(playOffData);
            playOffCell.addEventListener(FightStartEvent.START, onStartFight);
            playOffStore.push(playOffCell);

        }

        if(fightMode){
            step4.visible = false;
            step2.visible = false;
            stepThird.visible = false;
            playOffFinalBG.visible = false;
            return;
        }

        fightMode = false;
        stepObject = new Object();
        if(groupsSteps[2] && groupsSteps[2].finished == '0'){
            fightMode = true;
            stepObject = groupsSteps[2];
            currentPlayOffStep = 2;
        }
        for (subKey in data[2]) {

            chuldIndex = parseInt(subKey);
            playOffContainer = MovieClip(step4.getChildByName("playOffCell" + chuldIndex));

            playOffData = data[2][subKey];

            playOffCell = new PlayOffCell(playOffContainer, fightMode, stepObject);
            playOffCell.initData(playOffData);
            playOffCell.addEventListener(FightStartEvent.START, onStartFight);
            playOffStore.push(playOffCell);

        }

        if(fightMode){
            step2.visible = false;
            stepThird.visible = false;
            return;
        }


        fightMode = false;
        stepObject = new Object();
        if(groupsSteps[1] && groupsSteps[1].finished == '0'){
            fightMode = true;
            stepObject = groupsSteps[1];
            currentPlayOffStep = 1;
        }

        playOffData = data[1][0];
        playOffCell = new PlayOffCell(step2, fightMode, stepObject);
        playOffCell.initData(playOffData);

        var placer:CupPlaces = TourIIIStore.getChampionsByType(TourIIIResult.tourType);

        if(placer.third != Application.teamProfiler.getSocialUserId()){
            playOffCell.addEventListener(FightStartEvent.START, onStartFight);
        }

        playOffStore.push(playOffCell);
 
        playOffData = data[1][1];
        playOffCell = new PlayOffCell(stepThird, fightMode, stepObject);
        playOffCell.initData(playOffData);

        if(placer.third == Application.teamProfiler.getSocialUserId()){
            playOffCell.addEventListener(FightStartEvent.START, onStartFight);
        }

        playOffStore.push(playOffCell); 
    }

    override public function onStartFight(groupStep:FightStartEvent):void {
        typeOfFight = FightProcess.FIGHT_TYPE_PLAY_OFF;
        detailId = groupStep.getFightStep().play_off_id;
        super.onStartFight(groupStep);
    }


    override protected function onPleaseContinue(event:Event):void {

        var playOffSteps:Object = TourIIIStore.getPlayOffStepByType(TourIIIResult.tourType);
        playOffSteps[currentPlayOffStep].finished = '1';
 
        var message:String;
        var title:String;
        
        if(currentPlayOffStep != 1){

            if(!playOffSteps[currentPlayOffStep - 1]){ 
                message = "К сожалению вы проиграли \n Вы выбываете из финальных соревнований \n\n В следующий раз удача будет \n на вашей стороне";
                title = "Плохие новости";
                TourIIIStore.setPlayOffStepByType(TourIIIResult.tourType, new Object());
            }

            if(message){
                new MessageBox(title, message, MessageBox.OK_BTN).show();
            }

        }else{

            if(currentPlayOffStep == 1){
                
                TourIIIStore.setPlayOffStepByType(TourIIIResult.tourType, new Object());
 
                var isLeader:Boolean = false;
                var placer:CupPlaces = TourIIIStore.getChampionsByType(TourIIIResult.tourType);


                var result:Object = HTTPConnection.getResponse();

                var remsgBox:WinTourlMessage = new WinTourlMessage();
                remsgBox.showMSG(TourIIIResult.tourType, parseFloat(result.bonus), parseFloat(result.totalBonus)); 
            }


        }

        super.onPleaseContinue(event);


    }

}
}