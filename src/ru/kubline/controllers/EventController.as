package ru.kubline.controllers {
import flash.media.Sound;
 
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.FootballEvent;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;


public class EventController {

    public static const EVENT_ATTACK_SUCCESS:String = "attack_seccess";
    public static const EVENT_ATTACK_FAIL:String = "attack_fail";
    public static const EVENT_SOS_SUCCESS:String = "sos_success";
    public static const EVENT_SOS_FAIL:String = "sos_fail";
    public static const EVENT_PASS:String = "pass";
    public static const EVENT_PASS_ENEMY:String = "pass_enemy";


    public function EventController() {


    }


    private function getChain(goals:uint, goalsEnemy:uint):Array {

        var freeActions:int;
        if(goals + goalsEnemy < 5){
            freeActions = Math.ceil(Math.random() * 5);;
        }else{
            freeActions = Math.ceil(Math.random() * 3);;
        }

        if(goals + goalsEnemy > 5){
            freeActions = 1;
        }

        var goalsCount:uint = goals;
        var goalsEnemyCount:uint = goalsEnemy;
        var result:Boolean = false;

        var history:Array = new Array();

        do{

            var random:uint;

            if(goalsCount && goalsEnemyCount){

                random = Math.ceil(Math.random() * 3);

                switch(random){
                    case 1:

                        goalsCount -- ;
                        history.push(EVENT_ATTACK_SUCCESS);

                        break;
                    case 2:

                        goalsEnemyCount --;
                        history.push(EVENT_SOS_SUCCESS);

                        break;
                    case 3:

                        freeActions --;
                        history.push(getFreeAction());

                        break;
                }

            } else {

                if(goalsCount){

                    random = Math.ceil(Math.random() * 2);

                    switch(random){
                        case 1:

                            goalsCount -- ;
                            history.push(EVENT_ATTACK_SUCCESS);

                            break;
                        case 2:

                            freeActions --;
                            history.push(getFreeAction());

                            break;
                    }
                }else{

                    if(goalsEnemyCount){

                        random = Math.ceil(Math.random() * 2);

                        switch(random){
                            case 1:


                                goalsEnemyCount --;
                                history.push(EVENT_SOS_SUCCESS);

                                break;

                            case 2:

                                freeActions --;
                                history.push(getFreeAction());

                                break;
                        }
                        
                    }else{

                        freeActions --;
                        history.push(getFreeAction());
                    }

                }
            }

            result = Boolean((goalsCount == 0) && (goalsEnemyCount == 0) && (freeActions <= 0));

        }while(!result);

        return history; 
    }

    public function getDetails(goals:uint, goalsEnemy:uint, team:TeamProfiler, enemyTeam:TeamProfiler):Array{

        var history:Array = getChain(goals, goalsEnemy); 
        var details:Array = new Array();

        var footballerAction:Footballer = null ;

        for (var i:uint = 0; i < history.length; i++) { 
            var action:FootballEvent = getDetailsByItems(history[i], team, enemyTeam, footballerAction);
            footballerAction = action.getFootballer();
            details.push(action);
        }

        return details; 
    }

    private function getDetailsByItems(historyType:String, team:TeamProfiler, enemyTeam:TeamProfiler, footballerAction:Footballer):FootballEvent{

        var details:Array = new Array();
        var event:FootballEvent = new FootballEvent();
        var isEnemy:Boolean;

        event.setHistoryType(historyType);

        switch(historyType){

            case EVENT_ATTACK_SUCCESS:
                footballerAction = getFootballerByLineWithAlternative(team, ItemTypeStore.TYPE_FORWARD, footballerAction);
                    isEnemy = false;
                break;

            case EVENT_ATTACK_FAIL:
                footballerAction = getFootballerByLineWithAlternative(team, ItemTypeStore.TYPE_FORWARD, footballerAction);
                    isEnemy = false;
                break;

            case EVENT_SOS_SUCCESS:
                footballerAction = getFootballerByLineWithAlternative(enemyTeam, ItemTypeStore.TYPE_FORWARD, footballerAction);
                    isEnemy = true;
                break;

            case EVENT_SOS_FAIL:
                footballerAction = getFootballerByLineWithAlternative(enemyTeam, ItemTypeStore.TYPE_FORWARD, footballerAction);
                    isEnemy = true;
                break;

            case EVENT_PASS:
                footballerAction = getFootballerByLineWithAlternative(team, getRandomLine(), footballerAction);
                    isEnemy = false;
                break;

            case EVENT_PASS_ENEMY: 
                footballerAction = getFootballerByLineWithAlternative(enemyTeam, getRandomLine(), footballerAction);
                    isEnemy = true;
                break;
        }
        event.setIsEnemy(isEnemy);
        event.setFootballer(footballerAction);
        return event;
    }

    private function getRandomLine():String{

        var random:uint = Math.ceil(Math.random() * 3);

        switch(random){ 
                case 1:
                    return ItemTypeStore.TYPE_FORWARD;
                case 2:
                    return ItemTypeStore.TYPE_HALFSAFER;
                default:
                    return ItemTypeStore.TYPE_SAFER;
            }
    }


    private function getFootballerByLineWithAlternative(team:TeamProfiler, fType:String, lastActive:Footballer):Footballer{

        var activeFootballers:Array = team.getFootballers(Footballer.ACTIVEED);
        var collectionByType:Array = getFootballersByLine(team, fType, lastActive);

        if(!collectionByType.length){

            switch(fType){

                case ItemTypeStore.TYPE_FORWARD:
                    collectionByType = getFootballersByLine(team, ItemTypeStore.TYPE_HALFSAFER, lastActive);
                    break;

                case ItemTypeStore.TYPE_HALFSAFER:
                    collectionByType = getFootballersByLine(team, ItemTypeStore.TYPE_FORWARD, lastActive);
                    break;

                case ItemTypeStore.TYPE_SAFER:
                    collectionByType = getFootballersByLine(team, ItemTypeStore.TYPE_HALFSAFER, lastActive);
                    break;

                case ItemTypeStore.TYPE_GOALKEEPER:
                    collectionByType = getFootballersByLine(team, ItemTypeStore.TYPE_SAFER, lastActive);
                    break;

            }

            if(!collectionByType.length){

                for (var i:uint = 0; i < activeFootballers.length; i++) {

                    var currentF:Footballer = Footballer(activeFootballers[i]);
                    if(lastActive && currentF && lastActive.getId() == currentF.getId()){
                        continue;
                    }

                    collectionByType.push(currentF);
                }
                collectionByType = team.getFootballers(Footballer.ACTIVEED);
            }
        }

        var random:int = Math.ceil(Math.random() * collectionByType.length) - 1;
        return Footballer(collectionByType[random]);

    }


    private function getFootballersByLine(team:TeamProfiler, fType:String, lastActive:Footballer):Array{

        var activeFootballers:Array = team.getFootballers(Footballer.ACTIVEED);
        var collectionByType:Array = new Array();

        for (var i:uint = 0; i < activeFootballers.length; i++) {

            var currentF:Footballer = Footballer(activeFootballers[i]);

            if(lastActive && lastActive.getId() == currentF.getId()){
                continue;
            }

            if(currentF.getType() == fType){
                collectionByType.push(currentF);
            }
        }

        return collectionByType;
    }

    private function getFreeAction():String{


        var random:uint = Math.ceil(Math.random() * 4);
        switch(random){
            case 1:
                return EVENT_ATTACK_FAIL;
            case 2:
                return EVENT_SOS_FAIL;
            case 3:
                return EVENT_PASS;
            default:
                return EVENT_PASS_ENEMY;
        }
    }

}
}