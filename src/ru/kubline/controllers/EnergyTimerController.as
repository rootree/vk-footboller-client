package ru.kubline.controllers {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ServerTime;

public class EnergyTimerController {

    private static var log:Logger = new Logger(EnergyTimerController);

    public static const ENERGY_PLUS_IN:uint = 10; // minutes

    private var timer:Timer;

    public function EnergyTimerController() {
        timer = createTimer();
        timer.addEventListener(TimerEvent.TIMER, onTimer);
    }

    public function start():void{
        timer.start();
    }

    private function onTimer(e:TimerEvent):void{
        timer.stop();
        timer = null;

        var addOnEnergy:uint = 16;
        var currentEnergy:uint = Application.teamProfiler.getEnergy() + addOnEnergy;

        var deltaTime:Number = ServerTime.getDeltaTime()   ;
        Application.teamProfiler.setEnergyTimer(Math.round(new Date().time / 1000) + deltaTime);

        Application.teamProfiler.setEnergy(currentEnergy);
        Application.mainMenu.userPanel.update();

        timer = createTimer();
        timer.start();

  /*    Singletons.loadingMsg.start("Получение дополнительной энергии");
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_UPDATE_ENERGY, weGotThePower);
        Singletons.connection.send(HTTPConnection.COMMAND_UPDATE_ENERGY, {});       */

    }
 

    public static function getEnergyEnharseTime():Object{

        var deltaTime:Number = ServerTime.getDeltaTime()   ;
        var energyTime:Number = Application.teamProfiler.getEnergyTimer() + deltaTime;
        var currentTime:Number = ServerTime.getCurrentTime();

        if(currentTime < energyTime){
            currentTime += 60 * ENERGY_PLUS_IN - 1;
        }

        log.debug("energyTime - " + energyTime);
        log.debug("deltaTime - " + deltaTime);
        log.debug("currentTime - " + currentTime);

        var raznico:int = Math.abs(currentTime - energyTime );    // Разница в секундах когда последний раз энергию пополняли
        var min:int;
        min = ENERGY_PLUS_IN - Math.floor(raznico / 60); // До следущего пополнения осталось в минутах

        log.debug("raznico - " + raznico);
        log.debug("min - " + min);
        
        var sec:int = 60 - raznico % 60;                         // До следущего пополнения осталось в секундах

        log.debug("sec - " + sec);

        if(min > ENERGY_PLUS_IN){ // если минут получилось много то приравниваем к интервалу обновления энергии
            min = ENERGY_PLUS_IN;
        }

        return {min: min, sec: sec};
    }

    private function createTimer():Timer{ 
        var delayObj:Object = EnergyTimerController.getEnergyEnharseTime();
        var delay:uint = delayObj.min * 60 + delayObj.sec;
        return new Timer(delay * 1000);
    }
}
}