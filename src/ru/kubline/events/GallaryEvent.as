package ru.kubline.events {
import flash.events.Event;

public class GallaryEvent extends Event{

    public static const EVENT_IMAGE_LOADED:String = "imageLoaded";
    
    public function GallaryEvent() {
        super(GallaryEvent.EVENT_IMAGE_LOADED);
    }
}
}