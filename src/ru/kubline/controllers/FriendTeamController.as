package ru.kubline.controllers {
import flash.events.Event;
import flash.events.IOErrorEvent;

import ru.kubline.interfaces.FriendTeam;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:42:25 PM
 */

public class FriendTeamController {

    private var team: TeamProfiler ;

    private var friendTeam:FriendTeam;

    public function FriendTeamController() {
        friendTeam = new FriendTeam();
    }
 
    public function init(team:TeamProfiler):void{

        team = FriendProfilesStore.getFriendById(team.getSocialUserId());

        if(team.getPlaceCity()){
            friendTeam.show();
            friendTeam.initTeam(team);
        }else{

            this.team = team;

            Singletons.connection.addEventListener(HTTPConnection.COMMAND_GET_TEAM_INFO, whenLoadedProfile);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenLoadedProfile);
            Singletons.connection.send(HTTPConnection.COMMAND_GET_TEAM_INFO, {teamId:team.getSocialUserId()});
        }

    }


    private function whenLoadedProfile(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_GET_TEAM_INFO, whenLoadedProfile);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenLoadedProfile);

        var result:Object = HTTPConnection.getResponse();

        if(result){
            FriendProfilesStore.getFriendById(team.getSocialUserId()).initFromServer(result.team);

            friendTeam.show();
            friendTeam.initTeam(FriendProfilesStore.getFriendById(team.getSocialUserId()));
        }
    }



}
}