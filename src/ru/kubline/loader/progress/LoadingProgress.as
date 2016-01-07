package ru.kubline.loader.progress {
import flash.events.StatusEvent;
import flash.net.LocalConnection;

/**
 * класс через LocalConnection отправляет на
 * прилодер статус о загрузки приложения
 *
 * @autor denis
 */
public class LoadingProgress {

    private static var instance:LoadingProgress;

    /**
     * local connection для взаимодействия с прилодером
     */
    private var localConnection:LocalConnection;
    /**
     * имя канала куда будем слать статус загрузки
     */
    private var channelName:String;

    private var isConnected:Boolean = true;

    public function LoadingProgress() {
        LoadingProgress.instance = this;
        channelName="_footballer_progress_bar_";
        localConnection = new LocalConnection();
        localConnection.allowDomain("*");
        localConnection.addEventListener(StatusEvent.STATUS, onStatusEvent);
    }

    private function onStatusEvent(e:StatusEvent): void {
        if(e.level == "error"){
            isConnected = false;
        }
    }

    /**
     * отправить на прилодел информацию о загрузки приложения
     * @param percent количество процентов которое уже загрузилось
     */
    public static function publish(percent:int):void {
        if(!LoadingProgress.instance) {
            LoadingProgress.instance = new LoadingProgress();
        }
        if(LoadingProgress.instance.isConnected) {
            LoadingProgress.instance.localConnection.send(
                    LoadingProgress.instance.channelName, "progress", percent);
        }
    }
}

}