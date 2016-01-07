package ru.kubline.interfaces.events {
import com.greensock.TweenMax;

import com.greensock.easing.Back;

import flash.display.MovieClip;

import flash.events.Event;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.EventController;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.menu.SelectLineMenu;
import ru.kubline.interfaces.menu.SettingsFootballerMenu;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.FootballEvent;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:27:55 PM
 */

public class EventItemMod extends UIComponent {
 
    private var fType:MovieClip;
    private var photoResult:MovieClip;
    private var country:MovieClip;

    private var desc:TextField;
    private var footballerName:TextField;
 
    public function EventItemMod(container:MovieClip) {

        super(container);

        desc = (TextField(container.getChildByName("desc")));
        footballerName = (TextField(container.getChildByName("footballerName")));

        fType = (MovieClip(container.getChildByName("fType")));
        country = (MovieClip(container.getChildByName("country")));
        photoResult = (MovieClip(container.getChildByName("photoResult")));

    }

    public function initData(enemyTeam:TeamProfiler, actionStory:FootballEvent, minute:uint):void{

        if(actionStory.getFootballer().getIsFriend()){
            new Gallery(photoResult, Gallery.TYPE_OUTSOURCE, actionStory.getFootballer().getPhoto());
        }else{
            new Gallery(photoResult, Gallery.TYPE_BEST, actionStory.getFootballer().getId().toString());
        }

        fType.gotoAndStop("type" + actionStory.getFootballer().getType()); 
        desc.text = actionStory.getStory();
    
       // var color:Number = 0xFFFFFF;
        var color:Number = 0xFFFF99;


        switch(actionStory.getHistoryType()){
            case EventController.EVENT_ATTACK_SUCCESS: color = 0x669900;; break;
            case EventController.EVENT_SOS_SUCCESS: color = 0xFF4D4D; break;
        }
     

        TweenMax.to(desc, 1, {colorTransform:{tint:color, tintAmount:1, exposure:2, brightness:1.4, redMultiplier:1 }, ease:Back.easeOut});

        footballerName.text = actionStory.getFootballer().getFootballerName();
        country.gotoAndStop("country" + actionStory.getFootballer().getCountryCode());
    }

    override public function destroy():void{
        super.destroy();
    }

     
    
}
}