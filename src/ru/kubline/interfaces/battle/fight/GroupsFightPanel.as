package ru.kubline.interfaces.battle.fight {
import flash.events.IOErrorEvent;

import ru.kubline.events.FightStartEvent;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.interfaces.ProcessingGame;
import ru.kubline.interfaces.ResultPanel;

import flash.display.MovieClip;
import flash.events.Event;

import flash.text.TextField;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.battle.TourIIIResult;
import ru.kubline.interfaces.battle.groups.GroupsItem;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.interfaces.window.message.TourMessage;
import ru.kubline.loader.Gallery;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;
import ru.kubline.store.TeamProfilesStore;
import ru.kubline.store.TourIIIStore;
import ru.kubline.utils.ObjectUtils;

public class GroupsFightPanel extends FightProcess {

    public static const SHOW_TOUR:String = "show"   ;
    public static const HIDE_TOUR:String = "hide"   ;
 
    private var groupName:TextField;
    private var userTeam:TextField;

    private var stepsContainers:Array;

    public function GroupsFightPanel(container:MovieClip) {
        super(container);
    }

    override public function setVisible(visible:Boolean):void {
        container.visible = visible;
   /*     if(visible && !init){
            initComponent();
        }else{
            if(init){
                destroy();
            }
        }  */
    }

    override protected function initComponent():void{

        super.initComponent();

        if(init){
            return;
        }

        groupName = TextField(container.getChildByName("groupName"));

        userTeam = TextField(container.getChildByName("userTeam"));
        userTeam.text = Application.teamProfiler.getTeamName();   

        new Gallery(MovieClip(getChildByName("userTeamAva")), Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());

        var groupsSteps:Object = TourIIIStore.getGroupsStepByType(TourIIIResult.tourType);

        var counter:uint = 1;
        var stepContainer:MovieClip;
        var groupItem:GroupFightItem;

        stepsContainers = new Array();
 
        for (var key:String in groupsSteps) {

            stepContainer = MovieClip(container.getChildByName("groupStep" + counter));
            counter ++;

            groupItem = new GroupFightItem(stepContainer, groupsSteps[key]);
            
            groupItem.addEventListener(FightStartEvent.START, onStartFight);
       //     groupItem.initData();
 
            stepsContainers.push(groupItem);

        }

        if(groupsSteps[key]){
            groupName.text = GroupsItem.convertNumberGroupToString(groupsSteps[key].group_number);
        }

    }

    override public function destroy():void{ 
        for (var key:String in stepsContainers) {
            stepsContainers[key].removeEventListener(FightStartEvent.START, onStartFight);
        }
        super.destroy();
    }


    override public function onStartFight(groupStep:FightStartEvent):void {
        typeOfFight = FightProcess.FIGHT_TYPE_GROUPS; 
        detailId = groupStep.getFightStep().group_details_id; 
        groupName.text = GroupsItem.convertNumberGroupToString(groupStep.getFightStep().group_number);
        super.onStartFight(groupStep);
    }


    override protected function onPleaseContinue(event:Event):void {

        var groupsSteps:Object = TourIIIStore.getGroupsStepByType(TourIIIResult.tourType);
        groupsSteps[step.group_details_id].finished = 1;

        var counterStep:uint = 0;
        var key:String;
        for (key in groupsSteps) {
            if(groupsSteps[key].finished == 1){
                counterStep ++;
            }
        }

        if(counterStep == 3){
            TourIIIStore.setGroupsStepByType(TourIIIResult.tourType, new Object());
        }

        super.onPleaseContinue(event);
 
        if(counterStep == 3){

            var message:String;
            var title:String;

            groupsSteps = TourIIIStore.getPlayOffStepByType(TourIIIResult.tourType); 
            if(ObjectUtils.count(groupsSteps) > 0){
                title = "Поздравляем!";
                message = "Вы прошли групповой тур!\n\n Теперь вам доступны \n соревнования на вылет!";
            }else{
                title = "Плохие новости";
                message = "Вы не набрали нужного количества очков\n для перехода к следующим соревнованиям, сожалеем. \n\n Вам стоит лучше подготовиться  \n к следующим турнирам";
            }
            new TourMessage(title, message, MessageBox.OK_BTN).show();
        }

    }


}
}