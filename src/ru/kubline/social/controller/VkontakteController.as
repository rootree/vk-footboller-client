package ru.kubline.social.controller {
import com.adobe.serialization.json.JSONDecoder;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;

import ru.kubline.loader.Gallery;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.Server;
import ru.kubline.social.events.CreateAlbumEvent;
import ru.kubline.social.events.GetUploadServerEvent;
import ru.kubline.social.events.LoadAlbumsEvent;
import ru.kubline.social.events.LoadAppFriendsEvent;
import ru.kubline.social.events.LoadBalanceEvent;
import ru.kubline.social.events.LoadCitiesEvent;
import ru.kubline.social.events.LoadCountriesEvent;
import ru.kubline.social.events.LoadUserProfilesEvent;
import ru.kubline.social.events.LoadUserSettingsEvent;
import ru.kubline.social.events.LoadUsersGroupEvent;
import ru.kubline.social.events.PhotoSaveEvent;
import ru.kubline.social.events.WallReadyEvent;
import ru.kubline.social.events.WallSaveEvent;
import ru.kubline.social.manager.VkontakteRequestManager;
import ru.kubline.social.model.SocialAlbum;
import ru.kubline.social.model.SocialCity;
import ru.kubline.social.model.SocialCountry;
import ru.kubline.social.profile.SocialUserData;

/**
 * класс который обрабатывает ответы от социалки
 * @autor denis
 */
public class VkontakteController extends EventDispatcher {

    private var socialManager:VkontakteRequestManager;

    private var apiLoader:URLLoader = new URLLoader();

    /**
     * create logger instance
     */
    private var log:Logger = new Logger(VkontakteController);

    public function VkontakteController(socialManager:VkontakteRequestManager) {
        this.socialManager = socialManager;
    }

    public function getUserPage(id:String):String {
        return "http://vkontakte.ru/id" + id;
    }

    /**
     * запрос на получение настроек пользователя в соц. cети
     */
    public function getUserSettings(): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadUserSettings);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getUserSettings());
    }

    /**
     * запрос на получение альбомов игрока в соц. сети
     */
    public function getAlbums():void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadAlbums);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getAlbums());
    }

    /**
     * запрос на получение альбомов игрока в соц. сети
     */
    public function getCityNameById(id:uint):void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadCity);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getCityNameById(id));
    }

    /**
     * запрос на получение альбомов игрока в соц. сети
     */
    public function getCountryNameById(id:uint):void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadCountry);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getCountryNameById(id));
    }

    /**
     * запрос на создание нового альбома
     */
    public function createAlbum (title:String, description:String):void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onCreateAlbum);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.createAlbum(title, description));
    }

    /**
     * запрос на взятия URL сервера куда необходимо загрузить фото
     * @param aid id альбома куда будем сохранять фото
     */
    public function getUploadServer(aid:String): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onGetUploadServer);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getUploadServer(aid));
    }

    /**
     * Загрузка фотографии на сервер контакта
     * @param foto фото для загрузки
     * @param uploadServer url куда будем сохронять фото
     */
    public function uploadPoto(foto:BitmapData, uploadServer:String): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, function(e:Event):void {
            //сохранение через savePhotos
            var result:Object = new JSONDecoder( e.target.data ).getValue();
            photoSave(result.aid, result.server, result.photos_list, result.hash);
        });
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.uploadPoto(foto, uploadServer));
    }


    public function photoSave(aid:Object, server:Object, photos_list:Object, hash:Object): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
            var respXml:XML = new XML(event.target.data);
            if (respXml.name().toString() == "error") {
                var errorMsg:String = "Can't photoSave, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
                log.error(errorMsg);
                dispatchEvent(new PhotoSaveEvent(false));
            } else {
                dispatchEvent(new PhotoSaveEvent(true) );
            }
        });
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.photoSave(aid, server, photos_list, hash));
    }

    /**
     * запрос получения
     * списка друзей, которые уже добавили данное приложение
     */
    public function getAppFriends(): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadAppFriends);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getAppFriends());
    }

    /**
     * запрос получения
     * списка друзей, которые уже добавили данное приложение
     */
    public function getFriends(): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadAppFriends);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getFriends());
    }

    /**
     * запрос получения
     * списка друзей, которые уже добавили данное приложение
     */
    public function getUsersGroup(): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadUsersGroup);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getUsersGroup());
    }

    /**
     * обработчик ответа социалки на запрос получения
     * списка друзей, которые уже добавили данное приложение
     */
    private function onLoadUsersGroup(event:Event): void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get AppFriends, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            if (parseInt(respXml.error_code) == 7) {
                dispatchEvent(new LoadAppFriendsEvent(null, errorMsg, LoadUsersGroupEvent.ACCESS_DENIED));
            } else {
                dispatchEvent(new LoadAppFriendsEvent(null, errorMsg, LoadUsersGroupEvent.ERROR));
            }
        } else {
 
            var count:uint = 0;
            var uids:Array = new Array();
            for each(var gid:XML in respXml..gid) {
                if(count > 100){
                    break;
                }
                uids.push(parseInt(gid.text().toString()));
                count ++;
            }
            dispatchEvent(new LoadUsersGroupEvent(uids, null, LoadUsersGroupEvent.SUCCESSFULL));
        }
    }

    /**
     * запрос на получение списка профайлов юзеров
     * @param array список идентификаторов юзеров профайлы
     * которых необходимо загрузить
     */
    public function getUserProfiles(array:Array): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadUserProfiles);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getUserProfiles(array));
    }

    /**
     * запрос на получение списка профайлов юзеров
     * @param array список идентификаторов юзеров профайлы
     * которых необходимо загрузить
     */
    public function getUserProfilesGen(array:Array): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, onLoadUserProfiles);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getUserProfilesGen(array));
    }

    /**
     * запрос на получение баланса текущего пользователя
     */
    public function getUserBalance(): void {
        if(Application.VKIsEnabled){
            apiLoader = new URLLoader();
            apiLoader.addEventListener(Event.COMPLETE, onLoadUserBalance);
            apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
            apiLoader.load(socialManager.getUserBalance());
        }else{
            dispatchEvent(new LoadBalanceEvent(true, 10));
        }
    }

    /**
     * запрос на взятия URL сервера куда необходимо загрузить фото
     */
    private function onGetUploadServer(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get  UploadServer, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new GetUploadServerEvent(false));
        } else {
            dispatchEvent(new GetUploadServerEvent(true, respXml.upload_url.toString()) );
        }
    }

    /**
     * запрос на создание нового альбома
     */
    private function onCreateAlbum(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't create albums, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new CreateAlbumEvent(false));
        } else {
            var album:SocialAlbum = new SocialAlbum();
            for each(var respAlbum:XML in respXml.album) {
                album.setAid(respAlbum.aid.toString());
                album.setOwnerId(respAlbum.owner_id.toString());
                album.setTitle(respAlbum.title.toString());
                album.setDescription(respAlbum.description.toString());
            }
            dispatchEvent(new CreateAlbumEvent(true, album));
        }
    }

    /**
     * обработчик ответа на запрос всех альбомов игрока
     */
    private function onLoadAlbums(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get albums, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new LoadAlbumsEvent(false));
        } else {
            var socialAlbums:Array = new Array();
            for each(var respAlbum:XML in respXml.album) {
                var album:SocialAlbum = new SocialAlbum();
                album.setAid(respAlbum.aid.toString());
                album.setOwnerId(respAlbum.owner_id.toString());
                album.setTitle(respAlbum.title.toString());
                album.setDescription(respAlbum.description.toString());
                socialAlbums.push(album);
            }
            dispatchEvent(new LoadAlbumsEvent(true, socialAlbums));
        }
    }

    /**
     * обработчик ответа на запрос всех альбомов игрока
     */
    private function onLoadCity(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get albums, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new LoadCitiesEvent(false));
        } else {
            var socialCities:Array = new Array(); 
            for each(var respCityXml:XML in respXml.city) {
                var city:SocialCity = new SocialCity(); 
                city.setCid(respCityXml.cid.toString());
                city.setTitle(respCityXml.name.toString());
                socialCities.push(city);
            }
            dispatchEvent(new LoadCitiesEvent(true, socialCities));
        }
    }

    /**
     * обработчик ответа на запрос всех альбомов игрока
     */
    private function onLoadCountry(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get albums, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new LoadCountriesEvent(false));
        } else {
            var socialCountries:Array = new Array();
            for each(var respCountry:XML in respXml.country) {
                var country:SocialCountry = new SocialCountry();
                country.setCid(respCountry.cid.toString());
                country.setTitle(respCountry.name.toString());
                socialCountries.push(country);
            }
            dispatchEvent(new LoadCountriesEvent(true, socialCountries));
        }
    }

    /**
     * обработчик ответа на запрос
     * настроек пользователя в социальной сети
     */
    private function onLoadUserBalance(event:Event): void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get UserBalance, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new LoadBalanceEvent(false));
        } else {
            var balance:int = int(respXml.balance) / 100;
            dispatchEvent(new LoadBalanceEvent(true, balance));
        }
    }

    /**
     * обработчик ответа на запрос
     * настроек пользователя в социальной сети
     */
    private function onLoadUserSettings(event:Event): void { 
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get UserSettings, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            throw new Error(errorMsg);
        } else {
            // читаем битовую маску ответа
            var bitMaskSettings:int = int(respXml.settings);
            // если пользователь разрешил доступ к списку друзей и принимать уведомления от приложения
            if (((bitMaskSettings & 1) != 0) && ((bitMaskSettings & 2) != 0)) {
                //если настройки пользователя разрешают спрашивать список друзей, то спрашиваем
                dispatchEvent(new Event(LoadUserSettingsEvent.ACCESS_ALLOWED));
            } else {
                dispatchEvent(new Event(LoadUserSettingsEvent.ACCESS_DENIED));
            }
        }
    }

    /**
     * обработчик ответа социалки на запрос получения
     * списка друзей, которые уже добавили данное приложение
     */
    private function onLoadAppFriends(event:Event): void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get AppFriends, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            if (parseInt(respXml.error_code) == 7) {
                dispatchEvent(new LoadAppFriendsEvent(null, errorMsg, LoadAppFriendsEvent.ACCESS_DENIED));
            } else {
                dispatchEvent(new LoadAppFriendsEvent(null, errorMsg, LoadAppFriendsEvent.ERROR));
            }
        } else {
            
            var uids:Array = new Array();
            var count:uint = 0;
            for each(var uid:XML in respXml..uid) {
                if(count > 100){
                    break;
                }
                uids.push(parseInt(uid.text().toString()));
                count ++;
            }
            dispatchEvent(new LoadAppFriendsEvent(uids, null, LoadAppFriendsEvent.SUCCESSFULL));
        }
    }

    /**
     *  обработчик ответа на запрос получения списка профайлов юзеров
     */
    private function onLoadUserProfiles(event:Event): void {
        var respXml:XML = new XML(event.target.data);

        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get UserProfiles, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new LoadUserProfilesEvent(null, errorMsg, LoadUserProfilesEvent.ERROR));
        } else {
            var socialUserProfiles:Object = new Object();
            for each(var user:XML in respXml.user) {
                var userData:SocialUserData = new SocialUserData();
                userData.setId(parseInt(user.uid.text()));

                userData.setFirstName(user.first_name.text());
                userData.setLastName(user.last_name.text());
                userData.setNickName(user.nickname.text()); 
                userData.setSex(user.sex - 1);
                userData.setCountry(user.country);
                userData.setCity(user.city);
                userData.setUniversity(user.university);
                userData.setUniversityName(user.university_name);

                var bDateStr:String = user.bdate.toString() || null;     
                if (bDateStr) {
                    var splitDate:Array = bDateStr.split(".");
                    userData.setBirthday(new Date(parseInt(splitDate[2]),
                            (parseInt(splitDate[1]) - 1),
                            parseInt(splitDate[0])));
                }
                var photo:String = user.photo.toString() || null;
                if (photo == null) {
                    photo = "http://" + Server.MAIN.getHost() + "/" + Gallery.TYPE_OTHER + "/" + Gallery.BAD_LOAD + ".jpg";
                } else if (photo.indexOf("vkontakte.ru") < 0 && photo.indexOf("vk.com") < 0) {
                    photo = "http://vkontakte.ru/" + photo;
                }
                userData.setPhoto(photo);

                photo = user.photo_big.toString() || null;
                if (photo == null) {
                    photo = "http://" + Server.MAIN.getHost() + "/" + Gallery.TYPE_OTHER + "/" + Gallery.BAD_LOAD + ".jpg";
                } else if (photo.indexOf("vkontakte.ru") < 0 && photo.indexOf("vk.com") < 0) {
                    photo = "http://vkontakte.ru/" + photo;
                }
                userData.setPhotoBig(photo);

        log.debug(userData);

                socialUserProfiles[userData.getId()] = userData;
            }
            dispatchEvent(new LoadUserProfilesEvent(socialUserProfiles, null, LoadUserProfilesEvent.SUCCESSFULL));
        }
    }

    public function ioErrorListener(e:IOErrorEvent):void {
        log.error("I/O Error: " + e.text);
        dispatchEvent(e);
    }


    //////////////////// save photo on wall ////////////////////////////////



    /**
     * запрос на взятия URL сервера куда необходимо загрузить фото
     * @param aid id альбома куда будем сохранять фото
     */
    public function getWallUploadServer(): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, parseWallUploadServer);
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.getWallUploadServer());
    }


    /**
     * запрос на взятия URL сервера куда необходимо загрузить фото
     */
    private function parseWallUploadServer(event:Event):void {
        var respXml:XML = new XML(event.target.data);
        if (respXml.name().toString() == "error") {
            var errorMsg:String = "Can't get  UploadServer, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
            log.error(errorMsg);
            dispatchEvent(new GetUploadServerEvent(false));
        } else {
            dispatchEvent(new GetUploadServerEvent(true, respXml.upload_url.toString()) );
        }
    }

        /**
     * Загрузка фотографии на сервер контакта
     * @param foto фото для загрузки
     * @param uploadServer url куда будем сохронять фото
     */
    public function uploadWallPoto(foto:BitmapData, uploadServer:String): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, function(e:Event):void {

            log.debug("uploadWallPoto COMPLETE ");

            var result:Object = new JSONDecoder( e.target.data ).getValue(); 
            var event:WallSaveEvent = new WallSaveEvent(result.server, result.photo, result.hash);
            dispatchEvent(event);
 //           
        });
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.uploadPhotoOnWall(foto, uploadServer));
        log.debug("uploadWallPoto start ... ");
    }


    public function photoWallSave(server:Object, photo:Object, hash:Object, userId:uint, message:String): void {
        apiLoader = new URLLoader();
        apiLoader.addEventListener(Event.COMPLETE, function(event:Event):void {

            log.debug("photoWallSave COMPLETE ");

            var respXml:XML = new XML(event.target.data);

            if (respXml.name().toString() == "error") {
                var errorMsg:String = "Can't photoSave, errorCode: " + respXml.error_code + " msg: " + respXml.error_msg;
                log.error(errorMsg);
                dispatchEvent(new WallReadyEvent(false, null));
            } else {
                dispatchEvent(new WallReadyEvent(true, respXml.post_hash.toString()) );
            }
        });                       
        apiLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        apiLoader.load(socialManager.saveOnWall(server, photo, hash, message, userId));

        log.debug("photoWallSave start ... ");

    }


}
}