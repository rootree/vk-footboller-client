package ru.kubline.model {

import com.adobe.serialization.json.JSON;

import flash.errors.IllegalOperationError;
import flash.events.IOErrorEvent;

import flash.events.TimerEvent;
import flash.utils.Timer;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.team.UserPlayersMenu;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.interfaces.window.message.NewLevelMessage;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.loader.tour.TourNotifyType;
import ru.kubline.loader.tour.TourType;
import ru.kubline.net.HTTPConnection;
import ru.kubline.settings.LevelsGrid;
import ru.kubline.social.profile.SocialUserData;
import ru.kubline.utils.ObjectUtils;

public class TeamProfiler {

    /**
     * Идентификатор пользователя в соц. сети
     */
    private var socialUserId:uint;

    /**
     * профайл игрока из социалки
     */
    private var socialData:SocialUserData;

    private var level:uint;

    private var experience:uint;

    private var money:Number;

    private var realMoney:Number;

    private var studyPoints:uint;

    private var studyPointsViaPrize:uint;

    private var inGroup:uint;

    private var isNeedDailyBonus:Boolean = false;

    private var paramForward:uint;

    private var paramHalf:uint;

    private var paramSafe:uint;

    private var energy:uint;

    private var energyMax:uint;

    private var trainer:Trainer;

    private var footballers:Object;

    private var sponsors:Object;

    private var teamName:String;

    private var userPhoto:String;

    private var userName:String;

    private var teamLogoId:uint;

    private var isAbleToChoose:Boolean = false;  // TODO Посмотреть что будет при создании команды

    private static var isInstalled:int;

    private var isTeamInstalled:int = 0;

    private var shopLevel:uint;

    private var energyTimer:uint;

    private var counterWin:uint = 0;

    private var counterLose:uint = 0;

    private var counterChoose:uint = 0;

    private var commonPlace:uint = 0;

    private var placeInWorld:uint = 0;

    private var evergyRate:Number = 1;

    public static var MAX_TEAM_PARAM :uint = 0;

    public static var MAX_FOOTBALLER_PARAM :uint = 0;

    private var shopPrice:Number;

    private var stadium:Stadium;

    private var placeCountry:uint = 0;

    private var placeCity:uint = 0;

    private var placeUniversity:uint = 0;

    private var placeVK:uint = 0;

    
    private var tourIII:uint = 0;

    private var tourPlaceCountry:uint = 0;
    private var tourPlaceCity:uint = 0;
    private var tourPlaceUniversity:uint = 0;
    private var tourPlaceVK:uint = 0;


    private var prizeMode:uint = 0;
    
    private var tourNotify:uint = 0;

    private var tourBonus:Number = 0;

    private var tourBonusTime:Number;

    private var placeForFriend:uint = 0;
    
    private var totalPlace:uint = 0;

    public function TeamProfiler() {
        trainer = new Trainer(0);
        stadium = new Stadium(0);
        footballers = new Object();
        sponsors = new Object();
    }


    public function getSocialData():SocialUserData {
        return socialData;
    }

    /**
     * иницализирует socialData и имя
     */
    public function initFromSocialData(socialData:SocialUserData, forceFromFirstRequest:Boolean = true):void {
        this.socialData = socialData;
        if (socialData) {
            if(!trainer.getId()){
                trainer.setName(socialData.getFirstName(forceFromFirstRequest) + ' ' + socialData.getLastName(forceFromFirstRequest));
            }
            setSocialUserId(socialData.getId());
        } else {
            trainer.setName("--");
        }
    }

    public function getJSONofFootballers():Object{

        var footballers:Object = new Object();
        for each (var tempFoot:* in this.footballers) {
            footballers[tempFoot.getId()] =
            {
                name:      tempFoot.getFootballerName(),
                level:     tempFoot.getLevel(),
                type:      tempFoot.getType(),
                isFriend:  tempFoot.getIsFriend(),
                isActive:  tempFoot.getIsActive()
            };
        }
        return footballers;

    }

    public function getJSONofSponsors():Object{

        var sponsors:Object = new Object();
        var evergySum:uint;
        for each (var sponsor:* in this.sponsors) {
            sponsors[sponsor.getId()] = {
                name:   sponsor.getSponsorName(),
                evergy: sponsor.getEnergy()
            };
            evergySum += sponsor.getEnergy();
        }
        Application.teamProfiler.setEnergy(evergySum);
        return sponsors;

    }

    public function getJSON():Object{

        var footballers:Object = getJSONofFootballers();
        var sponsors:Object = getJSONofSponsors();

        var tempJSON:Object = {
            level       :this.level,
            experience  :this.experience,
            money       :this.money,
            realMoney   :this.realMoney,
            studyPoints :this.studyPoints,
            paramForward      :this.paramForward,
            paramHalf         :this.paramHalf,
            paramSafe         :this.paramSafe,
            energy      :this.energy,
            trainer     :this.trainer.getId(),
            teamName    :this.teamName,
            teamLogoId  :this.teamLogoId,
            footballers :footballers,
            sponsors    :sponsors,
            isInstalled :getIsInstalled
        };
        var jsonString:String = JSON.encode( tempJSON );
        return (jsonString);
    }

    public function initForChoose():void{
        setAbleToChoose(true);
    }

    public function initForChooseExtented(init:Object):void{
        shopLevel = parseInt(init.level);
        shopPrice = parseInt(init.price);
        setAbleToChoose(true);
    }

    public function getShopLevel():uint{
        return shopLevel;
    }

    public function getShopPrice():uint{
        return shopPrice;
    }

    public function getStadium():Stadium{
        return stadium;
    }

    public function initFromServer(teamObject:Object):void{

        if(socialData && teamObject.userName){
            socialData.setServerName(teamObject.userName);
        }

        setLevel(teamObject.level);
        setExperience(teamObject.experience);
        setMoney(teamObject.money);
        setRealMoney(teamObject.realMoney);
        setStudyPoints(teamObject.studyPoints);
        setParamForward(teamObject.paramForward);
        setParamHalf(teamObject.paramHalf);
        setParamSafe(teamObject.paramSafe);
        setEnergy(teamObject.energy);
        setTeamName(teamObject.teamName);
        setUserPhoto(teamObject.userPhoto);
        setUserName(teamObject.userName);
        setTeamLogoId(teamObject.teamLogoId);
        setStudyPointsViaPrize(teamObject.studyPointsViaPrize);
        setInGroup(teamObject.inGroup);
        setDailyBonus(teamObject.needDailyBonus);
        setSocialUserId(teamObject.socialUserId);

        stadium.init(teamObject.stadiumId);

        if(!trainer.getId()){
            trainer.setName(teamObject.userName);
        }

        setAbleToChoose(!Boolean(parseInt(teamObject.isInTeam)));

        setCounterChoose(parseInt(teamObject.counterChoose)) ;
        setCounterWin(parseInt(teamObject.counterWon)) ;
        setCounterLose(parseInt(teamObject.counterLose)) ;

        setPlaceCountry(parseInt(teamObject.placeCountry)) ;
        setPlaceCity(parseInt(teamObject.placeCity)) ;
        setPlaceUniversity(parseInt(teamObject.placeUniversity)) ;
        setPlaceVK(parseInt(teamObject.placeVK)) ;

        setTourIII(parseInt(teamObject.tourIIIcounter)) ;
 
        setTourPlaceCountry(parseInt(teamObject.tourPlaceCountry)) ;
        setTourPlaceCity(parseInt(teamObject.tourPlaceCity)) ;
        setTourPlaceUniversity(parseInt(teamObject.tourPlaceUniversity)) ;
        setTourPlaceVK(parseInt(teamObject.tourPlaceVK)) ;

        setPrizeMode(parseInt(teamObject.prizeMode)) ;
        setTourNotify(parseInt(teamObject.tourNotify)) ;
 
        setTourBonus(parseFloat(teamObject.tourBonus.toString())) ;
        setTourBonusTime(parseInt(teamObject.tourBonusTime)) ;
        setTotalPlace(parseInt(teamObject.totalPlace)) ;

        var place:uint = parseInt(teamObject.place); 
        if(place != 0 && place != 99){
            setPlaceForFriend(place) ;
        }

        var myArray:Array = new Array();
        myArray.push(getParamForward());
        myArray.push(getParamSafe());
        myArray.push(getParamHalf());

        if(!TeamProfiler.MAX_TEAM_PARAM && Application.teamProfiler.getSocialUserId() == getSocialUserId()){
            for each (var num:Number in myArray) {
                if (num > TeamProfiler.MAX_TEAM_PARAM)
                    TeamProfiler.MAX_TEAM_PARAM = num;
            }

            TeamProfiler.MAX_TEAM_PARAM *= 1.50;
            if(TeamProfiler.MAX_TEAM_PARAM < 50){
                TeamProfiler.MAX_TEAM_PARAM = 50;
            }
        }

        teamObject.trainerId = parseInt(teamObject.trainerId);

        trainer = new Trainer(teamObject.trainerId);
        isTeamInstalled = 1;

        if(teamObject.trainerId == 0){
            if(Application.VKIsEnabled && getSocialData()){
                trainer.setName(getSocialData().getFirstName() + " " +
                                getSocialData().getLastName());
            }else{
                trainer.setName("--");
            }
        }

        initFootballers(teamObject.footballers);

        if(Application.teamProfiler.getSocialUserId() == getSocialUserId()){
            TeamProfiler.MAX_FOOTBALLER_PARAM += studyPoints + 10; 
        }

        var prototypeId:uint;
        var item:ItemResource;
        var sponsor:Sponsor;
        var key:String;
        if(teamObject.sponsors){
            for (key in teamObject.sponsors) {
                prototypeId = parseInt(teamObject.sponsors[key].id);
                item = ItemTypeStore.getItemResourceById(prototypeId);
                sponsor = new Sponsor(item.getName(), parseFloat(item.getParams().energy), prototypeId);
                sponsors[prototypeId] = sponsor;
                evergyRate *= sponsor.getEnergy();
            }
        }

        energyMax = Math.floor(LevelsGrid.levelMaxEnergy(getLevel()) * evergyRate);
        setEnergyMax(energyMax);

    }

    public function initFootballers(footballersPrototype:Object):void{

        var key:String;
        var is_friend:Boolean;
        var prototypeId:uint;
        
        if(footballersPrototype){
            
            for (key in footballersPrototype) {

                prototypeId = parseInt(footballersPrototype[key].id);

                var isFriend:Boolean = Boolean(footballersPrototype[key].isFriend);
                var footballerName:String;

                if(isFriend){
                    footballerName = footballersPrototype[key].footballerName;
                }else{
                    var store:Object = ItemTypeStore.getStore();
                    var itemResurse:ItemResource = store[prototypeId];
                    if(!itemResurse){
                        footballerName = "Имя неизвестно";
                    }else{
                        footballerName = itemResurse.getName();
                    }
                }

                var footballer:Footballer = new Footballer(
                        footballerName,
                        parseInt(footballersPrototype[key].level),
                        String(footballersPrototype[key].type),
                        prototypeId,
                        isFriend,
                        Boolean(parseInt(footballersPrototype[key].isActive)),
                        String(footballersPrototype[key].photoForFriend),
                        parseInt(footballersPrototype[key].price),
                        0,0,
                        footballersPrototype[key].favorite,
                        footballersPrototype[key].healthDown
                        );

                if(isFriend){
                    footballer.setYear(parseInt(footballersPrototype[key].year));
                    footballer.setCountryCode(parseInt(footballersPrototype[key].country));
                    footballer.setTeamName(footballersPrototype[key].team_name);
                }
                
                footballers[prototypeId] = footballer;

                if(Application.teamProfiler.getSocialUserId() == getSocialUserId()){
                    if(footballer.getLevel() > TeamProfiler.MAX_FOOTBALLER_PARAM){
                        TeamProfiler.MAX_FOOTBALLER_PARAM = footballer.getLevel();
                    }
                }
            }
        }

    }
    public function setFromJSON(jsonString:String):void{
        var value:* = JSON.decode( jsonString );
    }

    public function getSocialUserId():uint {
        return socialUserId;
    }

    public function getEvergyRate():Number {
        return evergyRate;
    }

    public function getFanatRating():Number {
        var counterWin:uint = (getCounterWin()) ? getCounterWin() : 1;
        var counterLose:uint = (getCounterLose()) ? getCounterLose() : 1;
        var index:Number = 1 - counterLose / counterWin;
        if(index < 1){
            index = 1;
        }else{
            if(index > 2){
                index = 2;
            }
        }
        return index;
    }

    public function getTotalStadiumBonus():uint {
        if(getStadium().getId()){
            return Math.floor(getStadium().getDailyBonus() * getFanatRating() * getEvergyRate());
        }else{
            return 0;
        }
    }

    public function setEnergyMax(value:uint):void{
        energyMax = value;
    }

    public function initStadiumById(stadiumId:uint):void{
        stadium.init(stadiumId);
    }

    public function getEnergyMax():uint {
        return energyMax;
    }

    public function setSocialUserId(value:uint):void {
        socialUserId = value;
    }

    public function getLevel():uint {
        return level;
    }

    public function setLevel(value:uint):void {
        level = value;
    }

    /**
     * добавляет опыт, увеличивает level и возвращает true если level увеличен
     * @return true если уровень был увеличен
     */
    public function addExperience(xp:uint):Boolean {
        setExperience(getExperience() + xp);
        var nextLevelXp:uint = LevelsGrid.getNextLevelXp(getLevel());
        var hp:int;
        if (getExperience() >= nextLevelXp) {
            if (LevelsGrid.levelExist(getLevel() + 1)) {
                setLevel(getLevel() + 1);
                setExperience(getExperience() - nextLevelXp);

                var addonStadyPointForLevel:uint = LevelsGrid.levelStadyPoint(getLevel()) + getTrainer().getMulti();
                setStudyPoints(addonStadyPointForLevel +  getStudyPoints());
                setEnergyMax(Math.ceil(LevelsGrid.levelMaxEnergy(getLevel()) * getSponsorAddon()));

                var timer:Timer = new Timer(1500, 1);
                timer.addEventListener(TimerEvent.TIMER, function():void {
                    new NewLevelMessage(addonStadyPointForLevel).show();
                });
                timer.start();

                return true;
            } else {
                setExperience(nextLevelXp);
            }
        }
        return false;
    }

    public function getSponsorAddon():uint{
        var sumEnergy:Number = 1;
        var key:String;
        if(sponsors.length){
            for (key in sponsors) {
                sumEnergy *= Sponsor(sponsors[key]).getEnergy();
            }
        }
        return (sumEnergy <= 0) ? 1 : sumEnergy;
    }

    public function getExperience():uint {
        return experience;
    }

    public function setExperience(value:uint):void {
        experience = value;
    }

    public function getMoney():Number {
        return money;
    }

    public function setMoney(value:Number):void {
        money = value;
    }

    public function getRealMoney():Number {
        return realMoney;
    }

    public function setRealMoney(value:Number):void {
        realMoney = value;
    }

    public function getStudyPoints():uint {
        return studyPoints;
    }

    public function getStudyPointsViaPrize():uint {
        return studyPointsViaPrize;
    }

    public function getInGroup():uint {
        return inGroup;
    }

    public function setStudyPoints(value:uint):void {
        value = (value < 0 || value > 99999) ? 0 : value;
        studyPoints = value;
    }

    public function setStudyPointsViaPrize(value:uint):void {
        studyPointsViaPrize = value;
    }

    public function setInGroup(value:uint):void {
        inGroup = value;
    }

    public function setDailyBonus(value:Boolean):void {
        isNeedDailyBonus = value;
    }

    public function getIsNeedDailyBonus():Boolean {
        return isNeedDailyBonus;
    }

    public function getParamForward():uint {
        return paramForward;
    }

    public function getParamSum():uint {
        return paramForward + paramHalf + paramSafe;
    }

    public function getParamHalf():uint {
        return paramHalf;
    }

    public function getParamSafe():uint {
        return paramSafe;
    }

    public function setParamForward(value:uint):void {
        if(value > Footballer.MAX_PARAMETER){
            paramForward = Footballer.MAX_PARAMETER;
        }else{
            paramForward = (value < 0) ? 0 : value;
        }
    }

    public function setParamHalf(value:uint):void {
        if(value > Footballer.MAX_PARAMETER){
            paramHalf = Footballer.MAX_PARAMETER;
        }else{
            paramHalf = (value < 0) ? 0 : value;;
        }
    }

    public function setParamSafe(value:uint):void {
        if(value > Footballer.MAX_PARAMETER){
            paramSafe = Footballer.MAX_PARAMETER;
        }else{
            paramSafe = (value < 0) ? 0 : value;;
        }

    }

    public function getEnergy():uint {
        return (energy > getEnergyMax()) ? getEnergyMax() : energy;
    }

    public function setEnergy(value:uint):void {
        energy = value;
    }

    public function getTrainer():Trainer {
        return trainer;
    }

    public function setTrainer(value:Trainer):void {
        trainer = value;
    }

    public function getFriendsInTeam():Array {
        var returnPlayers:Array = new Array();
        for each (var value:Footballer in footballers) {
            if(Footballer(value).getIsFriend()){
                returnPlayers.push(value);
            }
        }
        return returnPlayers;
    }

    public function getFootballers(activeType:uint):Array {
        var returnPlayers:Array = new Array();
        for each (var value:Footballer in footballers) {
            if(!activeType){
                returnPlayers.push(value);
            }else{
                if(activeType == Footballer.ACTIVEED && Footballer(value).getIsActive()){
                    returnPlayers.push(value);
                }else if(activeType == Footballer.DEACTIVEED && !Footballer(value).getIsActive()){
                    returnPlayers.push(value);
                }
            }
        }
        return returnPlayers;
    }

    public function setFootballers(data:Object):void {
        footballers = data;
    }

    public function getFootballersCopy():Object {
        var returnPlayers:Object = new Object();
        var footer:Footballer;
        for each (var value:Footballer in footballers) {
            footer = new Footballer(
                    value.getFootballerName(),
                    value.getLevel(),
                    value.getType(),
                    value.getId(),
                    value.getIsFriend(),
                    value.getIsActive(),
                    value.getPhoto(),
                    value.getPrice(),
                    value.getCountryCode(),
                    value.getYear(),
                    value.getFavorite(),
                    value.getHealthDown()
            );
            returnPlayers[value.getId()] = (footer);
        }
        return returnPlayers;
    }

    public function getSponsorsCopy():Object {
        var returnSponsors:Object = new Object();
        var sponsor:Sponsor;
        for each (var value:Sponsor in sponsors) {
            sponsor = new Sponsor(value.getSponsorName(), value.getEnergy(), value.getId());
            returnSponsors[value.getId()] = sponsor;
        }
        return returnSponsors;
    }

    public function getFootballerById(id:uint):Footballer {
        return footballers[id];
    }

    public function addFootballer(value:Footballer):void {
        footballers[value.getId()] = value ;
    }

    public function dropSponsorById(id:uint):void {
        delete(sponsors[id]) ;
    }

    public function dropFootballerById(id:uint):void {
        if(!footballers[id]){
            throw IllegalOperationError("Футболист для удаления не найден");
        }
        footballers[id] = null;
        delete(footballers[id]) ;
    }

    public function getSponsors():Object {
        return sponsors;
    }

    public function getSponsorById(id:uint):Sponsor {
        return sponsors[id];
    }

    public function addSponsor(value:Sponsor):void {
        sponsors[value.getId()] = value ;
    }

    public function setSponsors(value:Object):void {

        var item:ItemResource;
        var evergySum:Number = 1;
        var key:String;

        sponsors = new Object();

        for (key in value) {
            item = ItemTypeStore.getItemResourceById(parseInt(key));
            if(item){
                sponsors[key] = new Sponsor(item.getName(), parseFloat(item.getParams().energy), parseInt(key));
                evergySum *= Sponsor(sponsors[key]).getEnergy();
            }
        }
        setEnergyMax(LevelsGrid.levelMaxEnergy(level) * evergySum);
    }

    public function getTeamName():String {
        return teamName;
    }

    public function getUserPhoto():String {
        return userPhoto;
    }

    public function getUserName():String {
        return userName;
    }

    public function setTeamName(value:String):void {
        teamName = value;
    }

    public function setUserPhoto(value:String):void {
        userPhoto = value;
    }

    public function setUserName(value:String):void {
        userName = value;
    }

    public function setTeamLogoId(value:uint):void {
        teamLogoId = value;
    }

    public function getTeamLogoId():uint {
        return teamLogoId;
    }

    public function setEnergyTimer(value:uint):void {
        energyTimer = value;
    }

    public function setTrainerName(value:String):void {
        trainer.setName(value);
    }

    public static function getIsInstalled():int {
        return isInstalled;
    }

    public function isInstalled():int {
        return isTeamInstalled;
    }

    public static function setIsInstalled(value:int):void {
        isInstalled = value;
    }

    public function getIsAbleToChoose():Boolean {
        return isAbleToChoose;
    }

    public function getEnergyTimer():uint {
        return energyTimer;
    }

    public function setAbleToChoose(value:Boolean):void {
        isAbleToChoose = value;
    }

    public function getStudyPointCount():uint {
        var baseCost:uint = 400;
        var studyPointCost:uint = baseCost + baseCost * getLevel() / 10;
        return studyPointCost;
    }

    public function getCounterWin():uint {
        return counterWin;
    }

    public function setCounterWin(value:uint):void {
        counterWin = value;
    }

    public function setCounterLose(value:uint):void {
        counterLose = value;
    }

    public function getCounterChoose():uint {
        return counterChoose;
    }

    public function getCounterLose():uint {
        return counterLose;
    }

    public function setCounterChoose(value:uint):void {
        counterChoose = value;
    }


    public function getPlaceInWorld():uint {
        return placeInWorld;
    }

    public function setPlaceInWorld(value:uint):void {
        placeInWorld = value;
    }

    public function getPlaceCountry():uint {
        return placeCountry;
    }

    public function setPlaceCountry(value:uint):void {
        placeCountry = value;
    }

    public function getPlaceCity():uint {
        return placeCity;
    }

    public function setPlaceCity(value:uint):void {
        placeCity = value;
    }

    public function getPlaceUniversity():uint {
        return placeUniversity;
    }

    public function setPlaceUniversity(value:uint):void {
        placeUniversity = value;
    }

    public function getTourIII():uint {
        return tourIII;
    }

    public function setTourIII(value:uint):void {
        tourIII = value;
    }

    public function getPlaceVK():uint {
        return placeVK;
    }

    public function setPlaceVK(value:uint):void {
        placeVK = value;
    }

    public function getTourPlaceCountry():uint {
        return tourPlaceCountry;
    }

    public function setTourPlaceCountry(value:uint):void {
        tourPlaceCountry = value;
    }

    public function getTourPlaceCity():uint {
        return tourPlaceCity;
    }

    public function setTourPlaceCity(value:uint):void {
        tourPlaceCity = value;
    }

    public function getTourPlaceUniversity():uint {
        return tourPlaceUniversity;
    }

    public function setTourPlaceUniversity(value:uint):void {
        tourPlaceUniversity = value;
    }

    public function getTourPlaceVK():uint {
        return tourPlaceVK;
    }

    public function setTourPlaceVK(value:uint):void {
        tourPlaceVK = value;
    }

    public function getPrizeMode():uint {
        return prizeMode;
    }

    public function setPrizeMode(value:uint):void {
        prizeMode = value;
    }

    public function getTourNotify():uint {
        return tourNotify;
    }

    public function setTourNotify(value:uint):void {
        tourNotify = value;
    }

    public function getCommonPlace():uint {
        return commonPlace;
    }

    public function setCommonPlace(value:uint):void {
        commonPlace = value;
    }

    public function getTourBonus():Number {
        return tourBonus;
    }

    public function setTourBonus(value:Number):void {
        tourBonus = (value == 0) ? 0 : (value * 100 - 100);
    }

    public function getTourBonusTime():Number {
        return tourBonusTime;
    }

    public function setTourBonusTime(value:Number):void {
        tourBonusTime = value;
    }


    public function isNewTour():Boolean{
        return Boolean(getTourNotify() == TourNotifyType.TOUR_NOTIFY_NEW_NOTIFIED || getTourNotify() == TourNotifyType.TOUR_NOTIFY_NEW);
    }


    public function isDiscount():Boolean{
        return Boolean(isNewTour() && getTourBonus() && getTourBonusTime());
    }


    public function getPlaceForFriend():uint{
        return placeForFriend;
    }


    public function setPlaceForFriend(place:uint):void{
        placeForFriend = place;
    }

    public function getTotalPlace():uint {
        return totalPlace;
    }

    public function setTotalPlace(value:uint):void {
        totalPlace = value;
    }
}
}