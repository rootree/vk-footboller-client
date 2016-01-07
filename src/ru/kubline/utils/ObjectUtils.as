package ru.kubline.utils {
import com.adobe.serialization.json.JSON;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.utils.ByteArray;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:58:38 PM
 */

public class ObjectUtils {
    public function ObjectUtils() {
    }

    public static function copy(value:*):*{
        var buffer:ByteArray = new ByteArray();
        buffer.writeObject(value);
        buffer.position = 0;
        var result:* = buffer.readObject();
        return result;
    }

    public static function count(object:*):uint {
        var count:uint = 0;
        for each (var value:* in object) {
            count ++;
        }
        return count;
    }

    public static function getAllChildren(target:MovieClip):void {
        for (var i:int; i < target.numChildren; i++) {
            if(!(target.getChildAt(i) is Shape)){
                if(MovieClip(target.getChildAt(i)).name){
                    trace(MovieClip(target.getChildAt(i)).name, MovieClip(target.getChildAt(i)).numChildren);
                }else{
                    trace("WTF");
                }
            }
        }
    }

    public static function JSONerArray(arra:Array):Object{

        var tempJSON:Object = {}
        for (var i:int; i < arra.length; i++) {
            tempJSON[arra[i]] = arra[i];
        }

        var jsonString:String = JSON.encode( tempJSON );
        return (jsonString);

    }
}
}