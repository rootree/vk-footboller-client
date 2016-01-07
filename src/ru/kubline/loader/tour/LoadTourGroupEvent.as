package ru.kubline.loader.tour { 

import flash.events.Event;
 
public class LoadTourGroupEvent extends Event {
     
    public var groupType:uint;

    public static const TOUR_GROUPS_LOADED:String = "tour_groups_loaded";

    public function LoadTourGroupEvent(groupType:uint)	{
        super(TOUR_GROUPS_LOADED);
        this.groupType = groupType;
    }

} 
}