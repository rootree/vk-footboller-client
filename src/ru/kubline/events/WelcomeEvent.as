package ru.kubline.events {
import flash.events.Event;

public class WelcomeEvent extends Event{

    public static const ABLE_TO_PROCEED:String = "able";
    public static const UNABLE_TO_PROCEED:String = "disable";
    public static const FINISH:String = "finish";

    public function WelcomeEvent() {
        super(ABLE_TO_PROCEED);
    }
}
}