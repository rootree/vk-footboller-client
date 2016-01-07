package ru.kubline.gui.controls {

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.kubline.gui.controls.hint.Hintable;

/**
 * базовый класс всех компонент
 */
public class UIComponent extends EventDispatcher implements IUIComponent {

    /**
     * флаг выполненно ли инициализирование содержимого(метод initComponent)
     */
    protected var init:Boolean;

    /**
     * если true то метод destroy вызовется после удаления объекта со сцены
     */
    public var destroyOnRemove:Boolean = true;
    
    /**
     * html текст для подсказки
     */
    private var qtip:String;

    /**
     * интсанс класса из swf 
     */
    protected var container:DisplayObjectContainer;

    public var disabled:Boolean;

    /**
     * ссылка на объект из swf который надо показать если компонент задизаблен
     */
    private var disabledObj:DisplayObject;

    private var qtipHintable:Hintable;

    /**
     *
     * @param container  - инстанс из swf
     */
    public function UIComponent(container:DisplayObjectContainer) {
        super();
        this.container = container;

        if(container){
            this.disabledObj = container.getChildByName("disabled");
            if (disabledObj) {
                setDisabled(false);
            }

            container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            container.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
         

    }

    public function getChildByName(name:String):DisplayObject {
        return container.getChildByName(name);
    }

    /**
     * возможно вся работа с контейнером должна быть внутри класса и от этого метода нужно будет отказаться 
     * @return
     */
    public function getContainer():DisplayObjectContainer {
        return container;
    }

    public function setDisabled(disabled:Boolean):void {
        this.disabled = disabled;
        this.container.mouseEnabled = !disabled;
        if (disabledObj) {
            disabledObj.visible = disabled;
        }
    }

    public function isDisabled():Boolean {
        return this.disabled;
    }

    public function isVisible():Boolean {
        return container.visible;
    }

    public function setVisible(visible:Boolean):void {
        container.visible = visible;
    }

    private function onAddedToStage(event:Event):void {
        if (!init) {
            initComponent();
            init = true;
        }
    }

    private function onRemovedFromStage(event:Event):void {
        if (destroyOnRemove) {
            destroy();
        }
    }

    public function destroy():void {
        if (qtipHintable) {
            qtipHintable.removeHintProvider();
            qtipHintable = null;
        }
        init = false;
    }

    public function setQtip(value:String):void {
        qtip = value;
        if (!qtipHintable) {
            qtipHintable = new Hintable(container);
        } else {
            qtipHintable.removeHintProvider();
        }

        if (qtip) {
            qtipHintable.setHintProvider(new Qtip(qtip));
        }
    }

    public function setQtipValue(value:String):void {
        destroyHint();
        setQtip(value);
    }

    public function destroyHint():void {
        if (Application.instance.contains(qtipHintable.hintProvider.getHint())) {
            Application.instance.removeChild(qtipHintable.hintProvider.getHint());
        } 
    }
 
    public function addChild(ch:UIComponent):void {
        container.addChild(ch.getContainer());
    }

    public function removeChild(ch:UIComponent):void {
        container.removeChild(ch.getContainer());
    }

    protected function _addChild(ch:DisplayObject):void {
        container.addChild(ch);
    }

    protected function _removeChild(ch:DisplayObject):void {
        container.removeChild(ch);
    }

    /**
     * в этом методе должна происходить инициализация контента,
     * выставление размеров, расположение и т.д...
     *
     */
    protected function initComponent():void {
    }
}
}