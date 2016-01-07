package ru.kubline.interfaces {
import flash.display.MovieClip;

import flash.text.TextField;

import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:37:09 PM
 */

public class SelectionChampItem extends UIMenuItem{


    /**
     * Иконка элемента
     */
    private var iconPanel:MovieClip;

    private var enemyLevel:TextField;
    private var teamName:TextField;


    private var compareSafe:QuantityPanel;
    private var compareForward:QuantityPanel;
    private var compareHalf:QuantityPanel;

    private var paramForward:TextField;
    private var paramHalf:TextField;
    private var paramSafe:TextField;

    /**
     *
     * @param container
     */
    public function SelectionChampItem(container:MovieClip) {
        super(container);
        initComponentPlus();
    }

    protected function initComponentPlus():void{
        super.initComponent();

        iconPanel = MovieClip(getChildByName("icon"));

        teamName = container.getChildByName("teamName") as TextField;
        enemyLevel = container.getChildByName("enemyLevel") as TextField;

        var compareSafeM:MovieClip = MovieClip(getContainer().getChildByName("compareSafe"));
        var compareForwardM:MovieClip = MovieClip(getContainer().getChildByName("compareForward"));
        var compareHalfM:MovieClip = MovieClip(getContainer().getChildByName("compareHalf"));

        if(compareSafeM){
            compareSafe = new QuantityPanel(compareSafeM);
            compareSafe.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }
        if(compareForwardM){
            compareForward = new QuantityPanel(compareForwardM);
            compareForward.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }
        if(compareHalfM){
            compareHalf = new QuantityPanel(compareHalfM);
            compareHalf.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }

        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

    }

    override public function destroy():void{
        setItem(null);
        super.destroy();
    }

    /**
     * Настраиваем элемент магазина
     * @param value
     */
    override public function setItem(team:Object):void {

        super.setItem(team);

        if (team) {

            if(compareSafe){
                compareSafe.setValue(team.paramSafe);
            }
            if(compareForward){
                compareForward.setValue(team.paramForward);
            }
            if(compareHalf){
                compareHalf.setValue(team.paramHalf);
            }

            paramForward.text = team.paramForward;
            paramHalf.text = team.paramHalf;
            paramSafe.text = team.paramSafe;

            MessageUtils.optimizeParameterSize(paramForward, 28, 26, 20);
            MessageUtils.optimizeParameterSize(paramHalf, 28, 26, 20);
            MessageUtils.optimizeParameterSize(paramSafe, 28, 26, 20);


            enemyLevel.text = team.level;
            teamName.text = team.teamName;

            new Gallery(iconPanel, Gallery.TYPE_TEAM, team.teamLogoId);
            super.getContainer().visible = true;
            
        } else {
            setDisabled(false);
        }
        setSelectable(team != null);
    }

  
}
}