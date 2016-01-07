package ru.kubline.controllers {
import com.adobe.serialization.json.JSON;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

import flash.events.TimerEvent;
import flash.utils.Timer;

import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.interfaces.menu.news.NewsStore;
import ru.kubline.interfaces.menu.rating.RatingStore;
import ru.kubline.interfaces.window.message.MessageBox; 
import ru.kubline.model.News;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;
import ru.kubline.net.MainConnection;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.IncommingMessageEvent;
import ru.kubline.social.controller.VkontakteController;
import ru.kubline.social.events.LoadAppFriendsEvent;
import ru.kubline.social.events.LoadCitiesEvent;
import ru.kubline.social.events.LoadCountriesEvent;
import ru.kubline.social.events.LoadUserProfilesEvent;
import ru.kubline.social.events.LoadUsersGroupEvent;
import ru.kubline.social.model.SocialCity;
import ru.kubline.social.model.SocialCountry;
import ru.kubline.social.profile.SocialUserData;
import ru.kubline.social.profile.SocialUserDataStore;
import ru.kubline.utils.ObjectUtils;
import ru.kubline.utils.ServerTime;


/**
 * класс отвечает за логин к серверу соц сети а также игровому серверу
 * и подгружает UserProfile текущего пользователя
 */
public class LoginController extends EventDispatcher {

    // create logger instance
    private var log:Logger = new Logger(LoginController);
 
    /**
     * количество приглашенных друзей за которых нужно выдать награду
     */
    private var friendsAward:int;

    /**
     * нужно ли выдать ежедневный подарок
     */
    private var dailyBonusNeeded:Boolean = false;

    public var groupBonusNeeded:Boolean = false;


    private var vkontakteController:VkontakteController;

    /**
     * список id анкет друзей
     */
    private var friendsSocialIdList:Array = new Array();

    /**
     * таймер по которому будем осуществлять повторный логин при ошибке
     */
    private static var timer:Timer = null;
    private var uids:Array = new Array();;

    protected var userInGroup:Boolean = false;

    /**
     * @param vkController контроллер для обработки ответов соц. сети
     */
    public function LoginController(vkController:VkontakteController) {
        this.friendsAward = 0;
        this.vkontakteController = vkController;

        var flashVars:Object = Singletons.context.getFlashVars();

        var response:Object = HTTPConnection.getResponse();
        if(response){

            // log.fatal(response.energyTimer) ;

            Application.instance.context.setTourStartAt(response.tourStartAt);
            Application.instance.context.setTourFinishedAt(response.tourFinishedAt);
            
            ServerTime.setServerTime(response.serverTime);

            TeamProfiler.setIsInstalled(response.isInstalled);
            if(TeamProfiler.getIsInstalled() == 1){
                Application.teamProfiler.initFromServer(response.teamInfo);
                Application.teamProfiler.setEnergyTimer(response.energyTimer); // +  45 сек для надёжности 
            }
        }

        Application.teamProfiler.setSocialUserId(parseInt(Singletons.context.getUserId()));
    }

    /**
     * выполнить логин
     */
    public function login():void {

        if(!Application.VKIsEnabled){
            var response:Object;
            response = HTTPConnection.getResponse();
            if(TeamProfiler.getIsInstalled() > 0){
                Application.teamProfiler.initFromServer(response.teamInfo);
                Application.teamProfiler.setEnergyTimer(response.energyTimer);
                loginComplete();
            }else{
                loginComplete();
            }
            return;
        }

        //регестрируем обработчики для загрузки списка друзей
        vkontakteController.addEventListener(LoadAppFriendsEvent.SUCCESSFULL, onLoadFriendsSuccess);
        vkontakteController.addEventListener(LoadAppFriendsEvent.ERROR, onSocialError);
        log.info("try to get appFriends...");
        vkontakteController.getAppFriends();
    }

    /**
     * Если возникла ошибка при запросе к социальной сети
     */
    private function onSocialError(e:Event): void {
        log.error("onSocialError:  i/o error");
        var msgBox:MessageBox = new MessageBox(Messages.getMessage("TITLE_ERROR"), Messages.getMessage("ERROR_SOCIAL_API"), MessageBox.BTN_NONE);
        msgBox.show();
        deactivate();
        //говорим о том, что произошла ошибка при загрузки приложения
        this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));
    }

    private function arrConcatUnique(...args):Array
    {
        var retArr:Array = new Array();
        for each (var arg:* in args)
        {
            if (arg is Array)
            {
                for each (var value:* in arg)
                {
                    if (retArr.indexOf(value) == -1)
                        retArr.push(value);
                }
            }
        }
        return retArr;
    }

    /**
     * Успешная загрузка списка друзей
     */
    private function onLoadFriendsSuccess(e:LoadAppFriendsEvent): void {

        vkontakteController.removeEventListener(LoadAppFriendsEvent.SUCCESSFULL, onLoadFriendsSuccess);
        vkontakteController.removeEventListener(LoadAppFriendsEvent.ERROR, onSocialError);

        log.info("onLoadAppFriendsSuccess");

        uids.push(Application.teamProfiler.getSocialUserId());
        for each (var id:uint in e.getUids()) {
            uids.push(id);
        }
 
        log.info("try to get FriendsProfiles...");
        // регестрируем обработчики для загрузки профайлов пользователей
        vkontakteController.addEventListener(LoadUserProfilesEvent.SUCCESSFULL, onLoadUserProfilesSuccess);
        vkontakteController.addEventListener(LoadUserProfilesEvent.ERROR, onSocialError);
        //запрашиваем список всех профайлов юзеров
        vkontakteController.getUserProfilesGen(uids);
 
    }


    /**
     * Успешная загрузка списка данных из социалки обо мне и друзьях
     */
    private function onLoadUserProfilesSuccess(e:LoadUserProfilesEvent): void {
        log.info("onLoadUserProfilesSuccess");
        //список загруженый профайлов
        var socialUserProfiles:Object = e.getUsersProfiles();
        //сохраняем профайлы в хранилище профайлов

        SocialUserDataStore.setStore(socialUserProfiles);
        var friendProfiles:Object = new Object();
        for each(var socialData:SocialUserData in socialUserProfiles) {
            //собираем список друзей исключая из него свой пофайл

            if (socialData.getId() != Application.teamProfiler.getSocialUserId()) {
                friendsSocialIdList.push(socialData.getId());

                var friendProfile:TeamProfiler = new TeamProfiler();
                friendProfile.initFromSocialData(socialData, false);
                friendProfiles[friendProfile.getSocialUserId()] = friendProfile;

            }else{
                Application.teamProfiler.initFromSocialData(socialData);  
            }
        }
        log.info("try to login on server...");

        //сохраняем список профайлов друзей
        FriendProfilesStore.init(friendProfiles, friendsSocialIdList.length);
        var response:Object;
        response = HTTPConnection.getResponse();

        if(TeamProfiler.getIsInstalled() > 0){
            if(response.teamInfo){
                Application.teamProfiler.getSocialData().setServerName(response.teamInfo.userName);
                vkontakteController.addEventListener(LoadUsersGroupEvent.SUCCESSFULL, onLoadUsersGroupSuccess);
                vkontakteController.addEventListener(LoadUsersGroupEvent.ERROR, onSocialError);
                vkontakteController.getUsersGroup();
                log.debug(response.teamInfo.userName);
            }
            
        }else{
            friendInfoFromServer(friendsSocialIdList);
        }
    }

    private function onLoadUsersGroupSuccess(e:LoadUsersGroupEvent): void {

        vkontakteController.removeEventListener(LoadUsersGroupEvent.SUCCESSFULL, onLoadUsersGroupSuccess);
        vkontakteController.removeEventListener(LoadUsersGroupEvent.ERROR, onSocialError);

        var gids:Array = e.getGids();
        for each(var gId:uint in gids) {
            if(gId == 21566441 && Application.teamProfiler.getInGroup() == 0){
                groupBonusNeeded = true;
            }
        }

        Singletons.connection.addEventListener(HTTPConnection.COMMAND_FRIEND_TEAM, gotFriendTeams);
        Singletons.connection.send(HTTPConnection.COMMAND_FRIEND_TEAM, {
            uids: ObjectUtils.JSONerArray(uids),
            groupBonusNeeded: (groupBonusNeeded ? 1 : 0),
            groupSourceId: Application.instance.context.getGroupSource(),
            userCountry : Application.teamProfiler.getSocialData().getCountry(),
            userCity : Application.teamProfiler.getSocialData().getCity(),
            userUniversity : Application.teamProfiler.getSocialData().getUniversity()
        } );

    }

    /**
     * Получение команд друзей
     * @param event
     */
    private function gotFriendTeams(event:Event):void{
        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_FRIEND_TEAM, gotFriendTeams); 
        var result:Object = HTTPConnection.getResponse();
        if(result){
            var key:String;
            var vkId:uint;
            if(result.teams){
                var countPlace:uint = 1;
                for (key in result.teams) {
                    vkId = parseInt(result.teams[key].socialUserId);
                    
                    if(FriendProfilesStore.getFriendById(vkId)){
                        result.teams[key].place = countPlace;
                        FriendProfilesStore.getFriendById(vkId).initFromServer(result.teams[key]);
                        countPlace ++  ;
                    }
                }
            }

            if(result.news){
                var newsId:uint;
                var newsInstance:News;
                for (key in result.news) {
                    newsId = parseInt(result.news[key].id);
                    newsInstance = new News(newsId, result.news[key].title, result.news[key].content, result.news[key].image, result.news[key].sub_title );
                    NewsStore.addNewsToStore(newsId, newsInstance);
                }
            }

            if(result.rating){
                var teamInstance:TeamProfiler;
                var place:uint = 1;
                var userTeamInWorld:Boolean = false;
                for (key in result.rating) {
                    vkId = parseInt(result.rating[key].socialUserId);
                    if(vkId == Application.teamProfiler.getSocialUserId()){
                        userTeamInWorld = true;
                    }
                    teamInstance = new TeamProfiler( );
                    teamInstance.initFromServer(result.rating[key]) ;
                    teamInstance.setPlaceInWorld(place);

                    if(place == 6){
                        if(userTeamInWorld){
                            RatingStore.addRatingToStore(vkId, teamInstance);
                        }else{
                            RatingStore.addRatingToStore(Application.teamProfiler.getSocialUserId(), Application.teamProfiler);
                        }
                    } else {
                        RatingStore.addRatingToStore(vkId, teamInstance);
                    }

                    place ++;
                }
            }
            loginComplete();
        }else{
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));
        };
    }

    /**
     * Получаем список занятых друзей
     */
    private function friendInfoFromServer(friendsSocialIdList:Array): void {
        // Приложение установленно
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_FRIEND_INFO, gotFriendInfo);
        Singletons.connection.send(HTTPConnection.COMMAND_FRIEND_INFO, JSON.encode(friendsSocialIdList));
    }

    /**
     * При начале
     * @param event
     */
    private function gotFriendInfo(event:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_FRIEND_INFO, gotFriendInfo);
        var result:Object = HTTPConnection.getResponse();
        if(result){
            var friendsForChoose:Array = result.friendsForChoose as Array;
            if(friendsForChoose && friendsForChoose.length){
                var key:String;
                var allFrinds:Object = FriendProfilesStore.getFrindsStore(); 
                if(allFrinds){
                    for (key in allFrinds) {
                        var userId:uint = parseInt(key);
                        if(friendsForChoose[0] && friendsForChoose[0][userId]){
                            FriendProfilesStore.getFriendById(userId).initForChoose(); 
                        }
                    }
                }
            }
            log.debug("Denis: before getFriendById");
            if(Application.teamProfiler.getSocialUserId()){
                var trable:TeamProfiler = FriendProfilesStore.getFriendById(Application.teamProfiler.getSocialUserId());
                if(trable){
                    trable.initForChoose();
                }
            }
            log.debug("Denis: and after getFriendById");
            loginComplete();
        }else{
            log.debug("Denis: pizdec");
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));
        };
    }

    /**
     * метод осуществляет логин на игровой сервер
     */
    private function loginToGameServer(friendsSocialIdList:Array): void {

        // Приложение установленно 
        if(TeamProfiler.getIsInstalled() > 0){
            var result:Object = HTTPConnection.getResponse();
            Application.teamProfiler.initFromServer(result.userTeam);
        }
        loginComplete();
    }


    /**
     * вызывается в последнюю очередь после успешного логина
     * на сервер и подгрузки всех необходимых данных
     */
    private function loginComplete(): void {


        if(Application.teamProfiler.getSocialData().getCity()){
            Singletons.vkontakteController.addEventListener(LoadCitiesEvent.LOAD_CITIES, onLoadUsersCitiesSuccess);
            Singletons.vkontakteController.getCityNameById(Application.teamProfiler.getSocialData().getCity());
        }

        if(Application.teamProfiler.getSocialData().getCountry()){
            Singletons.vkontakteController.addEventListener(LoadCountriesEvent.LOAD_COUNTRIES, onLoadUsersCountrySuccess);
            Singletons.vkontakteController.getCountryNameById(Application.teamProfiler.getSocialData().getCountry());
        }

        //очищаем память от мусора
        friendsSocialIdList = null;
        deactivate();
        //рассылаем событие об успешной загрузки
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onLoadUsersCitiesSuccess(e:LoadCitiesEvent): void {

        Singletons.vkontakteController.removeEventListener(LoadCitiesEvent.LOAD_CITIES, onLoadUsersCitiesSuccess);

        if(e.success){
            var cities:Array = e.socialCities;
            for each(var city:SocialCity in cities) {
                if(city.getCid() == Application.teamProfiler.getSocialData().getCity()){
                    Application.teamProfiler.getSocialData().setCityName(city.getTitle());
                }
            }
        }
    }


    private function onLoadUsersCountrySuccess(e:LoadCountriesEvent): void {

        Singletons.vkontakteController.removeEventListener(LoadCountriesEvent.LOAD_COUNTRIES, onLoadUsersCitiesSuccess);

        if(e.success){
            var countries:Array = e.socialCountries;
            for each(var country:SocialCountry in countries) {
                if(country.getCid() == Application.teamProfiler.getSocialData().getCountry()){
                    Application.teamProfiler.getSocialData().setCountryName(country.getTitle());
                }
            }
        }
    }

    /**
     * здесь отписываемся от всех событий
     */
    private function deactivate(): void {
        vkontakteController.removeEventListener(LoadUserProfilesEvent.SUCCESSFULL, onLoadUserProfilesSuccess);
        vkontakteController.removeEventListener(LoadAppFriendsEvent.SUCCESSFULL, onLoadFriendsSuccess);
        vkontakteController.removeEventListener(LoadAppFriendsEvent.ERROR, onSocialError);
        vkontakteController.removeEventListener(LoadUserProfilesEvent.ERROR, onSocialError);
    }

    public function getUserProfile():TeamProfiler {
        return Application.teamProfiler;
    }

    /**
     * @return количество приглашенных друзей за которых нужно выдать награду
     */
    public function getFriendsAward():int {
        return friendsAward;
    }

    public function needDailyBonus():Boolean {
        return dailyBonusNeeded;
    }
}
}