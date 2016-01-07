package ru.kubline.interfaces {
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.events.Event;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.EventController;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.controllers.WallController;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.battle.fight.FightProcess;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.FootballEvent;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:48:49 PM
 */

public class ResultPanel extends UIWindow {

    public static const REPEAT_EVENT:String = "pleaseRepeat"   ;
    public static const PLEASE_SHOW:String = "show_me_the_way"   ;
    public static const CONTINUE_FIGHT:String = "continueFight"   ;

    private var closeBtn:UISimpleButton;
    private var repeatBtn:UISimpleButton;
    private var detailsBtn:UISimpleButton;
    private var bragBtn:UIButton;
    private var continueBtn:UISimpleButton;

    private var photoResult:MovieClip;
    private var detailsPanel:MovieClip;

    private var enemyTeamLogo:MovieClip;
    private var userTeamLogo:MovieClip;

    private var countResult:TextField;
    private var bestFootballerLabel:TextField;
    private var bestLabel:TextField;

    private var enemyrTeamTitle:TextField;
    private var userTeamTitle:TextField;

    private var gotEx:TextField;
    private var gotMoney:TextField;
    private var addonBalls:TextField;
    private var spendEnergy:TextField;

    private var enemyTeam:Object;
    private var matchResult:Object;

    private var bestFootballer:Footballer;

    private var fightMode:Boolean;

    public function ResultPanel(enemyTeam:Object, matchResult:Object, fightMode:Boolean = false) {

        this.enemyTeam = enemyTeam;
        this.matchResult = matchResult;
        this.fightMode = fightMode;

        super(ClassLoader.getNewInstance(Classes.RESULT_PANEL));

    }

    override protected function initComponent():void{
        super.initComponent();

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        repeatBtn = new UISimpleButton(SimpleButton(getChildByName("repeatBtn")));
        repeatBtn.addHandler(onRepeatClick);

        detailsBtn = new UISimpleButton(SimpleButton(getChildByName("detailsBtn")));
        detailsBtn.addHandler(onDetailsClick);

        bragBtn = new UIButton(MovieClip(getChildByName("bragBtn")));
        bragBtn.addHandler(onBragClick);

        continueBtn = new UISimpleButton(SimpleButton(getChildByName("continueBtn")));
        continueBtn.addHandler(onContinueClick);

        photoResult = container.getChildByName("photoResult") as MovieClip;
        detailsPanel = container.getChildByName("detailsPanel") as MovieClip;

        detailsPanel.visible = false;

        enemyTeamLogo = container.getChildByName("enemyTeamLogo") as MovieClip ;
        userTeamLogo = container.getChildByName("userTeamLogo") as MovieClip;

        countResult = container.getChildByName("countResult") as TextField;
        bestFootballerLabel = container.getChildByName("bestFootballer") as TextField;
        bestLabel = container.getChildByName("bestLabel") as TextField;

        enemyrTeamTitle = container.getChildByName("enemyrTeamTitle") as TextField;
        userTeamTitle = container.getChildByName("userTeamTitle") as TextField;
        addonBalls = container.getChildByName("addonBalls") as TextField;
        spendEnergy = container.getChildByName("spendEnergy") as TextField;

        gotEx = container.getChildByName("gotEx") as TextField;
        gotMoney = container.getChildByName("gotMoney") as TextField;


        continueBtn.setVisible(fightMode);
        closeBtn.setVisible(!fightMode);
        repeatBtn.setVisible(!fightMode);


    }

    override public function destroy():void{

        super.destroy();
        closeBtn.removeHandler(onCloseClick);
        repeatBtn.removeHandler(onRepeatClick);
        detailsBtn.removeHandler(onDetailsClick);
        bragBtn.removeHandler(onBragClick);
        continueBtn.removeHandler(onContinueClick);

    }

    private function onContinueClick(e:Event):void{
        dispatchEvent(new Event(ResultPanel.CONTINUE_FIGHT, true));
    }

    private function onRepeatClick(e:Event):void{
        if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length == Footballer.MAX_TEAM){
            dispatchEvent(new Event(ResultPanel.REPEAT_EVENT, true));
        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "Для участия в соревнованиях необходимо набраться основной состав", MessageBox.OK_BTN); ;
            msgBox.show();
        }
    }

    private function onBragClick(e:Event):void{

        var uploadImage:BitmapData;
        if(bestFootballer.getIsFriend()){
            uploadImage = Gallery.getFromStore(Gallery.TYPE_OUTSOURCE, bestFootballer.getPhoto());
        }else{
            uploadImage = Gallery.getFromStore(Gallery.TYPE_BEST, bestFootballer.getId().toString());
        }

        var footballerName:String = bestFootballer.getFootballerName();
        new WallController(uploadImage, Application.teamProfiler.getSocialUserId(),
                "В напряженном матче с ФК «" + enemyTeam.teamName + "» , я " + MessageUtils.wordBySex(Application.teamProfiler, "одержал", "одержала") +
                " триумфальную победу! Лучшим игроком матча стал " + footballerName + ".",
                "Расскажите всему миру о вашей победе!")
                .start();
    }

    private function onDetailsClick(e:Event):void{

        photoResult.visible = detailsPanel.visible;
        detailsPanel.visible = !detailsPanel.visible;

    }

    private function setDetails(firstTeam:uint, secondTeam:uint):void{

        var Strike:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamStrike", "enemyParamStrike");
        var Gate:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamGate", "enemyParamGate");
        var Sword:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamSword", "enemyParamSword");
        var Violations:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamViolations", "enemyParamViolations");
        var Cards:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamCards", "enemyParamCards");
        var Angular:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamAngular", "enemyParamAngular");
        var Offsayd:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamOffsayd", "enemyParamOffsayd");
        var Accuracy:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamAccuracy", "enemyParamAccuracy");
        var Possession:ResultSingleStatic = new ResultSingleStatic(detailsPanel, "userParamPossession", "enemyParamPossession");

        var we:uint = Math.round(Math.random() * 5) + firstTeam;
        var target:uint = Math.round(Math.random() * 3) + secondTeam;

        // Ударов по воротам
        Gate.setValues(we, target);

        // Всего ударов
        Strike.setValues(Math.round(Math.random() * 20) + we, Math.round(Math.random() * 15) + target);

        // Отборы меча
        Sword.setValues(Math.round(Math.random() * 30), Math.round(Math.random() * 25));

        // Нарушения
        Violations.setValues(Math.round(Math.random() * 2), Math.round(Math.random() * 5));

        // Карточки
        Cards.setValues(Math.round(Math.random()), Math.round(Math.random() * 3));

        // Угловые
        Angular.setValues(Math.round(Math.random() * 10), Math.round(Math.random() * 10));

        // Офсайды
        Offsayd.setValues(Math.round(Math.random() * 3), Math.round(Math.random() * 5));

        // Точночть пассов (%)
        Accuracy.setValues((Math.round(Math.random() * 50) + 35), (Math.round(Math.random() * 40) + 30));

        // Владение мечем (%
        var possession:uint = Math.round(Math.random() * 25);
        Possession.setValues((possession + 35), (100 - possession - 35));

    }

    override public function show():void{

        super.show();


        continueBtn.setVisible(fightMode);
        closeBtn.setVisible(!fightMode);
        repeatBtn.setVisible(!fightMode);

        if(enemyTeam is TeamProfiler){
            enemyrTeamTitle.text = enemyTeam.getTeamName();
            new Gallery(enemyTeamLogo, Gallery.TYPE_TEAM, enemyTeam.getTeamLogoId().toString());
        }else{
            enemyrTeamTitle.text = enemyTeam.teamName;
            new Gallery(enemyTeamLogo, Gallery.TYPE_TEAM, enemyTeam.teamLogoId);
        }

        userTeamTitle.text = Application.teamProfiler.getTeamName();
        new Gallery(userTeamLogo, Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());

        var firstTeam:uint;
        var secondTeam:uint;

        gotEx.text = "вы заслужили +" + parseInt( matchResult.addonEx ) + "";
        gotMoney.text = "и заработали +" + (parseInt( matchResult.addonMoney ) + parseInt( matchResult.stadiumBonus ) )+ "";
        spendEnergy.text = "Но потратили -" + 16 + " Энергии";

 
        Application.teamProfiler.setParamForward(parseInt(matchResult.teamParameters.Forward));
        Application.teamProfiler.setParamSafe(parseInt(matchResult.teamParameters.Safe));
        Application.teamProfiler.setParamHalf(parseInt(matchResult.teamParameters.Half));

        var healthDownFootballerId:uint = parseInt(matchResult.healthDown.toString());
        if(healthDownFootballerId){

            var footballer:Footballer = Application.teamProfiler.getFootballerById(healthDownFootballerId);
            footballer.setHealthDown(1);
            footballer.setIsActive(false);

            Application.teamProfiler.setAbleToChoose(false);

            var msgHealthBox:MessageBox = new MessageBox("Плохие новости",
                    footballer.getFootballerName() +  " получил\nсерьезную травму в ходе матча,\nдо завтрa он пробудет в больнице.\n\nВам стоит пересмотреть \nосновной состав вашей команды", MessageBox.OK_BTN); ;
            msgHealthBox.show();

        }
        
        firstTeam = ProcessingGame.goals
        secondTeam = ProcessingGame.goalsEnemy;
              
        if(matchResult.score == 1){

            Application.teamProfiler.setCounterWin(Application.teamProfiler.getCounterWin() + 1);

            Singletons.sound.play(SoundController.PLAY_WIN);

            bragBtn.setDisabled(false);
 
            for (var i:uint = 0; i < ProcessingGame.action.length; i++) {
                var actionStory:FootballEvent = FootballEvent(ProcessingGame.action[i]); 
                if(actionStory.getHistoryType() == EventController.EVENT_ATTACK_SUCCESS){
                    bestFootballer = actionStory.getFootballer();
                }
            }

       /*
            var footballers:Array = Application.teamProfiler.getFootballers(Footballer.ACTIVEED);

            for each (var value:Footballer in footballers) {
                if(!bestFootballer){
                    bestFootballer = value;
                } else{
                    if(value.getLevel() > bestFootballer.getLevel()){
                        bestFootballer = value;
                    }
                }
            }

            bestFootballer = footballers[ Math.floor( Math.random() * footballers.length ) ];
            */

            if(bestFootballer.getIsFriend()){
                new Gallery(photoResult, Gallery.TYPE_OUTSOURCE, bestFootballer.getPhoto());
            }else{
                new Gallery(photoResult, Gallery.TYPE_BEST, bestFootballer.getId().toString());
            }

            bestFootballerLabel.text = bestFootballer.getFootballerName();
            bestFootballerLabel.visible = bestLabel.visible = true;

            switch (FightProcess.typeOfFight){
                case FightProcess.FIGHT_TYPE_GROUPS:     addonBalls.text = "3 балла в группе";         break;
                case FightProcess.FIGHT_TYPE_PLAY_OFF:   addonBalls.text = "Остаетесь в плей-офф";    break;
                default:                                 addonBalls.text = "3 проходных балла";        break;
            }

            Application.teamProfiler.setTourIII(Application.teamProfiler.getTourIII() + 3);

        }else{

            Singletons.sound.play(SoundController.PLAY_LOSE);

            bragBtn.setDisabled(true);

            if(matchResult.score == -1){

                Application.teamProfiler.setCounterLose(Application.teamProfiler.getCounterLose() + 1);

                new Gallery(photoResult, Gallery.TYPE_OTHER, Gallery.RESULT_LOST);

                bestFootballerLabel.text = 'Вы проиграли';
                addonBalls.text = (fightMode) ? "0 баллов в группе" : "0 проходных баллов";
                bestLabel.text = ''; //'Не расстраивайтесь';
            }else{
                new Gallery(photoResult, Gallery.TYPE_OTHER, Gallery.RESULT_TIE);

                bestFootballerLabel.text = 'Ничья';
                addonBalls.text = (fightMode) ? "1 балл в группе" : "1 проходной балл";

                Application.teamProfiler.setTourIII(Application.teamProfiler.getTourIII() + 1);
                bestLabel.text = ''; //'Победа была рядом';
            }

            if(fightMode && FightProcess.typeOfFight == FightProcess.FIGHT_TYPE_PLAY_OFF){
                 addonBalls.text = "Покидаете плей-офф";
            }

        }

        setDetails(firstTeam, secondTeam);
        countResult.text = firstTeam + " - " + secondTeam;

        Application.teamProfiler.addExperience(parseInt(matchResult.addonEx));
        Application.teamProfiler.setMoney(Application.teamProfiler.getMoney() + parseInt(matchResult.addonMoney)  + parseInt(matchResult.stadiumBonus));
        Application.teamProfiler.setEnergy(parseInt(matchResult.currentEnergy));
        Application.mainMenu.userPanel.update();

        if(matchResult.stadiumBonus){
            var msgBox:MessageBox = new MessageBox("Сообщение", "Матч проходил на вашем стадионе \nфанаты вашей команды заполнили его полностью. \n\nВы получили дополнительно " + matchResult.stadiumBonus + " $", MessageBox.OK_BTN); ;
            msgBox.show();
        }

    }

}
}