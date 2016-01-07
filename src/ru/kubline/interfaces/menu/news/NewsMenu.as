package ru.kubline.interfaces.menu.news {
import ru.kubline.interfaces.menu.sponsors.*;

import com.adobe.serialization.json.JSON;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;

import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

import flash.utils.ByteArray;

import mx.utils.ObjectUtil;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.display.SimpleSponsor;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.model.News;
import ru.kubline.model.Sponsor;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.net.Server;
import ru.kubline.utils.ObjectUtils;

public class NewsMenu extends UIPagingMenu{

    private const LIMIT_LENGTH_TITLE:uint = 180;
    private const LIMIT_LENGTH_TEXT:uint = 570;

    private var log:Logger = new Logger(SponsorMenu);

    private var closeBtn:UISimpleButton;
    private var saveBtn:UISimpleButton;

    private var titleNewsText:TextField;
    private var newsText:TextField;

    private var newsImage:MovieClip;

    public function NewsMenu() {
 
        super(ClassLoader.getNewInstance(Classes.PANEL_NEWS));
 
    }

    override protected function initComponent():void{
        super.initComponent();

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        titleNewsText = TextField(container.getChildByName("titleNewsText"));
        newsText = TextField(container.getChildByName("newsText"));

        newsImage = MovieClip(container.getChildByName("newsImage"));
 
    }

    override public function destroy():void{

        super.destroy(); 
        closeBtn.removeHandler(onCloseClick);

        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        }
    }

    
    override public function show():void{

        var ar:Array = NewsStore.getNewsStoreAsArray();
 
        setData(ar);
        setPage(1);

        super.show();

        hideNavigationButtons() ;
        getSelectedMenuItem().dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));

    }
 
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:NewsItem = new NewsItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return logoItem;
    }
 
    private function onItemClick(e:Event):void {

        var item:UIMenuItem = UIMenuItem(e.target);

        if(item.isDisabled()){
            return;
        }
 
        var itemRecord:News = News(item.getItem());

        if(itemRecord != null){

            titleNewsText.text = UserProfileHelper.trim(itemRecord.subTitle, LIMIT_LENGTH_TITLE);
            newsText.text = UserProfileHelper.trim(itemRecord.content, LIMIT_LENGTH_TEXT);

            var path:String = "http://" + Server.STATIC.getHost() + "/" + Server.STATIC.getDirectories() +"NEWS/"; 
            new Gallery(newsImage, Gallery.TYPE_OUTSOURCE, path + itemRecord.image + ".jpg");

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