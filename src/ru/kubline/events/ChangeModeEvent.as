package ru.kubline.events {
import flash.events.Event;

import ru.kubline.comon.GameMode;

/**
 *  Класс кастомного события, отсылаемого всякий раз при изменении режима редактирования сцены.
 * @autor lelka
 */
public class ChangeModeEvent extends Event{

    public static const MODE_CHANGE:String = "changeMode";
 
    public function ChangeModeEvent() {

        super(MODE_CHANGE);

    }
}
}