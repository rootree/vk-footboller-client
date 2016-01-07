package ru.kubline.interfaces.window {
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.loader.ClassLoader;


public class Message extends UIWindow {

    /**
     * сообщение 'идет сохранение данных'
     */
    public static const SAVING_MSG:Message = new Message("SavingMessage");

    /**
     * сообщение 'загрузка'
     */
    public static const LOADING_MSG:Message = new Message("LoadingMessage");

    public function Message(className:String) {
        super(ClassLoader.getNewInstance(className));
    }
}
}