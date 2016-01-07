package ru.kubline.interfaces.battle.fight {
import ru.kubline.crypto.MD5v2;
import ru.kubline.interfaces.SelectionChamp;
import ru.kubline.interfaces.battle.*;
import ru.kubline.interfaces.battle.fight.*;

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
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;
import ru.kubline.store.TeamProfilesStore;
import ru.kubline.store.TourIIIStore;
import ru.kubline.utils.ObjectUtils;

public class FightProcess extends UIComponent {

    public static const FIGHT_TYPE_GROUPS:String = 'groupsFight';
    public static const FIGHT_TYPE_PLAY_OFF:String = 'playOffFight';

    protected var processing:ProcessingGame;
    protected var resultPanel:ResultPanel;

    public static var typeOfFight:String;
    
    protected var detailId:uint;

    public var step:Object;

    public function FightProcess(container:MovieClip) {
        super(container);
    }
 
    public function onStartFight(groupStep:FightStartEvent):void {

        step = groupStep.getFightStep();
        
        if(resultPanel){
            resultPanel.hide();
        }

        if(Application.teamProfiler.getEnergy() <= 15){
            var msgBox:MessageBox = new MessageBox("Сообщение", SelectionChamp.enegryMessage
                    , MessageBox.OK_BTN); ;
            msgBox.show();

        }else{

            dispatchEvent(new Event(GroupsFightPanel.HIDE_TOUR));

            var scoreST:String =  MD5v2.encrypt ( step.result.toString() + step.vk_id_enemy.toString()  + "FUZ" );

            Singletons.connection.addEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenGotResult);
            Singletons.connection.send(HTTPConnection.COMMAND_GET_MATCH_RESULT, {
                enemyTeamId : parseInt(step.vk_id_enemy),
                score       : scoreST,
                type        : typeOfFight,
                typeTour    : TourIIIResult.tourType,
                detailId    : detailId
            });
        }
    }

    protected function whenGotResult(e:Event):void {

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenGotResult);

        var result:Object = HTTPConnection.getResponse();

        if(result){
            if(!processing){
                processing = new ProcessingGame();
            }
 
            var team:TeamProfiler = TeamProfilesStore.getProfileById(parseInt(step.vk_id_enemy));

            processing.addEventListener(ResultPanel.PLEASE_SHOW, onShowResult);



            processing.showProgress(team, result, true);

        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "Соперник отказался от матча.", MessageBox.OK_BTN); ;
            msgBox.show();
            msgBox.destroyOnRemove = true;
        };
    }

    protected function onShowResult(event:Event):void {

        processing.removeEventListener(ResultPanel.PLEASE_SHOW, onShowResult);

        var result:Object = HTTPConnection.getResponse(); 
        var team:TeamProfiler = TeamProfilesStore.getProfileById(parseInt(step.vk_id_enemy));

        resultPanel = new ResultPanel(team, result, true);
        resultPanel.addEventListener(ResultPanel.CONTINUE_FIGHT, onPleaseContinue);
        resultPanel.show();
    }

    protected function onPleaseContinue(event:Event):void {

        resultPanel.hide();
        resultPanel.removeEventListener(ResultPanel.CONTINUE_FIGHT, onPleaseContinue);

        dispatchEvent(new Event(GroupsFightPanel.SHOW_TOUR));
 
    }


}
}