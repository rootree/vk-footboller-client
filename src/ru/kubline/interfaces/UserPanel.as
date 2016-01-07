package ru.kubline.interfaces {

import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.kubline.controllers.BankController;
import ru.kubline.controllers.EnergyTimerController;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.SelectLogoList;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.loader.tour.PrizeType;
import ru.kubline.loader.tour.TourNotifyType;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.MoneyType;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.TeamProfiler;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.settings.LevelsGrid;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.MCUtils;
import ru.kubline.utils.MessageUtils;
import ru.kubline.utils.NumberUtils;
import ru.kubline.utils.ObjectUtils;

public class UserPanel extends UIComponent {
     
    private var log:Logger = new Logger(UserPanel);

    public static const MEGA_BOLL_ALPHA:Number = 0.3;
    public static const MEGA_TXT_COLOR:Number = 0xCCCCCC;
    public static const MEGA_TXT_NORMAL:Number = 0xFFFFFF;
    /**
     * контроллер который отвечает работу банка
     */
    public static var bankController:BankController;

    public static var selectLogoMenu:SelectLogoList;

    /**
     * Игровые деньги
     */
    private var money:TextField;

    /**
     * Реальные деньги
     */
    private var realMoney:TextField;

    /**
     * Имя пользователя
     */
    private var experience:TextField;

    /**
     * Уровень игрока
     */
    private var level:TextField;

    /**
     * Темперетура города
     */
    private var teamLeadName:TextField;

    private var teamName:TextField;

    private var studyPoints:TextField;

    private var energy:TextField;
    private var tranerLabel:TextField;

    /**
     * Иконка для игровых денег
     */
    private var teamAvatar:UIComponent;

    private var trainerAvatar:UIComponent;

    private var boInBank:UISimpleButton;

    private var boInBankForReal:UISimpleButton;

    private var xpPanel:QuantityPanel;

    private var energyPanel:QuantityPanel;

    private var megaBall:UIComponent;

    private var moneyIcon:UIComponent;

    private var realMoneyIcon:UIComponent;

    private var energyHint:UIComponent;

    private var medal:MovieClip;

    private var cupSelection:MovieClip;

    /**
     * @param userPanel Менюшка пользователя
     */
    public function UserPanel(userPanel:MovieClip) {

        super(userPanel);
        xpPanel = new QuantityPanel(MovieClip(getContainer().getChildByName("expirience_panel")));
        energyPanel = new QuantityPanel(MovieClip(getContainer().getChildByName("energyPanel")));

        money = TextField(getContainer().getChildByName("money"));
        realMoney = TextField(getContainer().getChildByName("realMoney"));
        experience = TextField(getContainer().getChildByName("experience"));
        level = TextField(getContainer().getChildByName("level"));
        tranerLabel = TextField(getContainer().getChildByName("tranerLabel"));

        teamLeadName = TextField(getContainer().getChildByName("teamLeadName"));
        teamName = TextField(getContainer().getChildByName("teamName"));

        studyPoints = TextField(getContainer().getChildByName("studyPoints"));
        energy = TextField(getContainer().getChildByName("energy"));
        medal = MovieClip(getContainer().getChildByName("medal"));
        cupSelection = MovieClip(getContainer().getChildByName("cupSelection"));

        megaBall = new UIComponent(MovieClip(getContainer().getChildByName("megaBall")));

        moneyIcon = new UIComponent(MovieClip(getContainer().getChildByName("moneyIcon")));
        moneyIcon.setQtip("Игровая валюта, средство размена");

        realMoneyIcon = new UIComponent(MovieClip(getContainer().getChildByName("realMoneyIcon")));
        realMoneyIcon.setQtip("Реалы - очень сильная и могущественная валюта, дает все и сразу");

        new UIComponent(MovieClip(getContainer().getChildByName("levelHelp"))).setQtip("Панель опыта показывает сколько очков вам надо набрать для получения нового уровня");

        var currentTime:Number = Math.round(new Date().time / 1000); 
        var energyTextHint:String = "При каждом матче энергия команды уменьшается, восстановление энергии произойдет через \n";

        var delay:Object = EnergyTimerController.getEnergyEnharseTime();

        energyHint = new UIComponent(MovieClip(getContainer().getChildByName("energyHelp")));
        energyHint.getContainer().addEventListener(MouseEvent.MOUSE_OUT, function():void{

            var delay:Object = EnergyTimerController.getEnergyEnharseTime();

            var minIfNeed:String = '';;
            if(delay.min > 0){
                minIfNeed = delay.min + EndingUtils.chooseEnding(delay.min, " минут и ", " минуту и ", " минуты и ");
            }

            if(Application.teamProfiler.getEnergy() == Application.teamProfiler.getEnergyMax()){
                energyHint.setQtipValue("При каждом матче энергия команды уменьшается, восстановление энергии происходит каждые 10 минут");
            }else{
                energyHint.setQtipValue(energyTextHint +  minIfNeed + delay.sec + EndingUtils.chooseEnding(delay.sec, " секунд", " секунду", " секунды"));
            }
 
        });

        if(Application.teamProfiler.getEnergy() == Application.teamProfiler.getEnergyMax()){
            energyHint.setQtip("При каждом матче энергия команды уменьшается, восстановление энергии происходит каждые 10 минут");
        }else{
            var minIfNeed:String = delay.min + EndingUtils.chooseEnding(delay.min, " минут и ", " минуту и ", " минуты и ");
            energyHint.setQtip(energyTextHint + minIfNeed + delay.sec + EndingUtils.chooseEnding(delay.sec, " секунд", " секунду", " секунды"));
        }
 
        teamAvatar = new UIComponent(MovieClip(getContainer().getChildByName("teamAvatar")));
        teamAvatar.getContainer().addEventListener(MouseEvent.CLICK, openSelectLogoMenu);
        trainerAvatar = new UIComponent(MovieClip(getContainer().getChildByName("trainerAvatar")));
        teamAvatar.setQtip("Изменить логотип или название команды");

        MCUtils.enableMouser(MovieClip(teamAvatar.getContainer()));

        TweenMax.to(experience, 1, {glowFilter:{color:0xE8ED75, alpha:1, blurX:2, blurY:2, strength:13}});
        TweenMax.to(energy, 1, {glowFilter:{color:0x91e600, alpha:1, blurX:2, blurY:2, strength:13}});

        selectLogoMenu = new SelectLogoList();
        bankController = new BankController();

        boInBank =new UISimpleButton(SimpleButton(getContainer().getChildByName("boInBankGame")));
        boInBank.addHandler(inBank);
        boInBank.setQtip("Обратиться к инвесторам за игровой валютой");

        boInBankForReal =new UISimpleButton(SimpleButton(getContainer().getChildByName("boInBankReal")));
        boInBankForReal.addHandler(inBankForReal);
        boInBankForReal.setQtip("Обратиться к инвесторам за реалами");

        if(Application.teamProfiler.getPlaceInWorld() > 0 && Application.teamProfiler.getPlaceInWorld() < 4){
            medal.visible = true;
            MCUtils.enableMouser(medal);
            medal.gotoAndStop("place" + Application.teamProfiler.getPlaceInWorld());
            medal.addEventListener(MouseEvent.CLICK, showRating);
        }else{
            medal.visible = false;
        }

        var maxPlace:uint = 0;

        maxPlace = detectMinPlace(maxPlace, Application.teamProfiler.getTourPlaceCity());
        maxPlace = detectMinPlace(maxPlace, Application.teamProfiler.getTourPlaceCountry());
        maxPlace = detectMinPlace(maxPlace, Application.teamProfiler.getTourPlaceUniversity());
        maxPlace = detectMinPlace(maxPlace, Application.teamProfiler.getTourPlaceVK());
  
   //     if((Application.teamProfiler.getPrizeMode() == PrizeType.PRIZE_MODE_ACTIVATED || Application.teamProfiler.getPrizeMode() == PrizeType.PRIZE_MODE_USED)
        if(Application.teamProfiler.isNewTour()
                && (maxPlace > 0 && maxPlace < 4)){
            cupSelection.visible = true;
            MCUtils.enableMouser(cupSelection);
            cupSelection.gotoAndStop("place" + maxPlace);
            cupSelection.addEventListener(MouseEvent.CLICK, showCups);
        }else{
            cupSelection.visible = false;
        }
    }

    private function detectMinPlace(currentPlace:uint, comparePlace:uint):uint {
        currentPlace = (comparePlace != 0 && (comparePlace < currentPlace && currentPlace != 0) || (comparePlace > 0 && currentPlace == 0) ) ? comparePlace : currentPlace;
        return currentPlace;
    }

    private function showCups(e:Event):void {
        Application.mainMenu.cupInfo.showPreviusTour();
    }

    private function showRating(e:Event):void {
        Application.mainMenu.rating.show();
    }

    /**
     * Показать панель банка
     */
    public function inBank(e:Event):void {
        //bankPanel.show();
        bankController.showMenu(MoneyType.MONEY);
    }

    /**
     * Показать панель банка
     */
    public function openSelectLogoMenu(e:Event):void {
        selectLogoMenu.show();
    }


    public function inBankForReal(e:Event):void {
        //bankPanel.show();
        bankController.showMenu(MoneyType.REAL_MONEY);
    }

    /**
     * Обновлние данных о пользователе в менюшке
     */
    public function update():void {
        var profile:TeamProfiler = Application.teamProfiler;
        setMoney(profile.getMoney().toString());
        setRealMoney(profile.getRealMoney().toString());
        setExperience(profile.getExperience().toString());
        setLevel(profile.getLevel().toString());
        setTeamLeadName();
        setTeamName(profile.getTeamName());
        setStudyPoints(profile.getStudyPoints().toString());
        setEnergy(profile.getEnergy().toString());
        updateTeamAvatar();
        updateTrainerAvatar();
    }

    public function setMoney(value:String):void {
        money.text = NumberUtils.toNumberFormat(parseInt(value));;
    }

    public function setRealMoney(value:String):void {
        realMoney.text = NumberUtils.toNumberFormat(parseInt(value));
    }

    public function setExperience(value:String):void {
        var profile:TeamProfiler = Application.teamProfiler;
        var maxXp:int = LevelsGrid.getNextLevelXp(profile.getLevel());
        xpPanel.setMaxValue(maxXp);
        xpPanel.setValue(profile.getExperience());
        experience.text = NumberUtils.toNumberFormat(parseInt(value)) + "/" + NumberUtils.toNumberFormat(maxXp);

    }

    public function setLevel(value:String):void {
        level.text = value;
    }
 
    public function setTeamLeadName():void {
        var value:String;
        if(Application.teamProfiler.getTrainer().getId()){
            value = Application.teamProfiler.getTrainer().getName();
        }else{
            var profile:TeamProfiler = Application.teamProfiler;
            if(profile && profile.getSocialData() && profile.getSocialData().getFirstName(true)){
                value = profile.getSocialData().getFirstName(true) + ' ' + profile.getSocialData().getLastName(true);
            }else{
                value = "N/A";                    
            }
        }
        tranerLabel.visible = false; 
        teamLeadName.text = value;
    }

    public function setTeamName(value:String):void {
        teamName.text = value.toLocaleUpperCase();
    }

    public function setStudyPoints(value:String):void {
        if(value != "0"){
            megaBall.getContainer().alpha = 1;
            megaBall.setQtip("У вас " + value + EndingUtils.chooseEnding(parseInt(value), " очков", " очко", " очка")  + " обучения. Вы можете повысить характеристики своих футболистов");
            studyPoints.textColor = MEGA_TXT_NORMAL;
        }else{
            megaBall.getContainer().alpha = UserPanel.MEGA_BOLL_ALPHA;
            megaBall.setQtip("У вас нет очков обучения. Очки обучения позволяют повышать характеристики ваших футболистов");
            studyPoints.textColor = MEGA_TXT_COLOR;
        }

        studyPoints.text = value;
        MessageUtils.optimizeParameterSize(studyPoints, 30, 24, 18);
    }

    public function setEnergy(value:String):void {
        var profile:TeamProfiler = Application.teamProfiler;

        energyPanel.setMaxValue(profile.getEnergyMax());
        energyPanel.setValue(profile.getEnergy());
        energy.text = NumberUtils.toNumberFormat(parseInt(value)) + "/" + NumberUtils.toNumberFormat(profile.getEnergyMax());

    }

    public function updateTeamAvatar():void { 
        new Gallery(MovieClip(teamAvatar.getContainer()), Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());
    }

    public function updateTrainerAvatar():void {
        if(Application.teamProfiler.getTrainer().getId()){
            var teamLogo:ItemResource = ItemTypeStore.getItemResourceById(Application.teamProfiler.getTrainer().getId());
            new Gallery(MovieClip(trainerAvatar.getContainer()), Gallery.TYPE_FOOTBALLER, teamLogo.getId().toString());
            trainerAvatar.setQtip(Application.teamProfiler.getTrainer().getName() + " не подведет вашу команду. Дает дополнительно на " +
                                  Application.teamProfiler.getTrainer().getMulti() +
                                  EndingUtils.chooseEnding( Application.teamProfiler.getTrainer().getMulti(), " очков", " очко", " очка") +
                                  " обучения больше при каждом новом уровне");
        }else{
            var userAvatar:String;
            if(Application.VKIsEnabled){
                userAvatar = Application.teamProfiler.getSocialData().getPhotoBig();
            }else{
                userAvatar = "";
            }

            new Gallery(MovieClip(trainerAvatar.getContainer()), Gallery.TYPE_OUTSOURCE, userAvatar);
            trainerAvatar.setQtip("Ваша команда надеется на вас");
        }
    }
}

}