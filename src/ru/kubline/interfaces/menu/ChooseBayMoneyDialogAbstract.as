package ru.kubline.interfaces.menu {
import flash.display.MovieClip; 
import ru.kubline.gui.controls.UIWindow; 

public class ChooseBayMoneyDialogAbstract extends UIWindow {


    public function ChooseBayMoneyDialogAbstract(container:MovieClip) {
        super(container);
    }

    public function showMenu(item:Object):void{ 
        super.show();
    }


}
}