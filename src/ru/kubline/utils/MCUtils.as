package  ru.kubline.utils {
import flash.display.MovieClip;

public class MCUtils {
    public function MCUtils() {
    }


    public static function enableMouser(container:MovieClip, isTurn:Boolean = true):void{
        container.useHandCursor = isTurn;
        container.buttonMode = isTurn;
        container.mouseChildren = isTurn;
    }
}
}