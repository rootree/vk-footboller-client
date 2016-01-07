package ru.kubline.interfaces {

import flash.display.BitmapData;
import flash.display.MovieClip; 
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.WallController;
import ru.kubline.crypto.MD5v2;
import ru.kubline.events.GallaryEvent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.menu.team.UserPlayersMenu;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.Footballer;
import ru.kubline.model.Sponsor;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.MessageUtils;

public class FriendTeam extends UIWindow{

    private var acitePlayersPanel:UserPlayersMenu ;

    private var inTeamBtn:UIButton;
    private var prizeBtn:UIButton;
    private var fightBtn:UIButton;

    private var availableStady:TextField;
    private var friendHint:TextField;

    private var teamLevel:TextField;
    private var teamLeadName:TextField;
    private var teamName:TextField;
    private var freandName:TextField;

    private var stadyPoint:uint;

    private var paramForward:TextField;
    private var paramHalf:TextField;
    private var paramSafe:TextField;

    private var megaBall:MovieClip;

    private var friendTeam:TeamProfiler;
    private var closeBtn:UISimpleButton;

    private var img:Gallery;;

    private var processing:ProcessingGame;
    private var resultPanel:ResultPanel;

    public function FriendTeam() {

        super(ClassLoader.getNewInstance(Classes.PANEL_FRIEND_TEAM));
        processing = new ProcessingGame();

    }

    override protected function initComponent():void{
        super.initComponent();

        megaBall = MovieClip(container.getChildByName("megaBall"));
        ;
        acitePlayersPanel = new UserPlayersMenu(MovieClip(getChildByName("friendTeamList")));
        acitePlayersPanel.hideNavigation(true);

        prizeBtn = new UIButton(MovieClip(getChildByName("prizeBtn")));
        prizeBtn.addHandler(onPrizeSend);

        inTeamBtn = new UIButton(MovieClip(getChildByName("inTeamBtn")));
        inTeamBtn.addHandler(inTeamPlease);

        fightBtn = new UIButton(MovieClip(getChildByName("fightBtn")));
        fightBtn.addHandler(getFreindMatchResult);

        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

        availableStady = TextField(getContainer().getChildByName("availableStady"));
        friendHint = TextField(getContainer().getChildByName("friendHint"));

        teamLevel = TextField(getContainer().getChildByName("teamLevel"));
        teamLeadName = TextField(getContainer().getChildByName("teamLeadName"));
        teamName = TextField(getContainer().getChildByName("teamName"));
        freandName = TextField(getContainer().getChildByName("freandName"));

    }

    override public function destroy():void{
        fightBtn.removeHandler(getFreindMatchResult);
        inTeamBtn.removeHandler(inTeamPlease);
        prizeBtn.removeHandler(onPrizeSend);

        // resultPanel.removeEventListener(ResultPanel.REPEAT_EVENT, getFreindMatchResult);
        
        super.destroy();
    }

    public function initTeam(team:TeamProfiler):void{
 
        friendTeam = team;

        var isAvalibalePrize:Boolean = Singletons.limitForPrize.isAvailableBurn(friendTeam.getSocialUserId());
        var isAvalibaleToFight:Boolean = Singletons.limitForFight.isAvailableBurn(friendTeam.getSocialUserId());

        fightBtn.setDisabled(!isAvalibaleToFight);

        prizeBtn.setDisabled(!isAvalibalePrize);
        prizeBtn.setQtip((isAvalibalePrize ?
                          "Сделать для " + friendTeam.getSocialData().getFirstName() + " подарок" :
                          "Вы уже подарили ежедневный подарок"));

        acitePlayersPanel.redrawContainer(Footballer.ACTIVEED, friendTeam);
        acitePlayersPanel.setPage(1);

        if(!friendTeam.getIsAbleToChoose()){
            if(Application.teamProfiler.getFootballerById(friendTeam.getSocialUserId())){
                friendHint.text = (UserProfileHelper.getNameTextByProfile(friendTeam)  +
                                   " в вашем клубе");
            }else{
                friendHint.text = ("Команда вашего друга");
            }
            inTeamBtn.setDisabled(true);
        }else{
            friendHint.text = ("" + UserProfileHelper.getNameTextByProfile(friendTeam) + MessageUtils.wordBySex(friendTeam , ' свободен', ' свободна'));
            inTeamBtn.setDisabled(false);
        }

        paramForward.text = friendTeam.getParamForward().toString();
        paramHalf.text = friendTeam.getParamHalf().toString();
        paramSafe.text = friendTeam.getParamSafe().toString();

       MessageUtils.optimizeParameterSize(paramForward, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramHalf, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramSafe, 28, 26, 20);

        teamLevel.text = friendTeam.getLevel().toString() + "-й уровень";
        teamName.text = friendTeam.getTeamName();
        freandName.text = "Команда " + UserProfileHelper.getNameTextByProfile(friendTeam, true) ;

        updateStadyPoint();

        if(friendTeam.getTrainer().getId()){
            teamLeadName.text = friendTeam.getTrainer().getName();
        }else{
            teamLeadName.text = UserProfileHelper.getNameTextByProfile(friendTeam);
        }

        if(friendTeam.getTrainer().getId()){
            new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_FOOTBALLER, friendTeam.getTrainer().getId().toString());
        }else{
            if(Application.VKIsEnabled){
                new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_OUTSOURCE,
                        friendTeam.getSocialData().getPhotoBig());
            }else{
                new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_OUTSOURCE, "3000");
            }
        }

        new Gallery(MovieClip(getChildByName("teamLogo")), Gallery.TYPE_TEAM, friendTeam.getTeamLogoId().toString());

        var sponsor:MovieClip;

        var friendSponsor:Object = friendTeam.getSponsors();

        var sponsorCount:uint = 1;
        var sponsorId:uint;


        for each (var value:Sponsor in friendSponsor) {
            sponsor = MovieClip(getChildByName("sponsor" + sponsorCount));
            sponsorId = value.getId();
            new Gallery(MovieClip(sponsor.getChildByName("container")), Gallery.TYPE_SPONSOR, sponsorId.toString());
            sponsorCount++;
            sponsor.visible = true;
        }

        for(; sponsorCount < 4; sponsorCount ++){
            sponsor = MovieClip(getChildByName("sponsor" + sponsorCount));
            MovieClip(MovieClip(sponsor.getChildByName("container")).getChildByName("loading")).stop();
            if(sponsor){
                sponsor.visible = false;
            }
        }


    }

    private function updateStadyPoint():void {

        var ST:uint = friendTeam.getStudyPoints();      //////////////////////////////////////
        if(ST){
            megaBall.alpha = 1;
            availableStady.text  = ST + " очков";
            availableStady.textColor  = UserPanel.MEGA_TXT_NORMAL;
        }else{
            megaBall.alpha = UserPanel.MEGA_BOLL_ALPHA;
            availableStady.text = "Очков нет";
            availableStady.textColor  = UserPanel.MEGA_TXT_COLOR;
        }
    }

    override public function show():void{
        super.show();
    }

    override public function hide():void{
        super.hide();
    }

    private function onPrizeSend(event:MouseEvent):void {
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_SEND_GIFT, whenPrizeSend);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenPrizeSend);
        Singletons.connection.send(HTTPConnection.COMMAND_SEND_GIFT, {friendId: friendTeam.getSocialUserId()});
    }

    private function whenPrizeSend(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_SEND_GIFT, whenPrizeSend);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenPrizeSend);

        var result:Object = HTTPConnection.getResponse();
        if(result && result.isOk){

            img = new Gallery(new MovieClip(), Gallery.TYPE_OTHER, Gallery.RESULT_APP);
            img.addEventListener(GallaryEvent.EVENT_IMAGE_LOADED, onImageForPostLoaded);
 
            prizeBtn.setDisabled(true);
            Singletons.limitForPrize.decreaseCountOfBurns(friendTeam.getSocialUserId()); 
        }
    }


    private function onImageForPostLoaded(e:GallaryEvent):void{

        img.removeEventListener(GallaryEvent.EVENT_IMAGE_LOADED, onImageForPostLoaded);
 
        var preMessage:String =
                "Для " + friendTeam.getSocialData().getFirstName() + " отправлен ежедневный подарок, дополнительные очки обучения!\n\n" +
                "Расскажите " + MessageUtils.wordBySex(friendTeam , 'ему', 'ей') + " об этом! \n" +
                MessageUtils.wordBySex(friendTeam , 'Ему', 'Ей') + " будет очень приятно."        ;

        var uploadImage:BitmapData;
        uploadImage = Gallery.getFromStore(Gallery.TYPE_OTHER, Gallery.RESULT_APP);

        new WallController(uploadImage, friendTeam.getSocialUserId(),
                "Привет, я " + MessageUtils.wordBySex(Application.teamProfiler, "подарил", "подарила") +
                " тебе подарок. Зайди в приложение, чтобы получить его.",
                preMessage).start();
    }


    private function inTeamPlease(event:MouseEvent):void {
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_FRIEND_IN_TEAM, whenSafed);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenSafed);
        Singletons.connection.send(HTTPConnection.COMMAND_FRIEND_IN_TEAM, {friendId: friendTeam.getSocialUserId()}); 
    }

    public function getFreindMatchResult(event:Event):void {
        if(resultPanel){
            resultPanel.hide();
        }

        var msgBox:MessageBox

        if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length != Footballer.MAX_TEAM){
             msgBox = new MessageBox("Сообщение", "Для участия в соревнованиях необходимо набраться основной состав", MessageBox.OK_BTN); ;
            msgBox.show();
            return;
        }
 
        if(Application.teamProfiler.getEnergy() <= 15){
            msgBox = new MessageBox("Сообщение", SelectionChamp.enegryMessage
                    , MessageBox.OK_BTN); ;
            msgBox.show();
        }else{
            this.hide();
            Singletons.connection.addEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenGotResult);

            var score:int = 0;
            if(friendTeam.getParamSum() <= (Application.teamProfiler.getParamSum() + 20)){
                score = 1;   
            }else{

                if(friendTeam.getParamSum() > Math.ceil(Application.teamProfiler.getParamSum() * 1.25)){
                    score = -1;
                }else{
                    score = Math.ceil(Math.random() * 2) - 2;
                }
            }
            var scoreST:String =  MD5v2.encrypt ( score.toString() + friendTeam.getSocialUserId().toString()  + "FUZ" );
            Singletons.connection.send(HTTPConnection.COMMAND_GET_MATCH_RESULT, {enemyTeamId: friendTeam.getSocialUserId(), score: scoreST});
        }
    }

    private function whenGotResult(e:Event):void {
 
        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GET_MATCH_RESULT, whenGotResult);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenGotResult);

        var result:Object = HTTPConnection.getResponse();

        if(result){
            if(!processing){
                processing = new ProcessingGame();
            }
          
            processing.addEventListener(ResultPanel.PLEASE_SHOW, onShowResult);
            processing.showProgress(friendTeam, friendTeam.getFootballers(Footballer.ACTIVEED), false, true);
            hide();
        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "Соперник отказался от матча.", MessageBox.OK_BTN); ;
            msgBox.show();
            msgBox.destroyOnRemove = true;
        }; 
    }

    private function onShowResult(event:Event):void {
        processing.removeEventListener(ResultPanel.PLEASE_SHOW, onShowResult);
        var result:Object = HTTPConnection.getResponse();
        
        resultPanel = new ResultPanel(friendTeam, result);
        resultPanel.addEventListener(ResultPanel.REPEAT_EVENT, getFreindMatchResult);
        resultPanel.show(); 
    }

    private function whenSafed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_FRIEND_IN_TEAM, whenSafed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenSafed);

        var result:Object = HTTPConnection.getResponse();
        if(result){

            Application.teamProfiler.setStudyPoints(parseInt(result.totalStadyPoints));

            if(result.footballer){
                var prototypeId:uint = parseInt(result.footballer.id);
                var footballer:Footballer = new Footballer(
                        UserProfileHelper.getNameTextByProfile(friendTeam),
                        parseInt(result.footballer.level),
                        String(result.footballer.type),
                        prototypeId,
                        true,
                        Boolean(parseInt(result.footballer.isActive)),
                        friendTeam.getSocialData().getPhotoBig(),
                        parseInt(result.footballer.price),
                        friendTeam.getSocialData().getCountry(),
                        friendTeam.getSocialData().getBirthday().getFullYear()
                        );
                Application.teamProfiler.addFootballer(footballer);
            }

            Application.mainMenu.userPanel.setStudyPoints(Application.teamProfiler.getStudyPoints().toString());

            var msgBox:MessageBox = new MessageBox("Великолепно!",
                    UserProfileHelper.getNameTextByProfile(friendTeam) + " теперь \nиграет за вашу команду! \nНо " +

                    MessageUtils.wordBySex(friendTeam , 'он', 'она') + " еще не знает об этом, поделиться с " + MessageUtils.wordBySex(friendTeam , 'ним', 'ней') + " приятной новостью?" +

                    ((result.addonStadyPoints != "0") ?
                     
                    "\n\n" + "На развитие " + friendTeam.getSocialData().getFirstName() + " вам выдано \n" +
                    result.addonStadyPoints + EndingUtils.chooseEnding(parseInt(result.addonStadyPoints), " очков", " очко", " очка") +
                    " обучения"

                            : "")  



                    ,
                    MessageBox.OK_CANCEL_BTN, function():void{

                var uploadImage:BitmapData = Gallery.getFromStore(Gallery.TYPE_TEAM, Application.teamProfiler.getTeamLogoId().toString());
                new WallController(uploadImage, friendTeam.getSocialUserId(), "Привет, я " +
                                                                              MessageUtils.wordBySex(Application.teamProfiler, "взял", "взяла") +
                                                                              " тебя в свою команду. Мой ФК «" +
                                                                              Application.teamProfiler.getTeamName() + "» стал ещё лучше благодаря тебе. Спасибо!").start();
 
            });
            msgBox.show(); 
            inTeamBtn.setQtip(UserProfileHelper.getNameTextByProfile(friendTeam) + " теперь играет за ваш клуб");
            inTeamBtn.setDisabled(true);
            friendTeam.setAbleToChoose(false);
        }
    }


}
}