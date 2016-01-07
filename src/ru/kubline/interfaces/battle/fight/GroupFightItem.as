package ru.kubline.interfaces.battle.fight {
import flash.display.MovieClip;

import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.events.FightStartEvent;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.core.UIClasses;
import ru.kubline.interfaces.SelectionChamp;
import ru.kubline.interfaces.battle.TeamNameContainer;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.model.TeamProfiler;
import ru.kubline.store.TeamProfilesStore;

public class GroupFightItem extends UIComponent {

    private var groupStep:Object;

    private var startBtn:UIButton;
    private var VSblock:MovieClip;

    private var score:TextField;
    private var result:TextField;

    private var teamName:TeamNameContainer;

    public function GroupFightItem(container:MovieClip, groupStep:Object) {
        super(container);
        this.groupStep = groupStep;
        initComponent();
    }

    override protected function initComponent():void{
        super.initComponent();

        score = TextField(container.getChildByName("score"));
        result = TextField(container.getChildByName("result"));

        teamName = new TeamNameContainer(MovieClip(getChildByName('teamCurrent')));

        VSblock = MovieClip(container.getChildByName("VSblock"));

        startBtn = new UIButton(MovieClip(getChildByName("startBtn")));
        startBtn.removeHandler(onClickOnStart);
        startBtn.addHandler(onClickOnStart);
        startBtn.setDisabled(true);

        initData();

    }

    public function initData():void{
 
        var finished:Boolean = Boolean(parseInt(groupStep.finished));

        score.visible = finished;
        result.visible = finished;

        VSblock.visible = !finished;

        startBtn.setDisabled(finished) ;

        var team:TeamProfiler = TeamProfilesStore.getProfileById(parseInt(groupStep.vk_id_enemy));
        teamName.initContainer(team);

        if(finished){

            switch(groupStep.result){
                case '1':  score.text = '3'; break;
                case '-1': score.text = '0'; break;
                case '0':  score.text = '1'; break;
            }

            result.text = groupStep.goals + ':' + groupStep.goals_enemy;
             
        }
    }

    override public function destroy():void{ 
        startBtn.removeHandler(onClickOnStart);
        super.destroy();
    }


    private function onClickOnStart(event:MouseEvent):void {

        if(Application.teamProfiler.getEnergy() <= 15){
            var msgBox:MessageBox = new MessageBox("Сообщение", SelectionChamp.enegryMessage
                    , MessageBox.OK_BTN); ;
            msgBox.show();
        }else{
            dispatchEvent(new FightStartEvent(groupStep)) ;
      //      destroy();
        }


    }
}
}