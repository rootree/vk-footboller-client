package ru.kubline.gui.controls {
import com.greensock.TweenLite;
import com.greensock.TweenMax;

import com.greensock.easing.Bounce;
import com.greensock.easing.Circ;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.gui.controls.button.ButtonFactory;
import ru.kubline.gui.controls.button.IUIButton;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;

/**
 * базовый класс окна
 */
public class UIWindow extends UIComponent {

    /**
     * подложка чтоб задизаблить все кроме меню
     */
    protected var bgPanel:Sprite;

    /**
     * имя кнопки 'крестика' по которому закрывается окно(кнопка не обязательна)
     */
    protected var closeButtonName:String = "close";

    /**
     * имя мувика загрузки(мувик не обязателен)
     */
    protected var loadingName:String = "loading";

    /**
     * мувик загрузки
     */
    private var loading:MovieClip;

    /**
     * крестик закрыть окно
     */
    private var closeBtn:IUIButton;

    /**
     *  окно октрыто
     */
    protected var shown:Boolean;

    public function UIWindow(container:Sprite) { 
        super(container);
    }

    override protected function initComponent():void {
        super.initComponent();
        closeBtn = ButtonFactory.createButton(getChildByName(closeButtonName));
        loading = getChildByName("loading") as MovieClip;

        if (closeBtn) {
            closeBtn.addHandler(onCloseClick);
        }
    }

    /**
     * окно открыто/видимо
     * @return
     */
    public function isShown():Boolean {
        return shown;
    }

    /**
     * Устанавливаем открыто/видимо
     */
    protected function setShown(shown:Boolean):void {
        this.shown = shown;
    }

    /**
     * открыть окно
     */
    public function show():void {
        shown = true;
        if (!bgPanel) {
            bgPanel = new Sprite();
            bgPanel.graphics.beginFill(0x888888, 0.5);
            bgPanel.graphics.drawRect(0, 0, Application.stageWidth, Application.stageHeight);
        }

        TweenMax.from(bgPanel, 0.5, {alpha:0,delay:0.4});
      //  TweenMax.from(this.getContainer(), 0.4, {alpha:0.5});

        Application.instance.addChild(bgPanel);

        InterfaceUtils.alignByScreenCenter(getContainer());
        var centerX:int = getContainer().x;
        var centerY:int = getContainer().y;
        Application.instance.addChild(getContainer());
        dispatchEvent(new Event(UIEvent.WINDOW_SHOW));
    }

    /**
     * закрыть
     */
    public function hide():void {
        shown = false;
 
        if (bgPanel != null && Application.instance.contains(bgPanel)) {
            Application.instance.removeChild(bgPanel);
        }

        if ( Application.instance.contains(getContainer())) {
            Application.instance.removeChild(getContainer());
        }

        Singletons.sound.play(SoundController.PLAY_MENU_CLOSE);
  //      TweenMax.to(bgPanel, 0.3, {alpha:0});
    //      TweenMax.to(this.getContainer(), 1, {alpha:0, onComplete: hideByTweener});
    }

    protected function hideByTweener():void {
        if ( Application.instance.contains(getContainer())) {
            Application.instance.removeChild(getContainer());
        }
        getContainer().alpha = 1;
        if(bgPanel){
            bgPanel.alpha = 1;
        }
        TweenMax.killTweensOf(bgPanel);
        TweenMax.killTweensOf(this.getContainer());
    //    bgPanel.filters = [];
     //    this.getContainer().filters = [];
        dispatchEvent(new Event(UIEvent.WINDOW_CLOSE));
    }

    protected function onCloseClick(event:MouseEvent):void {
        hide();
    }

    /**
     * показать мувик загрузки
     * @param show
     */
    public function showLoading(show:Boolean):void {
        if (loading) {
            if (show && !container.contains(loading)) {
                _addChild(loading);
                InterfaceUtils.alignByParentCenter(loading);
            } else if (!show && container.contains(loading)) {
                _removeChild(loading);
            }
        }
    }

}
}