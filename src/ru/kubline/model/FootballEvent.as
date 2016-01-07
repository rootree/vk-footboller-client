package ru.kubline.model {
import ru.kubline.controllers.EventController;
import ru.kubline.utils.MessageUtils;

public class FootballEvent {

    private var historyType:String;

    private var footballer:Footballer;

    private var isEnemy:Boolean;

    public function FootballEvent() {

    }

    public function getHistoryType():String {
        return historyType;
    }

    public function setHistoryType(value:String):void {
        historyType = value;
    }

    public function getFootballer():Footballer {
        return footballer;
    }

    public function setFootballer(value:Footballer):void {
        footballer = value;
    }

    public function getStory():String {

        var storyText:String = footballer.getFootballerName();
        var story:Array = new Array();

        switch(historyType){

            case EventController.EVENT_ATTACK_SUCCESS:

                story.push("внезапно проводит контр.атаку, обходит защиту соперника и забивает триумфальный гол!");
                story.push("делает тактически верное решение и забивает гол!");
                story.push("выходит один на один с вратарем, обходит его, гол!");
                story.push("обыгрывает защиту соперника и точным ударом по воротам забивает гол!");
                story.push("получив мяч с центра поля, буквально закатывает его в ворота, гол!");
                story.push("разыграв мяч, прорывается к воротам и забивает гол!");
                story.push("проходит по левому флангу, бьет по воротам и забивает гол!");
                story.push("проходит по правому флангу, бьет по воротам и забивает гол!");

                break;

            case EventController.EVENT_ATTACK_FAIL:

                story.push("выходит один на один с вратарем соперника, но неудача, теряет мяч");
                story.push("пытается провести контр.атаку, но защита соперника не дремлет");
                story.push("пытаясь разыграть мяч, делает ошибку, мяч переходит к сопернику");
                story.push("проходит по левому флангу, обыгрывает защиту соперника");
                story.push("проходит по правому флангу");
                break;

            case EventController.EVENT_SOS_SUCCESS:

                story.push("успешно обходит вашу защиту и забивает вам гол");
                story.push("проходит по левому флангу, обходит защиту и забивает гол");
                story.push("проходит по правому флангу, прорывается сквозь защиту, обходит вратаря и забивает гол");
                story.push("обходит защитников один за одним и забивает гол");
                story.push("разыграв мяч, обходит вашу защиту и оказывается возле ворот, бьет! гол в ваши ворота");
                break;

            case EventController.EVENT_SOS_FAIL:

                story.push("пытаясь обойти вашу защиту, упускает мяч");
                story.push("проходит по левому флангу, встречает вашу защиту и теряет мяч");
                story.push("проходит по правому флангу, но не успев сделать пас теряет мяч");
                story.push("проходит по центру, оказывается в окружении вашей защиты и теряет мяч");
                break;

            case EventController.EVENT_PASS:
            case EventController.EVENT_PASS_ENEMY:

                story.push("производит распасовку");
                story.push("отходит ближе к вашим воротам");
                story.push("подкрадывается к воротам соперника");
                story.push("передает пас на другую сторону поля");
                story.push("пытается обойти полузащиту");
                break;
 

        }

        storyText += " " + story[Math.floor(Math.random()*story.length)];

        return storyText;

    }

    public function getIsEnemy():Boolean {
        return isEnemy;
    }

    public function setIsEnemy(value:Boolean):void {
        isEnemy = value;
    }
}
}