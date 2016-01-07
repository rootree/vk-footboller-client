package ru.kubline.interfaces.window.tour {
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
import ru.kubline.utils.MessageUtils;
import ru.kubline.utils.ObjectUtils;

public class TourInProgressPanel extends UIComponent {

    private var finishDate:TextField;

    public function TourInProgressPanel(container:MovieClip) {
        super(container);
    }

    override public function setVisible(visible:Boolean):void {
        container.visible = visible;
        if(visible){
            initComponent(); 
            finishDate.text = MessageUtils.converDateToStr(Application.instance.context.getTourFinishedAt());
        }else{
            destroy();
        }
    }

    override protected function initComponent():void{ 
        super.initComponent();
        finishDate = TextField(container.getChildByName("finishDate")); 
    }

    override public function destroy():void{
        super.destroy();
    }
 
}
}