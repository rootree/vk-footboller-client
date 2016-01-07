package ru.kubline.gui.controls.menu {
import com.greensock.TweenMax;

import flash.display.MovieClip;
import flash.events.MouseEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.gui.controls.PagingStore;
import ru.kubline.gui.controls.button.UIButton;

/**
 * базовый класс для многостраничного меню
 */
public class UIPagingMenu extends UIMenu {

    protected var store:PagingStore;

    protected var next:UIButton;

    protected var prev:UIButton;

    public function UIPagingMenu(container:MovieClip) {
        super(container);
        next = new UIButton(MovieClip(container.getChildByName("next")));
        next.addHandler(onNextClick); 
        prev = new UIButton(MovieClip(container.getChildByName("prev")));
        prev.addHandler(onPrevClick);
    }


    override public function show():void {
        setPage(1);
        super.show();
    }

    private function onNextClick(event:MouseEvent):void {
        Singletons.sound.play(SoundController.PLAY_MENU_ENTER);
        setPage(store.getPage() + 1);
    }

    private function onPrevClick(event:MouseEvent):void {
        Singletons.sound.play(SoundController.PLAY_MENU_ENTER);
        setPage(store.getPage() - 1);
    }

    /**
     * засетить массив данных для меню
     * @param data
     */
    public function setData(data:Array):void {

        this.store = new PagingStore(data, cellsContainer.numChildren);

        //        showLoading(false);
    }

    public function getData():PagingStore {
        return this.store;
    }

    public function setPage(page:int):void {
        store.setPage(page);
        store.loadCurPageData(drawCells);
        updateNavigationButtons();
    }

    private function updateNavigationButtons():void {
        prev.setDisabled(store.isFirstPage());
        next.setDisabled(store.isLastPage());
    }

    protected function hideNavigationButtons(yes:Boolean = true):void {
        prev.setVisible(!yes);
        next.setVisible(!yes);
    }

    protected function drawCells(data:Array):void {
        clearSelection();
        var firstSelected:Boolean;

        for (var i:int; i < store.getPageSize(); i++) {
           var cell:IUIMenuItem = IUIMenuItem(cells[i]);
            initCell(cell, i < data.length?data[i]:null);
            if(!firstSelected && !cell.isDisabled() && cell.isSelectable() ){
                setSelectedItem(cell);
                firstSelected = true;
            }
        }
    }

    /**
     * инициализирует менюшку данными
     * @param cell
     * @param item
     */
    protected function initCell(cell:IUIMenuItem, item:Object):void {
        cell.setItem(item);
    }


    override public function destroy():void {
        next.removeHandler(onNextClick);
        prev.removeHandler(onPrevClick);
        super.destroy();
    }
}
}