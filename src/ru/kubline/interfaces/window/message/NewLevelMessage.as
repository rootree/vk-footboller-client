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

public class NewLevelMessage extends UIWindow{

    private var bragBtn:UISimpleButton;

    private var img:Gallery;;

    public function NewLevelMessage(stadyPoint:uint) {
        super(ClassLoader.getNewInstance(Classes.MSG_BOX_NEW_LEVEL));
        TextField(getContainer().getChildByName("stadyPoint")).text = stadyPoint.toString();

        bragBtn = new UISimpleButton(SimpleButton(getChildByName("bragBtn")));
        bragBtn.addHandler(onBragClick);
    }
 
    private function onBragClick(e:Event):void{

        img = new Gallery(new MovieClip(), Gallery.TYPE_OTHER, Gallery.RESULT_WIN);
        img.addEventListener(GallaryEvent.EVENT_IMAGE_LOADED, onImageForPostLoaded);

    }

    private function onImageForPostLoaded(e:GallaryEvent):void{
 
        Singletons.sound.play(SoundController.PLAY_LEVEL);

        img.removeEventListener(GallaryEvent.EVENT_IMAGE_LOADED, onImageForPostLoaded);

        var uploadImage:BitmapData;
        uploadImage = Gallery.getFromStore(Gallery.TYPE_OTHER, Gallery.RESULT_WIN);
 
        new WallController(uploadImage, Application.teamProfiler.getSocialUserId(),
                MessageUtils.wordBySex(Application.teamProfiler, "Я молодец!", "Я умничка!")+
                " В игре «Футболлер» я теперь на " + Application.teamProfiler.getLevel() + "-м уровне.",
                "Расскажите всем, каких успехов вы добились!")
                .start();
    }
}
}