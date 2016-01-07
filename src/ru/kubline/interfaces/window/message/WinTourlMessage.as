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
import ru.kubline.loader.tour.TourType;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:43:59 PM
 */

public class WinTourlMessage extends UIWindow{

    private var bragBtn:UISimpleButton;

    private var img:Gallery;;

    private var tourType:TextField;
    private var tourPlace:TextField;
    private var discountText:TextField;
    private var discountTotalText:TextField;
    private var totalBonus:TextField;

    private var cupPlace:MovieClip;
    private var type:uint;

    public function WinTourlMessage() {
        super(ClassLoader.getNewInstance(Classes.WIN_TOUR_MESSAGE));
        

    }

    override protected function initComponent():void {
        tourType = TextField(getContainer().getChildByName("tourType"));
        tourPlace = TextField(getContainer().getChildByName("tourPlace"));
        discountText = TextField(getContainer().getChildByName("discountText"));
        discountTotalText = TextField(getContainer().getChildByName("discountTotalText"));
        totalBonus = TextField(getContainer().getChildByName("totalBonus"));
 
        cupPlace = MovieClip(getChildByName("cupPlace"));

        bragBtn = new UISimpleButton(SimpleButton(getChildByName("bragBtn")));
        bragBtn.addHandler(onBragClick);
    }

    public function showMSG(type:uint, discount:Number, totalDiscount:Number):void{
        super.show();
        this.type = type;
        switch (type){
            case TourType.TOUR_TYPE_CITY :
                tourType.text = "Города";
                tourPlace.text = Application.teamProfiler.getTourPlaceCity().toString();
                break;
            case TourType.TOUR_TYPE_COUNTRY :
                tourType.text = "Страны";
                tourPlace.text = Application.teamProfiler.getTourPlaceCountry().toString();
                break;
            case TourType.TOUR_TYPE_UNI :
                tourType.text = "ВУЗа";
                tourPlace.text = Application.teamProfiler.getTourPlaceUniversity().toString();
                break;
            case TourType.TOUR_TYPE_VK :
                tourType.text = "ВКонтакта";
                tourPlace.text = Application.teamProfiler.getTourPlaceVK().toString();
                break;
        }

        discountText.text = ( Math.floor(( 1 - totalDiscount ) * 100) ).toString() + "%";
        discountTotalText.text = ( Math.floor(( 1 - discount ) * 100) ).toString() + "%";

        totalBonus.visible = !(discount == totalDiscount);
        discountTotalText.visible = !(discount == totalDiscount);

        cupPlace.gotoAndStop("place" + parseInt(tourPlace.text));

    }

    override public function destroy():void{
        bragBtn.removeHandler(onBragClick);
        super.destroy();
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
                MessageUtils.wordBySex(Application.teamProfiler, "Я победитель!", "Я лучше всех!")+
                " В чемпионате " + tourType.text +
                MessageUtils.wordBySex(Application.teamProfiler, " я занял ", " я заняла ") + 
                tourPlace.text + "-е место.",
                "Расскажите всем, каких успехов вы добились!")
                .start();
    }
}
}