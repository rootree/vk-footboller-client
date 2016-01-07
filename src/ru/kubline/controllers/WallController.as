package ru.kubline.controllers {
import flash.display.BitmapData;

import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.social.events.GetUploadServerEvent;
import ru.kubline.social.events.PhotoSaveEvent;
import ru.kubline.social.events.WallReadyEvent;
import ru.kubline.social.events.WallSaveEvent;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:39:30 PM
 */

public class WallController {

    private var log:Logger = new Logger(WallController);

    /**
     * Сервер социалки куда будем сохронять фото
     */
    private var uploadServer:String;

    private var dataForUpload:BitmapData;

    private var userId:uint;

    private var message:String;

    private var prepareMessage:String;

    public function WallController(image:BitmapData, userId:uint, message:String, prepareMessage:String = "Все готово для размещения") {
        dataForUpload = image;
        this.userId = userId;
        this.message = message;
        this.prepareMessage = prepareMessage;
    }

    public function start():void{
        Singletons.vkontakteController.addEventListener(GetUploadServerEvent.UPLOAD_SERVER, onGetUploadServer);
        Singletons.vkontakteController.getWallUploadServer();
        Singletons.loadingMsg.start("Подготовка данных ...");
    }

    private function onGetUploadServer(event:GetUploadServerEvent):void {
        //отписываемся от события
        Singletons.vkontakteController.removeEventListener(GetUploadServerEvent.UPLOAD_SERVER, onGetUploadServer);
        if (!uploadServer && event.success) {
            
            uploadServer = event.uploadServer;
            Singletons.vkontakteController.addEventListener(WallSaveEvent.PHOTO_SAVE_WALL, onPhotoSave);
            Singletons.vkontakteController.addEventListener(WallReadyEvent.WALL_READY, showWripper);

            /*
             * из-а секюрности флеша мы не можем загружать произвольно файлы на сервер,
             * а можем это делать лишь на какое-то действие игрока. Например: клик мыши
             * т.к. будет (SecurityError: Error #2176:), но мы применяем хаку для ее обхода
             */
            var msgBox:MessageBox = new MessageBox("Сообщение", prepareMessage, MessageBox.OK_BTN, function():void{
                Singletons.vkontakteController.uploadWallPoto(dataForUpload, uploadServer);
            });
            
            msgBox.show();
        } else {
            onError();
        }
    }
 
    private function showWripper(event:WallReadyEvent):void {
        Singletons.vkontakteController.removeEventListener(WallReadyEvent.WALL_READY, showWripper);
        Singletons.vkontakteController.removeEventListener(WallSaveEvent.PHOTO_SAVE_WALL, onPhotoSave);
        if(event.success){
            var wrapper:Object = Singletons.context.getWrapper();
            if (wrapper && wrapper.external) {
                wrapper.external.saveWallPost(event.hash);
            }
        }else{
            onError();  
        }
    }

    private function onPhotoSave(event:WallSaveEvent):void {
        if (event.server) {
            Singletons.vkontakteController.photoWallSave(event.server, event.photo, event.hash, userId, message );
            Singletons.loadingMsg.delayHide("Все готово для размещения");
        } else {
            onError();
        }  
    }

    private function onError():void {
        Singletons.loadingMsg.hide();
        var msgBox:MessageBox = new MessageBox(Messages.getMessage("TITLE_ERROR"), Messages.getMessage("ERROR_SERVER"), MessageBox.OK_BTN);
        msgBox.show();
    }

}
}