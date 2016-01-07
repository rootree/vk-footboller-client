package ru.kubline.interfaces {
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.MessageUtils;

/**
 * Панель выбора чемприоната
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:29:44 PM
 */

public class SelectionChamp extends UIPagingMenu {

    public static var enegryMessage:String = "Ваша команда устала от \nизнуряющих соревнований\n\n" +
                                                                 "Закончилась энергия \nЭнергия восстанавливается\n каждые 10 минут \n\n Энергию можно восстановить мгновенно благодаря стадиону";;

    private var closeBtn:UISimpleButton;
    private var startBtn:UIButton;

    private var resultPanel:ResultPanel;
    private var processing:ProcessingGame;

    private var emenyLevel:TextField;
    private var enemyTytle:TextField;
    private var enemyTeamleadName:TextField;
    private var enemyLogo:MovieClip;
    private var compareSafe:QuantityPanel;
    private var compareForward:QuantityPanel;
    private var compareHalf:QuantityPanel;

    private var paramForward:TextField;
    private var paramHalf:TextField;
    
    private var paramSafe:TextField;


    public function SelectionChamp() { 
        super(ClassLoader.getNewInstance(Classes.SELECTION_CHAMP));
        processing = new ProcessingGame(); 
    }  

    override protected function initComponent():void{
        super.initComponent();

        var startBtnMovie:MovieClip = MovieClip(container.getChildByName("startBtn"));
        startBtn = new UIButton(startBtnMovie);
        startBtn.addHandler(onStartClick);
        startBtn.setDisabled(true);

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        enemyLogo = container.getChildByName("enemyLogo") as MovieClip;

        enemyTytle = container.getChildByName("enemyTytle") as TextField;
        enemyTeamleadName = container.getChildByName("enemyTeamleadName") as TextField;
        emenyLevel = container.getChildByName("emenyLevel") as TextField;

        compareSafe = new QuantityPanel(MovieClip(getContainer().getChildByName("compareSafe")));
        compareForward = new QuantityPanel(MovieClip(getContainer().getChildByName("compareForward")));
        compareHalf = new QuantityPanel(MovieClip(getContainer().getChildByName("compareHalf")));

        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

        invertBar(MovieClip(compareForward.getContainer()));
        invertBar(MovieClip(compareSafe.getContainer()));
        invertBar(MovieClip(compareHalf.getContainer()));

    }

    override public function destroy():void{

        super.destroy();

        closeBtn.removeHandler(onCloseClick);
        startBtn.removeHandler(onStartClick);

    }

    public function onStartClick(event:MouseEvent):void {

        if(Application.teamProfiler.getEnergy() <= 15){
            var msgBox:MessageBox = new MessageBox("Сообщение", SelectionChamp.enegryMessage
                    , MessageBox.OK_BTN); ;
            msgBox.show();
        }else{
            this.hide();
            Singletons.connection.addEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenGotResult);
            Singletons.connection.send(HTTPConnection.COMMAND_GET_MATCH_RESULT, {
                enemyTeamId: getSelectedMenuItem().getItem().socialUserId,
                score: getSelectedMenuItem().getItem().score
            });
        }
    }

    private function whenGotResult(e:Event):void{

        Singletons.sound.play(SoundController.PLAY_START);

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenGotResult);

        var result:Object = HTTPConnection.getResponse();

        if(result){
            processing.addEventListener(ResultPanel.PLEASE_SHOW, onShowResult);
            processing.showProgress(getSelectedMenuItem().getItem(), result);
        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "Соперник отказался от матча.", MessageBox.OK_BTN); ;
            msgBox.show();
            msgBox.destroyOnRemove = true;
            Application.teamProfiler.setEnergy(14);
            Application.mainMenu.userPanel.update();
        };
    }

    private function onShowResult(event:Event):void {

        processing.removeEventListener(ResultPanel.PLEASE_SHOW, onShowResult);

        var result:Object = HTTPConnection.getResponse();
 
        resultPanel = new ResultPanel(getSelectedMenuItem().getItem(), result);
        resultPanel.addEventListener(ResultPanel.REPEAT_EVENT, onPleaseRepeat);
        resultPanel.show();

    }

    private function onPleaseRepeat(event:Event):void {
        this.show();
        resultPanel.hide();
        startBtn.setDisabled(true);
        resultPanel.removeEventListener(ResultPanel.REPEAT_EVENT, onPleaseRepeat);
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var teamItem:SelectionChampItem = new SelectionChampItem(MovieClip(cell));
        teamItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return teamItem;
    }

    override public function show():void{

        // super.show();



        Singletons.connection.addEventListener(HTTPConnection.COMMAND_GET_EMENY, whenGotEmeny);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenGotEmeny);
        Singletons.connection.send(HTTPConnection.COMMAND_GET_EMENY, {});
    }

    private function whenGotEmeny(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GET_EMENY, whenGotEmeny);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenGotEmeny);

        var result:Object = HTTPConnection.getResponse();

        if(result){

            var teamCount:uint = result.teams.length;
            if(!teamCount){
                var msgBox:MessageBox = new MessageBox("Сообщение", "К сожелению сейчас не проводиться ни одного матча, " +
                                                                     "в котором вы бы могли участвовать.", MessageBox.OK_BTN); ;
                msgBox.destroyOnRemove = true;
                msgBox.show();
                return;
            }

            setData(result.teams);
            super.show();
            getSelectedMenuItem().dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));

            enemyTytle.text = Application.teamProfiler.getTeamName();
            emenyLevel.text = Application.teamProfiler.getLevel().toString();

            compareSafe.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
            compareForward.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
            compareHalf.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);

            paramForward.text = Application.teamProfiler.getParamForward().toString();
            paramHalf.text = Application.teamProfiler.getParamHalf().toString();
            paramSafe.text = Application.teamProfiler.getParamSafe().toString();

            MessageUtils.optimizeParameterSize(paramForward, 28, 26, 20);
            MessageUtils.optimizeParameterSize(paramHalf, 28, 26, 20);
            MessageUtils.optimizeParameterSize(paramSafe, 28, 26, 20);

            compareSafe.setValue(Application.teamProfiler.getParamSafe());
            compareForward.setValue(Application.teamProfiler.getParamForward());
            compareHalf.setValue(Application.teamProfiler.getParamHalf());

            new Gallery(enemyLogo, Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());

        }
    }


    /**
     * Действие при шелчке по элементу магазина
     * @param e
     */
    private function onItemClick(e:Event):void {

        var item:UIMenuItem = UIMenuItem(e.target);
        var enemyTeam:Object = Object(item.getItem());

        if(enemyTeam != null){
            startBtn.setDisabled(false);
        }
    }

    /**
     * Если хотим чтобы в магазине не отображались пустые клеточки
     * @param cell
     * @param item
     */
    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }

    private function invertBar(bar:MovieClip):void{
        bar.x += bar.width;
        bar.y += bar.height;
        bar.rotation = 180;
    }

}
}