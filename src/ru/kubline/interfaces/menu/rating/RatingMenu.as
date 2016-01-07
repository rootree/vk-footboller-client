package ru.kubline.interfaces.menu.rating {
import ru.kubline.interfaces.menu.sponsors.*;
 
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent; 
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.TeamProfiler;

public class RatingMenu extends UIPagingMenu{

    private var log:Logger = new Logger(SponsorMenu);

    public var sponsorCount:uint = 0;

    private var firstSponsor:SingleSponsor;
    private var secondSponsor:SingleSponsor;
    private var thirdSponsor:SingleSponsor;
 
    private var userSponsor:Array;
    private var userVisibleSponsor:Array;

    private var isLogoSelected:Boolean;
 
    public static var tempStorage:Object = new Object();

    private var closeBtn:UISimpleButton;
    private var saveBtn:UISimpleButton;

    public function RatingMenu() { 
        super(ClassLoader.getNewInstance(Classes.PANEL_RATING)); 
    }

    override protected function initComponent():void{
        super.initComponent();

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

    }

    override public function destroy():void{

        super.destroy();

        closeBtn.removeHandler(onCloseClick);

        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        }

    }

    override public function show():void{

        var ar:Array = RatingStore.getRatindStoreAsArray();
                
        hideNavigationButtons() ;

        RatingStore.sort(ar);

        setData(ar);
        setPage(1);

        super.show();
    }


    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:RatingItem = new RatingItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return logoItem;
    }
 
    private function onItemClick(e:Event):void {

        var item:UIMenuItem = UIMenuItem(e.target);
        if(item.isDisabled()){
            return;
        }
 
        var itemRecord:TeamProfiler = TeamProfiler(item.getItem()); 
        if(itemRecord != null){ 
            item.setDisabled(true); 
        }
    }

    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }
}
}