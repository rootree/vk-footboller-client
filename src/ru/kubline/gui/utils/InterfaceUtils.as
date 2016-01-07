package ru.kubline.gui.utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

public class InterfaceUtils {

   /**
     * выровнять объект по центру относительно сцены
     */
    public static function alignByScreenCenter(obj:DisplayObject): void {
        alignCenter(obj, Application.stageWidth, Application.stageHeight);
    }

    /**
     * выровнять объект по центру относительно родительского контейнера
     */
    public static function alignByParentCenter(obj:DisplayObject): void {
        alignCenter(obj, obj.parent.width, obj.parent.height);


    }

    public static function scaleByMinSize(container:DisplayObject, obj:DisplayObject): void {
        if (obj.width / obj.height > container.width / container.height)
        {
            obj.height = container.height;
            obj.scaleX = obj.scaleY;
        }

        else
        {
            obj.width = container.width;
            obj.scaleY = obj.scaleX;
        }
    }

    public static function scaleByMaxSize(container:DisplayObject, obj:DisplayObject): void {
        if (obj.width / obj.height > container.width / container.height)
        {
            obj.width = container.width;
            obj.scaleY = obj.scaleX;
        }

        else
        {
            obj.height = container.height;
            obj.scaleX = obj.scaleY;
        }
    }

    /**
     * выровнять объект по центру по Y относительно заданных координат
     * !!!y2 > y1
     */
    public static function centerY(obj:DisplayObject, y1:int, y2:int): void {
        obj.y = (y1 + y2 - obj.height) / 2;
    }

    /**
     * выровнять объект по центру по X относительно заданных координат
     * !!!x2 > x1
     */
    public static function centerX(obj:DisplayObject, x1:int, x2:int): void {
        obj.x = (x1 + x2 - obj.width) / 2;
    }

    /**
     * выровнять объект по центру относительно заданных координат
     * !!!x2 > x1, y2 > y1
     */
    public static function alignCenterByRect(obj:DisplayObject, x1:int, y1:int, x2:int, y2:int): void {
        centerX(obj, x1, x2);
        centerY(obj, y1, y2);
    }

    public static function alignCenter(obj:DisplayObject, w:int, h:int): void {
        obj.x = (w - obj.width) / 2;
        obj.y = (h - obj.height) / 2;
    }

    /**
     * расположить объект obj после объекта after на расстоянии dist
     */
    public static function distributeAfter(obj: DisplayObject, after: DisplayObject, dist:int = 0):void {
        obj.y = after.y;// + after.height - obj.height;
        obj.x = after.x + after.width + dist;
    }

    /**
     * расположить объект obj под объектом under на расстоянии dist
     */
    public static function distributeUnder(obj: DisplayObject, under: DisplayObject, dist:int = 0):void {
        obj.y = under.y + under.height + dist;
    }

    public static function addOnBottom(ch: DisplayObject, parent: DisplayObjectContainer, dist:int = 0):void {
        var y:int = parent.height + dist;
        parent.addChild(ch);
        ch.y = y;
    }

    public static function scaleIcon(icon:DisplayObject, rectW:int, rectH:int, HZname:Boolean = false):void {
        var scaleX:Number = rectW / icon.width;
        var scaleY:Number = rectH / icon.height;
        var scale:Number;;
        if(HZname){
            scale = Math.min(scaleX, scaleY);
        }else{
            scale = Math.max(scaleX, scaleY);
        }
        icon.width *= scale;
        icon.height *= scale;
    }
 
    public static function eraceChildren(target:MovieClip):void {
        for (var i:int; i < target.numChildren; i++) { 
            if(target.getChildAt(i) is Bitmap){
                target.removeChild(target.getChildAt(i));
            }
        }
    }


    public function InterfaceUtils() {
    }
}

}