package ru.kubline.interfaces.window.message {
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.controllers.WallController;
import ru.kubline.events.GallaryEvent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:43:59 PM
 */

public class TourMessage extends MessageBox{
 
    public function TourMessage(title:String, message:String, buttons:int, callback:Function = null) { 
        super(title, message, buttons, callback, Classes.MSG_BOX_TOUR_FIGHT);
    }


}
}