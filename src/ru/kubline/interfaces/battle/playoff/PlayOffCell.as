package ru.kubline.interfaces.battle.playoff {
import com.greensock.TweenMax;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.events.FightStartEvent;
import ru.kubline.gui.controls.UIComponent;
import flash.display.MovieClip;

import ru.kubline.interfaces.battle.TeamNameContainer;
import ru.kubline.interfaces.battle.fight.GroupsFightPanel;
import ru.kubline.model.TeamProfiler;
import ru.kubline.store.TeamProfilesStore;
import ru.kubline.store.TourIIIStore;
import ru.kubline.utils.MCUtils;


public class PlayOffCell extends UIComponent{

    private var teamCurrent:TeamNameContainer;
    private var teamEnemy:TeamNameContainer;
    private var score:TextField;
    private var fightMode:Boolean;
    private var stepObject:Object;

    public function PlayOffCell(container:MovieClip, fightMode:Boolean = false, stepObject:Object = null) { 
        super(container);
        this.fightMode = fightMode;
        this.stepObject = stepObject;
    }

    override protected function initComponent():void{
        super.initComponent(); 
        teamCurrent = new TeamNameContainer(MovieClip(container.getChildByName("teamCurrent")));
        teamEnemy = new TeamNameContainer(MovieClip(container.getChildByName("teamEnemy")));
        score = TextField(container.getChildByName("score")); 
    }

    override public function destroy():void{
        container.removeEventListener(MouseEvent.CLICK, onStartFight); 
        super.destroy();
    }
 
    private function onStartFight(event:Event):void { 
        dispatchEvent(new FightStartEvent(stepObject)); 
    }

    public function initData(playOffData:Object):void {

        initComponent();

        var isUserTeamExists:Boolean = (playOffData.team == Application.teamProfiler.getSocialUserId() || playOffData.teamEnemy == Application.teamProfiler.getSocialUserId());

        if(fightMode){
            score.text = '?:?';
            if(isUserTeamExists){
                container.filters = [];
                TweenMax.to(container, 1, {repeat:999, glowFilter:{color:0xFFFFFF, alpha:1, blurX:3, blurY:3, strength:13}});
                // MCUtils.enableMouser(MovieClip(container));
                container.addEventListener(MouseEvent.CLICK, onStartFight);
            }
        }else{
            container.filters = [];
            if(isUserTeamExists){

                TweenMax.killTweensOf(container);
                TweenMax.to(container, 1, {glowFilter:{color:0xFFFFFF, alpha:1, blurX:2, blurY:2, strength:13}});
                // MCUtils.enableMouser(MovieClip(container), false);
            } 
            score.text = playOffData.goal + ":" + playOffData.goalEnemy;
        }

        var vkID:uint;
        var team:TeamProfiler;

        vkID = playOffData.team;
        team = TeamProfilesStore.getProfileById(vkID);
        if(team){
            teamCurrent.initContainer(team);
        }else{
            trace("ID " + vkID + " not find");
        }

        vkID = playOffData.teamEnemy;
        team = TeamProfilesStore.getProfileById(vkID);
        if(team){
            teamEnemy.initContainer(team);
        }else{
            trace("ID " + vkID + " not find");
        }

    }
 
}
}