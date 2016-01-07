package ru.kubline.interfaces {
import com.greensock.TweenMax;

import com.greensock.easing.Bounce;

import com.greensock.easing.Expo;

import com.greensock.easing.Quart;
import com.greensock.easing.Quint;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;

import flash.utils.Timer;



import ru.kubline.comon.Classes;
import ru.kubline.controllers.EventController;
import ru.kubline.controllers.Singletons;
import ru.kubline.display.SimpleStadium;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.interfaces.battle.fight.FightProcess;
import ru.kubline.interfaces.events.EventItemMod;
import ru.kubline.interfaces.menu.team.UserPlayersMenu;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.FootballEvent;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ItemUtils;

/**
 * Р В Р’В Р РЋРІР‚С”Р В Р’В Р РЋРІР‚вЂќР В Р’В Р РЋРІР‚пїЅР В Р Р‹Р В РЎвЂњР В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦Р В Р’В Р РЋРІР‚пїЅР В Р’В Р вЂ™Р’Вµ
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:36:02 PM
 */

public class ProcessingGame extends UIWindow {

    private static var mask_widht:uint = 0;

    public static var firstTeam:uint, secondTeam:uint;

    private var secondStep:MovieClip;
    private var firstStep:MovieClip;
    private var progress:MovieClip;
    private var framer:MovieClip;

    private var countStepLeft:int;

    private var enemyTeam:Object;
    private var fightMode:Boolean;
    private var enemyFootballres:Object;

    private var contButton:UISimpleButton;

    private var hintable:Hintable;

    private var timer:Timer;
    public static var action:Array;
    private var currentNumberOfAction:int = 0;

    private var enemyTeamForProceed:TeamProfiler;
    public  var eventItemContainer:EventItemMod;
    public  var eventItemContainerPrev:EventItemMod;
    public  var simafor:Boolean = true;

    private var fightContainer:MovieClip;
    private var userTeamLogo:MovieClip;
    private var enemyTeamLogo:MovieClip;
    private var score:TextField;
    private var userTeamTitle:TextField;
    private var enemyrTeamTitle:TextField;
    private var timeLine:TextField;
    private var minute:uint;

    public static var goals:uint = 0;
    public static var goalsEnemy:uint = 0;


    /**
     * Р В Р’В Р РЋРІР‚пїЅР В Р’В Р В РІР‚В¦Р В Р Р‹Р В РЎвЂњР В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р вЂ™Р’В°Р В Р’В Р В РІР‚В¦Р В Р Р‹Р В РЎвЂњ Р В Р Р‹Р Р†Р вЂљР’В¦Р В Р’В Р РЋРІР‚пїЅР В Р’В Р В РІР‚В¦Р В Р Р‹Р Р†Р вЂљРЎв„ўР В Р’В Р вЂ™Р’В°
     */
    private var hint:MovieClip = null;

    public function ProcessingGame() {
        super(ClassLoader.getNewInstance(Classes.PROCESSING_GAME));
    }

    override protected function initComponent():void{
        super.initComponent();
        secondStep = container.getChildByName("secondStep") as MovieClip;
        firstStep = container.getChildByName("firstStep") as MovieClip;
        progress = container.getChildByName("progress") as MovieClip;
        fightContainer = progress.getChildByName("maskerTrue") as MovieClip;
        framer = progress.getChildByName("framer") as MovieClip;

        if(framer && progress.contains(framer)){
            progress.removeChild(framer);
        }

        contButton = new UISimpleButton(SimpleButton(getChildByName("contButton")));
        contButton.getContainer().addEventListener(MouseEvent.CLICK, onNextStep);

        userTeamTitle = (TextField(progress.getChildByName("userTeam")));
        enemyrTeamTitle = (TextField(progress.getChildByName("enemyTeam")));
        timeLine = (TextField(progress.getChildByName("timeLine")));
        score = (TextField(progress.getChildByName("score")));
        userTeamLogo = (MovieClip(progress.getChildByName("userTeamLogo")));
        enemyTeamLogo = (MovieClip(progress.getChildByName("enemyTeamLogo")));

        progress.visible = false;
    }

    override public function destroy():void{
        contButton.getContainer().removeEventListener(MouseEvent.CLICK, onNextStep);

        if(timer){

            timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
        }

        super.destroy();
    }

    private function onNextStep(e:MouseEvent):void{
        initSecondStep();
    }

    private function initSecondStep():void{

        secondStep.visible = true;
        firstStep.visible = false;

        var result:Object = HTTPConnection.getResponse();

        getMatchResult(result, fightMode);

        if(enemyTeam is TeamProfiler){
            enemyTeamForProceed = TeamProfiler(enemyTeam);
        }else{
            enemyTeamForProceed = new TeamProfiler();
            enemyTeamForProceed.initFromServer(enemyTeam);

            var footB:Object = new Object();
            var key:String;

            if(enemyFootballres){

                for (key in enemyFootballres) {
                    var keyId:uint = parseInt(key);

                    if(keyId > 0 && enemyFootballres[key] is Object){
                        footB[key] = Object(enemyFootballres[key]);
                    }
                }

                enemyTeamForProceed.initFootballers(footB);
            }
        }



        switch (countStepLeft){
            case 2:


                action = new EventController().getDetails(firstTeam, secondTeam, Application.teamProfiler, enemyTeamForProceed);
 
                for (var i:uint = 0; i < action.length; i++) {
                    var actionStory:FootballEvent = FootballEvent(action[i]);
                    new Gallery(new MovieClip(), Gallery.TYPE_BEST, actionStory.getFootballer().getId().toString());
                }

                prepateFromTP(Application.teamProfiler);
                break;

            case 1:

                if(enemyTeam is TeamProfiler){
                    prepateFromTP(TeamProfiler(enemyTeam));
                }else{


                    new Gallery(MovieClip(secondStep.getChildByName("teamLogo")), Gallery.TYPE_TEAM, enemyTeam.teamLogoId);

                    TextField(secondStep.getChildByName("teamName")).text = enemyTeam.teamName;
                    TextField(secondStep.getChildByName("teamInfo")).text = "Команда противника";

                    if(parseInt(enemyTeam.trainerId)){
                        var trainerItem:ItemResource = ItemTypeStore.getItemResourceById(enemyTeam.trainerId);
                        new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_FOOTBALLER, enemyTeam.trainerId);
                        TextField(secondStep.getChildByName("trainerName")).text = trainerItem.getName();
                    }else{
                        new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_OUTSOURCE, enemyTeam.userPhoto);
                        TextField(secondStep.getChildByName("trainerName")).text = enemyTeam.userName;
                    }

                    prepareTeamContent(new Array(this.enemyFootballres) , false);
                }

                break;

            case 0:

                progress.visible = true;

                showNextSlide();

                timer = new Timer(4500, action.length);

                timer.addEventListener(TimerEvent.TIMER, onTimer);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
                timer.start();

                secondStep.visible = false;
                firstStep.visible = false;

                //   contButton.setVisible(false);

                break;

            default:
                secondStep.visible = false;
                firstStep.visible = false;
                if(timer){
                    timer.removeEventListener(TimerEvent.TIMER, onTimer);
                    timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
                    timer.stop();
                    timer = null;
                }
                showNextSlide();
                break;
        }

        countStepLeft --;

    }

    private function showNextSlide( ):void{

        var actionStory:FootballEvent = action[currentNumberOfAction];
        currentNumberOfAction ++ ;

        if(!actionStory){
            onTimerComp(new TimerEvent(TimerEvent.TIMER_COMPLETE));
            return;
        }

        var timeShift:uint = Math.floor( 90 / action.length );
        var DSminute:uint = currentNumberOfAction * timeShift + Math.floor(Math.random() * timeShift);

        if(DSminute > minute){
            minute = DSminute;
        }

        if(minute > 90){
            minute = 90 + Math.floor(Math.random()*5);
        }

        var alphaEnemy:Number = 1;
        var alphaUser:Number = 1;
        var colorUser:Number = 0xFFFFFF;
        var colorEnemy:Number = 0xFFFFFF;


        if(!actionStory.getIsEnemy()){
            alphaEnemy = 0.7;
            colorUser = 0x99A9C4;
        }else{
            colorEnemy = 0x99A9C4;
            alphaUser = 0.7;
        }

        TweenMax.to(enemyrTeamTitle, 1, {tint:colorUser, alpha:alphaEnemy});
        TweenMax.to(userTeamTitle, 1, {tint:colorEnemy, alpha:alphaUser});

        /*
         TweenMax.to(enemyTeamLogo, 1,  {alpha:alphaEnemy});
         TweenMax.to(userTeamLogo, 1,  {alpha:alphaUser});
         */

        switch(actionStory.getHistoryType()){
            case EventController.EVENT_ATTACK_SUCCESS: goals ++; break;
            case EventController.EVENT_SOS_SUCCESS: goalsEnemy ++; break;
        }

        score.text = goals + " - " + goalsEnemy;

        timeLine.text = minute.toString() + " минута";

        enemyrTeamTitle.text = enemyTeamForProceed.getTeamName();
        new Gallery(enemyTeamLogo, Gallery.TYPE_TEAM, enemyTeamForProceed.getTeamLogoId().toString());

        userTeamTitle.text = Application.teamProfiler.getTeamName();
        new Gallery(userTeamLogo, Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());


        simafor = !simafor;

        framer = ClassLoader.getNewInstance(Classes.FIGHT_STEP);

        if(simafor){
            eventItemContainer = new EventItemMod(framer);
            eventItemContainer.initData(enemyTeamForProceed, actionStory, minute);
        }else{
            eventItemContainerPrev = new EventItemMod(framer);
            eventItemContainerPrev.initData(enemyTeamForProceed, actionStory, minute);
        }

        hideProcessing();
        showProcessing();

    }

    private function showProcessing():void{

        var event:EventItemMod = (simafor) ? eventItemContainer : eventItemContainerPrev;

        fightContainer.addChild(event.getContainer());

        event.getContainer().alpha = 0;
        event.getContainer().y = -200;

        TweenMax.to(event.getContainer(), 2, {alpha:1, y:0, ease:Expo.easeOut , onComplete   : function():void{   //  //     Expo.easeOut

        } } );

    }

    private function hideProcessing():void{

        var event:EventItemMod = (simafor) ? eventItemContainerPrev : eventItemContainer;
        if(event && fightContainer.contains(event.getContainer())){

            event.getContainer().alpha = 1;
            TweenMax.to(event.getContainer(), 1, {alpha:0.5, y:700, ease:Bounce.easeOut, onComplete   : function():void{

                if(fightContainer && fightContainer.contains(event.getContainer())){

                    fightContainer.removeChild(event.getContainer());
                }

            } } );
        }
    }

    private function onTimer(e:TimerEvent):void{
        showNextSlide();
    }

    private function onTimerComp(e:TimerEvent):void{

        if(eventItemContainer && progress.contains(eventItemContainer.getContainer())){
            fightContainer.removeChild(eventItemContainer.getContainer());
        }
        if(eventItemContainerPrev && progress.contains(eventItemContainerPrev.getContainer())){
            fightContainer.removeChild(eventItemContainerPrev.getContainer());
        }

        if(timer){
            timer.stop();
            timer = null;
        }

        hide();
        destroy();
        dispatchEvent(new Event(ResultPanel.PLEASE_SHOW, true));
    }

    private function prepateFromTP(teamProfiler:TeamProfiler):void{

        new Gallery(MovieClip(secondStep.getChildByName("teamLogo")), Gallery.TYPE_TEAM, teamProfiler.getTeamLogoId().toString());
        new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_TEAM, teamProfiler.getTeamLogoId().toString());

        TextField(secondStep.getChildByName("teamInfo")).text = "Ваша команда";
        TextField(secondStep.getChildByName("teamName")).text = teamProfiler.getTeamName();

        if(teamProfiler.getTrainer().getId()){
            TextField(secondStep.getChildByName("trainerName")).text = teamProfiler.getTrainer().getName();
        }else{
            if(teamProfiler.getSocialData() && teamProfiler.getSocialData().getServerName()){
                TextField(secondStep.getChildByName("trainerName")).text = teamProfiler.getSocialData().getServerName();
            }else{
                TextField(secondStep.getChildByName("trainerName")).text = teamProfiler.getUserName();
            }
        }

        if(teamProfiler.getTrainer().getId()){
            new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_FOOTBALLER, teamProfiler.getTrainer().getId().toString());
        }else{
            if(Application.VKIsEnabled){

                var trenerPhoto:String;
                if(teamProfiler.getSocialData() && teamProfiler.getSocialData().getPhotoBig()){
                    trenerPhoto = teamProfiler.getSocialData().getPhotoBig();
                }else{
                    trenerPhoto = teamProfiler.getUserPhoto();
                }

                new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_OUTSOURCE, trenerPhoto);
            }else{
                new Gallery(MovieClip(secondStep.getChildByName("trainerImg")), Gallery.TYPE_OUTSOURCE, "3000");
            }
        }

        prepareTeamContent(teamProfiler.getFootballers(Footballer.ACTIVEED), true);
    }

    private function prepareTeamContent(footballers:Array, isUserTeam:Boolean):void{

        var teamContainer:MovieClip = MovieClip(secondStep.getChildByName("teamContent"));
        if(isUserTeam){
            UserPlayersMenu.sort(footballers);
        }

        for (var i:int = 0; i < teamContainer.numChildren; i++) {

            teamContainer.getChildAt(i).visible = true;
            if((isUserTeam && !footballers[i]) || (!isUserTeam && !footballers[0][i])){
                teamContainer.getChildAt(i).visible = false;
                continue;
            }
            var foot:Footballer;
            if(teamContainer.getChildAt(i) is MovieClip){
                var footballersItem:FootballerProgressItem = new FootballerProgressItem(MovieClip(teamContainer.getChildAt(i)));
                if(isUserTeam){
                    footballersItem.init(Footballer(footballers[i]));
                }else{

                    if(footballers[0][i].isFriend){

                        foot = new Footballer(
                                footballers[0][i].footballerName,
                                footballers[0][i].level,
                                footballers[0][i].type,
                                footballers[0][i].id,
                                footballers[0][i].isFriend,
                                footballers[0][i].isActive,
                                footballers[0][i].photoForFriend,
                                footballers[0][i].price,
                                0,0,
                                footballers[0][i].favorite
                                );

                        footballersItem.init(foot);
                    } else {

                        var footballerInstance:ItemResource = ItemTypeStore.getItemResourceById(parseInt(footballers[0][i].id));

                        foot = new Footballer(
                                footballerInstance.getName(),
                                footballers[0][i].level,
                                ItemUtils.converStringTypeToInt(footballerInstance.getShopType()),
                                footballers[0][i].id,
                                false,
                                footballers[0][i].isActive,
                                footballers[0][i].photoForFriend,
                                footballers[0][i].price,
                                0,0,
                                footballers[0][i].favorite
                                );

                        footballersItem.init(foot);

                    }
                }
            }
        }
    }

    public function showProgress(enemyTeam:Object, footballres:Object, fightMode:Boolean = false, isFriend:Boolean = false):void{

        goals = 0;
        goalsEnemy = 0;
        currentNumberOfAction = 0;
        minute = 0;

        if(score){
            score.text = goals + " - " + goalsEnemy;
        }

        if(isFriend){

            var isAvalibaleToFight:Boolean = Singletons.limitForFight.isAvailableBurn(TeamProfiler(enemyTeam).getSocialUserId());
            if(!isAvalibaleToFight){
                new MessageBox("Лимит", "К сожалению, лимит исчерпан.", MessageBox.OK_BTN).show();
                return;
            }
            Singletons.limitForFight.decreaseCountOfBurns(TeamProfiler(enemyTeam).getSocialUserId());
        }

        super.show();
        this.fightMode = fightMode;
        this.enemyTeam = enemyTeam;
        this.enemyFootballres = footballres;
        countStepLeft = 2;
        firstStep.visible = true;
        secondStep.visible = false;
        initFirstStep();

    }

    private function initFirstStep():void{

        var stadium:ItemResource = getStatium();

        TextField(firstStep.getChildByName("stadiumCity")).text = stadium.getParams().city;
        TextField(firstStep.getChildByName("stadiumTytle")).text = stadium.getParams().tytle;

        var currentWeather:uint = Math.floor(Math.random() * MovieClip(firstStep.getChildByName("stadiumWeather")).totalFrames);
        MovieClip(firstStep.getChildByName("stadiumWeather")).gotoAndStop(currentWeather);

        new Gallery(MovieClip(firstStep.getChildByName("photoOfStadium")), Gallery.TYPE_STADIUM, stadium.getId().toString(), true);

        contButton.setVisible(true);
    }

    private function getMatchResult(matchResult:Object, fightMode:Boolean):void{

        if(fightMode){

            var stepObject:Object = new Object();
            if(FightProcess.typeOfFight == FightProcess.FIGHT_TYPE_PLAY_OFF){
                stepObject = Application.mainMenu.championnats.getTourIIIStarted().tourResult.getCurrentPlayOffFight().step;
            }else{
                stepObject = Application.mainMenu.championnats.getTourIIIStarted().tourResult.getCurrentGroupsFight().step;
            }

            firstTeam = parseInt(stepObject.goals);
            secondTeam = parseInt(stepObject.goals_enemy);

        }else{

            switch (matchResult.score){
                case 1:
                case -1:
                    firstTeam = Math.round(Math.random() * 5);
                    secondTeam = Math.floor(Math.random() * firstTeam);

                    if(firstTeam == secondTeam){
                        firstTeam++;
                    }
                    if(matchResult.score == -1){
                        var temp:uint = firstTeam;

                        firstTeam = secondTeam;
                        secondTeam = temp;
                    }

                    break;

                case 0:
                    secondTeam = firstTeam = Math.round(Math.random() * 5);
                    break;
            }
        }

    }

    private function getStatium():ItemResource{

        var matchResult:Object = HTTPConnection.getResponse();
        if(matchResult.stadiumBonus){
            return ItemTypeStore.getItemResourceById(Application.teamProfiler.getStadium().getId());
        }

        var store:Object = ItemTypeStore.getStore();
        var ar:Array = [];
        for each(var item:ItemResource in store) {
            if (ItemTypeStore.TYPE_STADIUM == item.getShopType() && Application.teamProfiler.getLevel() >= item.getRequiredLevel()) {
                ar.push(item);
            }
        }

        return ar[Math.floor(Math.random() * ar.length)];
    }

    public function getAction():Array {
        return action;
    }
}
}