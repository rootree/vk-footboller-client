package ru.kubline.controllers {
import flash.media.Sound;
import flash.media.SoundChannel;

import flash.media.SoundMixer;

import flash.media.SoundTransform;

import ru.kubline.core.Cookie;
import ru.kubline.loader.ClassLoader;


public class SoundController {

    private static var soundTurn:Boolean = true;

    private static var soundStore:Object;

    public static const PLAY_BG:String = "BGSound";
    public static const PLAY_MENU_ENTER:String = "ButtonClick";
    public static const PLAY_MENU_OVER:String = "MouseOver";
    public static const PLAY_MENU_CLOSE:String = "CloseWindow";
    public static const PLAY_START:String = "CrowdAmbience";
    public static const PLAY_WIN:String = "PlayerWin";
    public static const PLAY_LOSE:String = "PlayerLoose";
    public static const PLAY_LEVEL:String = "LevelUp";

    private static const REPEAT_COUNT:uint = 999;

    private var bgChanel:SoundChannel;

    private var trans:SoundTransform;

    public function SoundController() {
 
        trans = new SoundTransform(0.4, 0); 
        trans.volume = 0.4;
        
        soundStore = new Array();
        bgChanel = new SoundChannel();
        bgChanel = play(SoundController.PLAY_BG, true);

        if(trans && bgChanel){
            bgChanel.soundTransform = trans;
        }
        
        if(!Cookie.getBooleanValue("soundPower")){
            swichOnOff();
        };
    }

    public function turnOff():void {
        soundTurn = false;
    }

    public function turnOn():void {
        soundTurn = true;
    }

    public function swichOnOff():void {
        soundTurn = !soundTurn;
        if(soundTurn){

            bgChanel = play(SoundController.PLAY_BG, true);
            if(trans && bgChanel){
                bgChanel.soundTransform = trans;
            }
            Cookie.setValue("soundPower", true, true);
        }else{
            if(bgChanel){
                bgChanel.stop();
            }
            flash.media.SoundMixer.stopAll();
            Cookie.setValue("soundPower", false, true);
        }
    }

    public function play(sound:String, infinity:Boolean = false):SoundChannel {
        if(soundTurn){
            if(!soundStore[sound]){
                soundStore[sound] = ClassLoader.getNewSoundInstance(sound);
            }
            return Sound(soundStore[sound]).play(0, (infinity) ? REPEAT_COUNT : 0);
        }else{
            return new SoundChannel();
        }
    }

    public function isTurtOn():Boolean{
        return soundTurn;
    }

}
}