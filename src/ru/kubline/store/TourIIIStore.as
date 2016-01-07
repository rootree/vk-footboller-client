package ru.kubline.store {
import flash.utils.ObjectInput;

import ru.kubline.interfaces.battle.TourIIIResult;
import ru.kubline.loader.tour.*;

import flash.events.Event;
import flash.events.EventDispatcher;

import flash.events.IOErrorEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.model.CupPlaces;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ObjectUtils;


public class TourIIIStore extends EventDispatcher{

    public function TourIIIStore() {
        store = new Object();
        storePlayOff = new Object();
        storeChanpions = new Object();
        storeGroupSteps = new Object();
        storePlayOffSteps = new Object();
    }

    private static var instanceStore:TourIIIStore;

    private var store:Object;

    private var storePlayOff:Object;

    private var storeChanpions:Object;

    private var storeGroupSteps:Object;

    private var storePlayOffSteps:Object;


    private var groupType:uint;

    public static function get instance():TourIIIStore {
        if(!instanceStore){
            instanceStore = new TourIIIStore() ;
        }
        return instanceStore;
    }




    public static function getStore():Object {
        return instance.store;
    }

    public static function getStoreByType(type:uint):Array{
        return instance.store[type];
    }

    public static function getPlayOffStoreByType(type:uint):Array{
        return instance.storePlayOff[type];
    }

    public static function getChampionsByType(type:uint):CupPlaces{
        return instance.storeChanpions[type];
    }

    public static function getGroupsStepByType(type:uint):Object{
        return instance.storeGroupSteps[type];
    }

    public static function getPlayOffStepByType(type:uint):Object{
        return instance.storePlayOffSteps[type];
    }

    public static function setGroupsStepByType(type:uint, step:Object):void{
        instance.storeGroupSteps[type] = step;
    }

    public static function setPlayOffStepByType(type:uint, step:Object):void{
        instance.storePlayOffSteps[type] = step;
    }




    public static function isCompleteCurrentTour(tourTypeS:uint = 0):Boolean{

        if(tourTypeS == 0){
            if(!TourIIIResult.tourType){
                return true;
            }else{
                tourTypeS = TourIIIResult.tourType;
            }
        }

        var groupsSteps:Object = TourIIIStore.getGroupsStepByType(tourTypeS);
        var playSteps:Object = TourIIIStore.getPlayOffStepByType(tourTypeS);
        if(ObjectUtils.count(groupsSteps) > 0 || ObjectUtils.count(playSteps) > 0){
            return false;
        }else{
            return true;
        }
    }


    public static function isLoaded(type:uint):Boolean{
        return Boolean(instance.store[type]);
    }

    public static function isFilly(type:uint):Boolean{
        return Boolean(ObjectUtils.count(instance.store[type]));
    }

    public static function loadGroups(type:uint):void{

        instance.groupType = type;

        var placerId:uint = 0;

        switch(type){
            case TourType.TOUR_TYPE_UNI     : placerId = Application.teamProfiler.getSocialData().getUniversity(); break;
            case TourType.TOUR_TYPE_CITY    : placerId = Application.teamProfiler.getSocialData().getCity(); break;
            case TourType.TOUR_TYPE_COUNTRY : placerId = Application.teamProfiler.getSocialData().getCountry(); break;
        }

        Singletons.connection.addEventListener(HTTPConnection.COMMAND_GROUPS, instance.whenGroupLoaded);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, instance.whenGroupLoaded);
        Singletons.connection.send(HTTPConnection.COMMAND_GROUPS, {
            groupType: instance.groupType,
            placerId: placerId
        });

    }

    private function whenGroupLoaded(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GROUPS, whenGroupLoaded);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenGroupLoaded);

        var result:Object = HTTPConnection.getResponse();

        var groupContent:Array = new Array();
        var groupItem:Object = new Object();

        if(result.group){

            var key:String;
            var subKey:String;

            for (key in result.group) {

                groupContent[key] = new Array();
                var groupInside:Array = result.group[key];

                for (subKey in groupInside) {

                    var vkId:uint = parseInt(groupInside[subKey].vk_id);
                    var wins:uint = parseInt(groupInside[subKey].wins);
                    var ties:uint = parseInt(groupInside[subKey].ties);
                    var loses:uint = parseInt(groupInside[subKey].loses);
                    var score:uint = parseInt(groupInside[subKey].score);
                    var group_number:uint = parseInt(groupInside[subKey].group_number);

                    groupItem = {
                        vkId  : vkId,
                        wins  : wins,
                        ties  : ties,
                        loses : loses,
                        score : score,
                        group_number : group_number
                    };

                    groupContent[key].push(groupItem);
                }

            }

            store[instance.groupType] = groupContent;

            if(result.teams){
                for (key in result.teams) {
                    var teamInstance:TeamProfiler = new TeamProfiler( );
                    teamInstance.initFromServer(result.teams[key]) ;
                    TeamProfilesStore.add(teamInstance);
                }
            }

            if(result.playOff){

                var playOffContent:Array = new Array();
                var playOffItem:Object = new Object();

                for (key in result.playOff) {

                    playOffContent[key] = new Array();

                    var playOffInside:Object = result.playOff[key];

                    for (subKey in playOffInside) {

                        var team:uint       = parseInt(playOffInside[subKey].team);
                        var teamEnemy:uint  = parseInt(playOffInside[subKey].teamEnemy);
                        var goal:uint       = parseInt(playOffInside[subKey].goal);
                        var goalEnemy:uint  = parseInt(playOffInside[subKey].goalEnemy);

                        playOffItem = {
                            team       : team,
                            teamEnemy  : teamEnemy,
                            goal       : goal,
                            goalEnemy  : goalEnemy
                        };

                        playOffContent[key].push(playOffItem);
                    }
                }

                storePlayOff[instance.groupType] = playOffContent;

                if(playOffContent[1][0]){

                    var first:uint  = (playOffContent[1][0].goal > playOffContent[1][0].goalEnemy) ? playOffContent[1][0].team       : playOffContent[1][0].teamEnemy;
                    var second:uint = (playOffContent[1][0].goal > playOffContent[1][0].goalEnemy) ? playOffContent[1][0].teamEnemy  : playOffContent[1][0].team;
                    var third:uint  = (playOffContent[1][1].goal > playOffContent[1][1].goalEnemy) ? playOffContent[1][1].team       : playOffContent[1][1].teamEnemy;

                    storeChanpions[instance.groupType] = new CupPlaces(first, second, third);;
                }else{
                    storeChanpions[instance.groupType] = null;
                }

            }

            if(!storeGroupSteps[instance.groupType]){
                storeGroupSteps[instance.groupType] = new Object();
            }
            if(result.groupSteps){

                for (key in result.groupSteps) {
                    storeGroupSteps[instance.groupType][key] = result.groupSteps[key];
                }
            }

            if(!storePlayOffSteps[instance.groupType]){
                storePlayOffSteps[instance.groupType] = new Object();
            }
            if(result.playOffSteps){

                for (key in result.playOffSteps) {
                    storePlayOffSteps[instance.groupType][key] = result.playOffSteps[key];
                }
            }


            dispatchEvent(new LoadTourGroupEvent(instance.groupType));

        }else{

            store[instance.groupType] = new Array();

        }
    }

}
}