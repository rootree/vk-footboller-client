package ru.kubline.store {
import ru.kubline.loader.tour.*;

import flash.events.Event;
import flash.events.EventDispatcher;

import flash.events.IOErrorEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;


public class TeamProfilesStore extends EventDispatcher{

    public function TeamProfilesStore() {
        store = new Object();
    }

    private static var instanceStore:TeamProfilesStore;

    private var store:Object;

    private var groupType:uint;

    public static function get instance():TeamProfilesStore {
        if(!instanceStore){
            instanceStore = new TeamProfilesStore() ;
        }
        return instanceStore;
    }

    public static function getStore():Object {
        return instance.store;
    }

    public static function getProfileById(id:uint):TeamProfiler{
        return instance.store[id];
    }

    public static function isLoaded(id:uint):Boolean{
        return Boolean(instance.store[id]);
    }

    public static function add(team:TeamProfiler):void{
        instance.store[team.getSocialUserId()] = team;
        trace("Add " + team.getSocialUserId() + " to store");
    }


}
}