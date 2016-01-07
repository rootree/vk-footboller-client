package ru.kubline.interfaces.window.tour {
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
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.tour.PrizeType;
import ru.kubline.loader.tour.TourNotifyType;
import ru.kubline.utils.MessageUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:43:59 PM
 */

public class TourEventWindow extends UIWindow{

    private var okBtn:UISimpleButton;
    private var resultsBtn:UIButton;

    // Панель резильтатов
    private var tourResultPanel:TourResultPanel;
    
    // Панель обьявления нового чемпионата
    private var newTour:NewTourPanel;

    // Панель что идёт текуший чемпионат
    private var tourInProgress:TourInProgressPanel;

    public function TourEventWindow() {
        super(ClassLoader.getNewInstance(Classes.MSG_BOX_TOUR));
 
        tourResultPanel = new TourResultPanel(MovieClip(container.getChildByName("tourResult")));
        newTour = new NewTourPanel(MovieClip(container.getChildByName("newTour")));
        tourInProgress = new TourInProgressPanel(MovieClip(container.getChildByName("tourInProgress"))); 
    }

    private function onBragClick(e:Event):void{
        hide();
    }

    private function onGetResultsClick(e:Event):void{
        tourResultPanel.setVisible(true);
        newTour.setVisible(false);
        resultsBtn.setDisabled(true);
    }

    override protected function initComponent():void{
        super.initComponent();

        okBtn = new UISimpleButton(SimpleButton(getChildByName("ok")));
        okBtn.addHandler(onBragClick);

        resultsBtn = new UIButton(MovieClip(getChildByName("resultsBtn")));
        resultsBtn.addHandler(onGetResultsClick);

        tourResultPanel.setVisible(false);
        tourInProgress.setVisible(false);
        newTour.setVisible(false);
        resultsBtn.setVisible(false);
 
        // Чемпионат идёт
        if(Application.teamProfiler.isNewTour()){
            newTour.setVisible(true);
            resultsBtn.setVisible(true);   
        }else{

            // Чемпионат идёт
            tourInProgress.setVisible(true);

            if((Application.teamProfiler.getPrizeMode() == PrizeType.PRIZE_MODE_ACTIVATED ) ){
                tourResultPanel.setVisible(true);
            }
        }
   
    }

    override public function destroy():void{
        super.destroy();
        okBtn.removeHandler(onBragClick);
        resultsBtn.removeHandler(onGetResultsClick); 
    }

    public function showPreviusTour():void{

        show();
        onGetResultsClick(new Event("E"));

    }

}
}