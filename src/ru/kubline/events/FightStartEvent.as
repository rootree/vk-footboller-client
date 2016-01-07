package ru.kubline.events {
import flash.events.Event;

public class FightStartEvent extends Event{

    public static const START:String = "groupFightStart";

    private var stepObject:Object;

    public function FightStartEvent(stepObject:Object) {
        super(FightStartEvent.START);
        this.stepObject = stepObject;
    }

    public function getFightStep():Object{
        return stepObject; 
    }
}
}