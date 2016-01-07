package ru.kubline.social.events {
import flash.events.Event;

public class LoadBalanceEvent extends Event {

    public static const LOAD_USER_BALANCE:String = "LOAD_USER_BALANCE";

    public var balance:uint;
    public var success:Boolean;

    public function LoadBalanceEvent(success:Boolean, balance:uint = 0) {
        super(LOAD_USER_BALANCE);
        this.balance = balance;
        this.success = success;
    }
}
}