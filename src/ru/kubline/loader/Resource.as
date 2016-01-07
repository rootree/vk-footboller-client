package ru.kubline.loader{
import flash.display.MovieClip;
import flash.media.Sound;

/**
 * описание свойств загруженого ресурса
 * @autor denis
 */
public class Resource {

    /**
     * имя класса в swf
     */
    private var className:String;

    /**
     * сам класс
     */
    private var resClass:Class;

    private var x:int;

    private var y:int;

    private var width:int;

    private var height:int;

    public function getClassName():String {
        return className;
    }

    public function setClassName(name:String):void {
        this.className = name;
    }

    public function getClass():Class {
        return resClass;
    }

    public function setClass(resClass:Class):void {
        this.resClass = resClass;
    }

    public function getNewSoundInstance():Sound {
        return new (getClass())() as Sound;
    }

    public function getX():int {
        return x;
    }

    public function setX(x:int):void {
        this.x = x;
    }

    public function getY():int {
        return y;
    }

    public function setY(y:int):void {
        this.y = y;
    }

    public function getWidth():int {
        return width;
    }

    public function setWidth(width:int):void {
        this.width = width;
    }

    public function getHeight():int {
        return height;
    }

    public function setHeight(height:int):void {
        this.height = height;
    }

    public function getNewInstance():MovieClip {
        var clip:MovieClip = new (getClass())() as MovieClip;
        if(this.x){clip.x = this.x;}
        if(this.y){clip.y = this.y;}
        if(this.width){clip.width = this.width;}
        if(this.height){clip.height = this.height;}
        return clip;
    }

    public function apply(r:Resource):void {
        resClass = r.resClass;
        if(!x){x = r.x;}
        if(!y){y = r.y;}
        if(!width){width = r.width;}
        if(!height){height = r.height;}
    }
}
}