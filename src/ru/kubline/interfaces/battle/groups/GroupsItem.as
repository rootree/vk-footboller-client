package ru.kubline.interfaces.battle.groups {

import flash.display.MovieClip;
 
import flash.text.TextField;

import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.interfaces.battle.TeamNameContainer;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.TeamProfiler;
import ru.kubline.store.TeamProfilesStore;

public class GroupsItem extends UIMenuItem{

    private var groupName:TextField;

    private var teamName:Array;
    private var total:Array;
    private var win:Array;
    private var tie:Array;
    private var lose:Array;
    private var score:Array;

    /**
     *
     * @param container
     */
    public function GroupsItem(container:MovieClip) {
        super(container);

        teamName = new Array();
        total    = new Array();
        win      = new Array();
        tie      = new Array();
        lose     = new Array();
        score    = new Array();

        groupName = TextField(getChildByName("groupName"));
        var i:uint;
        var textFieldName:String;

        for (i = 1; i < 5; i++) {
            textFieldName = "teamNameContainer" + i; 
            teamName[i] = new TeamNameContainer(MovieClip(getChildByName(textFieldName)));
        }

        for (i = 1; i < 5; i++) {
            total[i] = TextField(getChildByName("teamName" + i + "Total"));
        }

        for (i = 1; i < 5; i++) {
            win[i] = TextField(getChildByName("teamName" + i + "Win" ));
        }

        for (i = 1; i < 5; i++) {
            tie[i] = TextField(getChildByName("teamName" + i + "Tie" ));
        }

        for (i = 1; i < 5; i++) {
            lose[i] = TextField(getChildByName("teamName" + i + "Lose"));
        }

        for (i = 1; i < 5; i++) {
            score[i] = TextField(getChildByName("teamName" + i + "Score" ));
        }


    }
  
    override public function setItem(groupContainer:Object):void {
        super.setItem(groupContainer);

        var groupNumber:uint;

        for (var subKey:String in groupContainer) {

            var i:uint = parseInt(subKey) + 1;

            var vkID:uint = groupContainer[subKey].vkId;
            var team:TeamProfiler = TeamProfilesStore.getProfileById(vkID);

            trace(vkID);

            TeamNameContainer(teamName[i]).initContainer(team);
            TextField(total[i]).text = '3';
            TextField(win[i]).text = groupContainer[subKey].wins;
            TextField(tie[i]).text = groupContainer[subKey].ties;
            TextField(lose[i]).text = groupContainer[subKey].loses;
            TextField(score[i]).text = groupContainer[subKey].score;

            groupNumber = groupContainer[subKey].group_number;

        }
        groupName.text = convertNumberGroupToString(groupNumber); 
    }

    public static function convertNumberGroupToString(groupNumber:uint):String{
        switch (groupNumber){
            case 0: return "Группа A";
            case 1: return "Группа B";
            case 2: return "Группа C";
            case 3: return "Группа D";
            case 4: return "Группа E";
            case 5: return "Группа F";
            case 6: return "Группа G";
            case 7: return "Группа H";
            default: return "Группа X";
        }
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    } 
}
}