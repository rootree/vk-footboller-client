package ru.kubline.interfaces.menu {
import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.events.InterfaceEvent;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:53:08 PM
 */

public class SettingsFootballerMenu extends UIComponent{

    public static const CHANGES_MAKE:String = "ChangesMake";

    private var playerLine:TextField;
    private var availableStady:TextField;
    private var paramForward:TextField;

    private var megaBall:MovieClip;
    private var superFootballer:MovieClip;
    private var fType:MovieClip;

    private var compareForward:QuantityPanel;
    private var addonLearnBonus:UIButton;
    private var minusLearnBonus:UIButton;

    private var safeBtn:UISimpleButton;

    private var closeBtn:UISimpleButton;
    private var player:Footballer;
    
    private var tempPlayerParam:uint;
    private var tempSdatyPoint:uint;


    public function SettingsFootballerMenu(container:MovieClip) { 
        super(container);

        compareForward = new QuantityPanel(MovieClip(container.getChildByName("compareForward")));
        compareForward.setMaxValue(TeamProfiler.MAX_FOOTBALLER_PARAM);
        compareForward.setQtip("Уровень мастерства вашего футболиста");
    }
  
    override protected function initComponent():void{
        super.initComponent();
 
        playerLine = TextField(container.getChildByName("playerLine"));;
        availableStady = TextField(container.getChildByName("availableStady"));;
        paramForward = TextField(container.getChildByName("paramForward"));;
        megaBall = MovieClip(container.getChildByName("megaBall"));;
        superFootballer = MovieClip(container.getChildByName("superFootballer"));;
        fType = MovieClip(container.getChildByName("fType"));;

        addonLearnBonus = new UIButton(MovieClip(container.getChildByName("addonLearnBonus")));
        minusLearnBonus = new UIButton(MovieClip(container.getChildByName("minusLearnBonus")));

        closeBtn = new UISimpleButton(SimpleButton(container.getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        safeBtn = new UISimpleButton(SimpleButton(container.getChildByName("safeBtn")));
        safeBtn.addHandler(onSaveClick);

        minusLearnBonus.setDisabled(true);
        addonLearnBonus.setDisabled((Application.teamProfiler.getStudyPoints() == 0));

        addonLearnBonus.addHandler(addFootballerLevel);
        minusLearnBonus.addHandler(minusFootballerLevel);

    }

    override public function destroy():void{
        
        closeBtn.removeHandler(onCloseClick);
        safeBtn.removeHandler(onSaveClick);
        addonLearnBonus.removeHandler(addFootballerLevel);
        minusLearnBonus.removeHandler(minusFootballerLevel);

        super.destroy();
    }

    private function onSaveClick(event:MouseEvent):void {
        dispatchEvent(new Event(SettingsFootballerMenu.CHANGES_MAKE));
    }

    private function onCloseClick(event:MouseEvent):void { 
        player.setLevel(tempPlayerParam);
        Application.teamProfiler.setStudyPoints(tempSdatyPoint);

        dispatchEvent(new Event(UIEvent.ELEMENT_CHANGED));
        dispatchEvent(new Event(SettingsFootballerMenu.CHANGES_MAKE));
    }

    public function initData(player:Footballer):void {
 
        tempPlayerParam = player.getLevel();
        tempSdatyPoint = Application.teamProfiler.getStudyPoints();

        this.player = player;
        playerLine.text = player.getTypeToString();

        compareForward.setValue(player.getLevel());
        fType.gotoAndStop("type" + player.getType());
        setEnauthStadyPointText();

        if(!player.isFavorite()){
            superFootballer.alpha = UserPanel.MEGA_BOLL_ALPHA;
        }else{
            superFootballer.alpha = 1;
        }

    }

    private function setEnauthStadyPointText():void {
        if(Application.teamProfiler.getStudyPoints()){
            megaBall.alpha = 1;
            availableStady.text  = Application.teamProfiler.getStudyPoints().toString(); 
            availableStady.textColor  = UserPanel.MEGA_TXT_NORMAL;
            addonLearnBonus.setDisabled(false);
        }else{
            megaBall.alpha = UserPanel.MEGA_BOLL_ALPHA;
            availableStady.text =  "0";
            availableStady.textColor  = UserPanel.MEGA_TXT_COLOR;
            addonLearnBonus.setDisabled(true);
        } 
        paramForward.text = player.getLevel().toString();
        MessageUtils.optimizeParameterSize(paramForward);
    }

    private function minusFootballerLevel(e:Event):void {

        var studyPoint:uint = player.isFavorite() ? 2 : 1;
        player.setLevel(player.getLevel() - studyPoint);

        Application.teamProfiler.setStudyPoints(Application.teamProfiler.getStudyPoints() + 1);

        setEnauthStadyPointText();

        compareForward.setValue(player.getLevel());

        addonLearnBonus.setDisabled(false);
        dispatchEvent(new Event(UIEvent.ELEMENT_CHANGED));
 
        if(tempPlayerParam == player.getLevel()){
            minusLearnBonus.setDisabled(true);
        }


    }

    private function addFootballerLevel(e:Event):void {
 
        if((player.getLevel() + 1) > TeamProfiler.MAX_FOOTBALLER_PARAM){
            /*var msgBox:MessageBox = new MessageBox("Сообщение", "Достигнут наксимальный уровень футболиста.", MessageBox.OK_BTN); ;
            msgBox.show();
            addonLearnBonus.setDisabled(true);*/
            TeamProfiler.MAX_FOOTBALLER_PARAM *= 2;
            return;
        }

        var studyPoint:uint = player.isFavorite() ? 2 : 1;  
        player.setLevel(player.getLevel() + studyPoint);
        Application.teamProfiler.setStudyPoints(Application.teamProfiler.getStudyPoints() - 1);
        setEnauthStadyPointText();

        compareForward.setValue(player.getLevel());


        if(player.getLevel() >= TeamProfiler.MAX_FOOTBALLER_PARAM){
            addonLearnBonus.setDisabled(true);
        }else{
            addonLearnBonus.setDisabled(false);
        }

        minusLearnBonus.setDisabled(false);

        dispatchEvent(new Event(UIEvent.ELEMENT_CHANGED));
 
        if(Application.teamProfiler.getStudyPoints() == 0){
            addonLearnBonus.setDisabled(true); 
        }
 
    }

    override public function setVisible(visible:Boolean):void {
        if(visible){
            initComponent();
        }else{
            destroy();
        }
        container.visible = visible;
    }
}
}