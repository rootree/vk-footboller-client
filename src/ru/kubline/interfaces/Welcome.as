package ru.kubline.interfaces {
import com.adobe.serialization.json.JSONDecoder;

import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.events.ErrorEvent;
import flash.events.Event;

import flash.events.MouseEvent;
import flash.text.TextField;

import flash.utils.getTimer;

import mx.controls.Text;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.LoginController;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.WelcomeEvent;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.menu.TeamLogoList;
import ru.kubline.interfaces.menu.friends.welcome.FriendsListOnWelcome;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;

public class Welcome extends UIWindow {

    private var log:Logger = new Logger(Welcome);

    private var stepI:UIComponent;
    private var stepII:UIComponent;

    private var continueBtn:UIButton;
    private var finishBtn:UIButton;

    private var stepIPanel:MovieClip;
    private var stepIIPanel:MovieClip;

    private var currentStep:uint;

    public var stepIIController:TeamLogoList;

    public function Welcome() {

        super(ClassLoader.getNewInstance(Classes.WELCOME_SCREEN));

        currentStep = 1;

        stepI = new UIComponent(MovieClip(getChildByName("stepIBtn")));
        stepII = new UIComponent(MovieClip(getChildByName("stepIIBtn")));
 
        stepIPanel = container.getChildByName("stepI") as MovieClip;
        stepIIPanel = container.getChildByName("stepII") as MovieClip;
 
        stepIIController = new TeamLogoList(stepIIPanel);


        var continueButton:MovieClip = MovieClip(getChildByName("continueBtn"));
        continueBtn = new UIButton(continueButton);
        continueBtn.addHandler(onContinueClick);

        finishBtn = new UIButton(MovieClip(getChildByName("finishBtn")));
        finishBtn.addHandler(onFinishClick);
    }

    override protected function initComponent():void{
        super.initComponent();


    }

    override public function destroy():void{
        super.destroy();
        finishBtn.removeHandler(onFinishClick);
        continueBtn.removeHandler(onContinueClick);

        stepIIController.removeEventListener(WelcomeEvent.ABLE_TO_PROCEED, ableToProcced);
        stepIIController.removeEventListener(WelcomeEvent.UNABLE_TO_PROCEED, disableToProcced);
    }


    private function onContinueClick(e:Event):void{
        currentStep ++;
        activateStep(currentStep);
    }

    private function activateStep(step:uint):void{

        stepI.setVisible(false);
        stepII.setVisible(false);

        continueBtn.getContainer().visible = false;
        finishBtn.getContainer().visible = false;

        stepIPanel.visible = false;
        stepIIPanel.visible = false;

        switch(step){
            case 1:
                stepI.setVisible(true);
                stepIPanel.visible = true;
                continueBtn.getContainer().visible = true;
                break;

            case 2:

                stepII.setVisible(true);

                var ar:Array = ItemTypeStore.getStoreByType(ItemTypeStore.TYPE_LOGO_TEAM);

                stepIIController.setData(ar);
                stepIIController.setPage(1);

                stepIIController.addEventListener(WelcomeEvent.ABLE_TO_PROCEED, ableToProcced);
                stepIIController.addEventListener(WelcomeEvent.UNABLE_TO_PROCEED, disableToProcced);

                stepIIPanel.visible = true;

                finishBtn.setDisabled(true);
                finishBtn.getContainer().visible = true;

                break;
        }
    }

    private function onFinishClick(e:Event):void{

        var firstResponce:Object = new JSONDecoder( Singletons.context.getFlashVars().api_result ).getValue();
        var userInfo:Object = firstResponce.response[0];
        var userName:String = userInfo.first_name + " " + userInfo.last_name;

        Singletons.connection.addEventListener(HTTPConnection.COMMAND_WELCOME, onWelcome);

        var photo:String;
        if(Application.teamProfiler.getSocialData() && Application.teamProfiler.getSocialData().getPhotoBig()){
            photo = Application.teamProfiler.getSocialData().getPhotoBig();
        } else {
            if(Application.teamProfiler.getSocialData() && Application.teamProfiler.getSocialData().getPhoto()){
                photo = Application.teamProfiler.getSocialData().getPhoto();
            } else {
                photo = '';
            }
        }

        var country:uint;
        if(Application.teamProfiler.getSocialData() && Application.teamProfiler.getSocialData().getCountry()){
            country = Application.teamProfiler.getSocialData().getCountry();
        }else{
            country = 1;
        }

        var userYear:uint;
        if(Application.teamProfiler.getSocialData() && Application.teamProfiler.getSocialData().getBirthday()){
            userYear = Application.teamProfiler.getSocialData().getBirthday().getFullYear();
        } else {
            userYear = 0;
        }
 
        var dataForSent:Object = {
            userName      : userName,
            userPhoto     : photo,
            userYear      : userYear,
            userCountry   : country,
            teamInfo      : Application.teamProfiler.getJSON()
        };

        Singletons.connection.send(HTTPConnection.COMMAND_WELCOME, dataForSent );
    }

    private function onWelcome(event:Event):void{

        hide();

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_WELCOME, onWelcome);
        var result:Object = HTTPConnection.getResponse();
        if(result){

            Application.teamProfiler.initFromServer(result.teamProfiler);
 
            TeamProfiler.setIsInstalled(1);

            //создаем главное меню игры
            Application.mainMenu = new MainMenu();

            Application.instance.addChild(Application.mainMenu.getContainer());
            Application.mainMenu.getContainer().y = 60;

        }else{
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));
        };
    }

    private function ableToProcced(e:Event):void{
        finishBtn.setDisabled(false);
    }

    private function disableToProcced(e:Event):void{
        finishBtn.setDisabled(true);
    }

    override public function show():void{
        Application.isFristLauch = true;
        activateStep(currentStep);
        super.show();
    }
}
}