package ru.kubline.loader {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.PixelSnapping;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;

import flash.utils.Timer;

import mx.preloaders.DownloadProgressBar;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.GallaryEvent;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.Server;

public class Gallery extends EventDispatcher{


    /**
     * create logger instance
     */
    private var log:Logger = new Logger(Application);

    public static const TYPE_FOOTBALLER:String = "FOOTBALLER";
    public static const TYPE_TEAM:String = "TEAM";
    public static const TYPE_SPONSOR:String = "SPONSOR";
    public static const TYPE_STADIUM:String = "STADIUM";
    public static const TYPE_BEST:String = "BEST";

    public static const TYPE_OUTSOURCE:String = "OUTSOURCE";
    public static const TYPE_OTHER:String = "OTHER";

    public static const BEST_FOOTBALLER:String = "_best";

    public static const RESULT_TIE:String = "tie";
    public static const RESULT_LOST:String = "lost";
    public static const RESULT_WIN:String = "win";
    public static const RESULT_APP:String = "footballer";

    public static const BAD_LOAD:String = "badPlayer";
    public static const ADD_PLAYER:String = "addPlayer";

    private static var store:Object = new Object();

    private var loader:Loader = new Loader();

    private var container:MovieClip;

    private var galleryType:String;

    private var id:String;

    private var HZname:Boolean;

    private var loading:MovieClip;

    public function Gallery(container:MovieClip, galleryType:String, id:String, HZname:Boolean = false) {

        log.debug("[Gallary]: " + id + ". Try to load type: " + galleryType + " and ID:" + id);

        if(!container || !id){
            return;
        }

        this.HZname = HZname;
        this.container = container;
        this.galleryType = galleryType;
        this.id = id;
        if(!store[galleryType]){
            store[galleryType] = new Array();
        }

        if(store[galleryType][id]){
            this.addChild();
            log.debug("Content already loaded");
            //trace(id);
        }else{
            var path:String;
            // Loading
            if(galleryType == Gallery.TYPE_OUTSOURCE){
                if(Application.VKIsEnabled){
                    path = id;
                }else{
                    path = "http://" + Server.STATIC.getHost() + "/" + Server.STATIC.getDirectories() +"OTHER/3000.jpg";
                }
            }else{
                if(parseInt(id) % 2 != 0){
                    path = "http://" + Server.STATIC.getHost() + "/" + Server.STATIC.getDirectories() + galleryType + "/" + id + ".jpg";
                }else{
                    path = "http://" + Server.STATIC_SECOND.getHost() + "/" + Server.STATIC_SECOND.getDirectories() + galleryType + "/" + id + ".jpg";                    
                }
            }
            log.debug("[Gallary]: " + id + ". Loading: " + path);
            loadBinaryJPG(path);
        }
    }

    public function loadBinaryJPG(path:String):void {

        loading = MovieClip(container.getChildByName("loading"));

        if(loading){
            loading.visible = true;
            loading.play();
            container.setChildIndex(loading, (container.numChildren - 1));
        }

        rem();

        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadInit);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ioSeccHandler);
        var urlRequest:URLRequest = new URLRequest(path);
        // set the dataFormat to binary

        loader.load(urlRequest, Singletons.context.getLoaderContext());

    }

    private function onLoadInit(e:Event):void{
        eraser();
        //Save the loaded bitmap to a local variable
        var image:Bitmap = (Bitmap)(e.target.content);
        store[galleryType][id] = image;
        this.addChild();
        log.debug("[Gallary]: " + id + ". Load completed");

        dispatchEvent(new GallaryEvent());
    }

    private function rem():void{

        for (var i:int; i < container.numChildren; i++) {
            if(container.getChildAt(i) is Bitmap){
                container.removeChild(container.getChildAt(i));
            }
        }
    }

    private function addChild():void{

        if(loading){
            loading.visible = false;
            loading.stop();
        }

        rem();
        var temp:Bitmap;

        temp = new Bitmap(store[galleryType][id].bitmapData);
        temp.name = 'loadedJPG';
        InterfaceUtils.scaleIcon(temp, container.width, container.width, HZname);
        temp.smoothing = true;
        temp.cacheAsBitmap = true;

        container.addChild(temp);

    }

    private function ioSeccHandler(event:Event):void {
        log.error("[Gallary]: " + id + ". Can not load content ( SecurityErrorEvent ");
        haveError();
    }


    private function ioErrorHandler(event:Event):void {
        log.error("[Gallary]: " + id + ". Can not load content ( IOErrorEvent ");
        haveError();
    }

    private function haveError():void{
        eraser();
        rem();
        var defaultPhoto:MovieClip = ClassLoader.getNewInstance(Classes.QUESTION);
        container.addChild(defaultPhoto);
        InterfaceUtils.alignByParentCenter(defaultPhoto);
    }

    private function eraser():void{

        if(loading){
            loading.visible = false;
            loading.stop();
        }
 
        loader.removeEventListener(Event.COMPLETE, onLoadInit);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ioSeccHandler);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

    static public function getFromStore(galleryType:String, id:String):BitmapData{
        if(store[galleryType][id]){
            return Bitmap(store[galleryType][id]).bitmapData;
        }else{
            return new BitmapData(100,100);
        }
    }
 
}
}