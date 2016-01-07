package ru.kubline.social.manager {

import com.adobe.images.PNGEncoder;

import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.utils.ByteArray;
import ru.kubline.crypto.MD5;

/**
 * класс предостовляет методы для генерации запроса к вконтакте
 *
 * @autor denis
 */
public class VkontakteRequestManager extends EventDispatcher{

    private static var key:String = "NsSlstTgv3";


    /**
     * Версия API
     */
    private const apiVersion:String = "2.0";

    /**
     * параметры которые передал нам сайт
     */
    private var flashVars:Object;

    /**
     * формат возвращаемых данных – XML или JSON. По умолчанию XML.
     */
    private const format:String = "XML";

    /**
     * Если этот параметр равен 1,
     * разрешает тестовые запросы к данным приложения.
     * При этом аутентификация не проводится и считается,
     * что текущий пользователь – это автор приложения.
     * Это позволяет тестировать приложение без загрузки его на сайт.
     * По умолчанию 0
     */
    private var testMode:String ="1";

    /**
     * было ли приложение уже проинициализировано
     */
    private var inited:Boolean = false;

    public function VkontakteRequestManager(flashVars:Object) {
        if (inited) {
            return;
        }

        if(Application.runQAMode){
            key = "AmhyqaTPF3"; // QA
        }
 
        this.flashVars = flashVars;
        this.inited = true;
    }

    /**
     * вернет URLLoader для запроса у вконтакте списка профайлов
     * @param array - массив id пользователей профайлы которых необходимо запросить
     */
    public function getUserProfiles(array:Array) : URLRequest {
        var uids:String = "";
        for (var id:String in array) {
            uids = uids + ((uids ? (",") : ("")) + array[id]);
        }
        var fields:String = "uid,first_name,last_name,sex,city,country,photo,photo_big,photo_medium,education";
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["fields"] = fields;
        apiVariables["format"] = format;
        apiVariables["method"] = "getProfiles";
        apiVariables["uids"] = uids;
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "fields="+fields+"format=" + format + "method=getProfilestest_mode=" + testMode +
                                          "uids=" + uids + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте списка профайлов
     * @param array - массив id пользователей профайлы которых необходимо запросить
     */
    public function getUserProfilesGen(array:Array) : URLRequest {
        var uids:String = "";
        for (var id:String in array) {
            uids = uids + ((uids ? (",") : ("")) + array[id]);
        }
        var fields:String = "uid,first_name,last_name,sex,city,country,photo,photo_big,photo_medium,education";
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["fields"] = fields;
        apiVariables["format"] = format;
        apiVariables["method"] = "getProfiles";
        apiVariables["name_case"] = "gen";
        apiVariables["uids"] = uids;
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "fields="+fields+"format=" + format + "method=getProfilesname_case=" + apiVariables["name_case"] + "test_mode=" + testMode +
                                          "uids=" + uids + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }


    /**
     * вернет URLLoader для запроса у вконтакте профайла текущего пользователя
     */
    public function getUserProfile() : URLRequest {
        var fields:String = "uid,first_name,last_name,sex,city,country,photo,photo_big,photo_medium,education";
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["fields"] = fields;
        apiVariables["format"] = format;
        apiVariables["method"] = "getProfiles";
        apiVariables["uids"] = flashVars["viewer_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "fields="+fields+"format=" + format + "method=getProfilestest_mode=" + testMode +
                                          "uids=" + flashVars["viewer_id"] + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }


    /**
     * вернет URLLoader для запроса у вконтакте профайла текущего пользователя
     */
    public function getUsersGroup() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getGroups";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getGroupstest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте списка друзей текущего пользователя
     * которые установили себе данное приложение
     */
    public function getAppFriends() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getAppFriends";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getAppFriendstest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте всего
     * списка друзей текущего пользователя
     */
    public function getFriends() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getFriends";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getFriendstest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте настроек пользователя
     */
    public function getUserSettings() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getUserSettings";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getUserSettingstest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте баланса текущего пользователя
     */
    public function getUserBalance() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getUserBalance";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getUserBalancetest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * вернет URLLoader для запроса у вконтакте времени в секундах
     */
    public function getServerTime() : URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["format"] = format;
        apiVariables["method"] = "getServerTime";
        apiVariables["v"] = apiVersion;
        apiVariables["test_mode"] = testMode;
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "format=" + format + "method=getServerTimetest_mode=" + testMode + "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @return URLLoader для создания альбома в вконтакте
     */
    public function createAlbum(title:String, description:String):URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["title"] = title;
        apiVariables["privacy"] = "0";
        apiVariables["comment_privacy"] = "0";
        apiVariables["description"] = description;//Messages.ALBUM_DESCRIPTION + flashVars["viewer_id"];
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "photos.createAlbum";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "api_id=" + flashVars["api_id"] +
                                          "comment_privacy=" + apiVariables["comment_privacy"] + "description=" + apiVariables["description"] +
                                          "format=" + format + "method=" + apiVariables["method"] + "privacy=" + apiVariables["privacy"] +
                                          "test_mode=" + testMode + "title=" + apiVariables["title"] +  "v=" + apiVersion + key);
        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @return URLRequest для взятия всех альбомов игрока
     */
    public function getAlbums():URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["uid"] = flashVars["viewer_id"];
        apiVariables["aids"] = "";
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "photos.getAlbums";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "aids=" + apiVariables["aids"] +
                                          "api_id=" + flashVars["api_id"] + "format=" + format +
                                          "method=" + apiVariables["method"] + "test_mode=" + testMode +
                                          "uid=" + apiVariables["uid"] + "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @return URLRequest для взятия всех альбомов игрока
     */
    public function getCityNameById(id:uint):URLRequest {

      var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["cids"] = id;
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "places.getCityById";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] +
                                          "api_id=" + flashVars["api_id"] + "cids=" + apiVariables["cids"] +
                                          "format=" + format + "method=" + apiVariables["method"] + "test_mode=" + testMode +
                                           "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
      //   navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @return URLRequest для взятия всех альбомов игрока
     */
    public function getCountryNameById(id:uint):URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.POST;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion; 
        apiVariables["cids"] = id;
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "places.getCountryById";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] +
                                          "api_id=" + flashVars["api_id"] + "cids=" + apiVariables["cids"] +
                                          "format=" + format + "method=" + apiVariables["method"] + "test_mode=" + testMode +
                                           "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
      //   navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @param aid id альбома куда будем сохранять фото
     * @return URLRequest для взятия сервера куда необходимо загрузить фото
     */
    public function getUploadServer(aid:String):URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["aid"] = aid;
        apiVariables["save_big"] = "1";
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "photos.getUploadServer";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "aid=" + apiVariables["aid"] +
                                          "api_id=" + flashVars["api_id"] + "format=" + format +
                                          "method=" + apiVariables["method"] + "save_big=" + apiVariables["save_big"] +
                                          "test_mode=" + testMode + "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @param foto фотка которую загружаем
     * @param uploadServer url куда будем грузить фото
     * @return URLRequest для загрузки фото на сервер вконтакте
     */
    public function uploadPoto(foto:BitmapData, uploadServer:String):URLRequest {
        var ba:ByteArray;
        ba = PNGEncoder.encode(foto);
        var boundary:String = "OKSANA-SHEVCHENKO";
        var header1:* = "\r\n--" + boundary + "\r\n" + "Content-Disposition: form-data; name=\"file1\"; filename=\"file1.png\"\r\n" + "Content-Type: image/png\r\n\r\n" + "";
        var header2:* = "--" + boundary + "\r\n" + "Content-Disposition: form-data; name=\"Upload\"\r\n\r\n" + "Submit Query\r\n" + "--" + boundary + "--";
        var headerBytes1:ByteArray = new ByteArray();
        headerBytes1.writeMultiByte(header1, "ascii");
        var headerBytes2:ByteArray = new ByteArray();
        headerBytes2.writeMultiByte(header2, "ascii");
        var sendBytes:ByteArray = new ByteArray();
        sendBytes.writeBytes(headerBytes1, 0, headerBytes1.length);
        sendBytes.writeBytes(ba, 0, ba.length);
        sendBytes.writeBytes(headerBytes2, 0, headerBytes2.length);

        var request:URLRequest =new URLRequest(uploadServer);
        request.data=sendBytes;
        request.method=URLRequestMethod.POST;
        request.contentType = "multipart/form-data; boundary=" + boundary;

        return request;
    }


    public function photoSave(aid:Object, server:Object, photos_list:Object, hash:Object):URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["aid"] = aid;
        apiVariables["server"] = server;
        apiVariables["photos_list"] = photos_list;
        apiVariables["hash"] = hash;
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "photos.save";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] + "aid=" + apiVariables["aid"] +
                                          "api_id=" + flashVars["api_id"] + "format=" + format +
                                          "hash=" + apiVariables["hash"] + "method=" + apiVariables["method"] +
                                          "photos_list=" + apiVariables["photos_list"] + "server=" + apiVariables["server"] +
                                          "test_mode=" + testMode + "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
        //navigateToURL(apiRequest);
        return apiRequest;
    }

    /**
     * @param foto фотка которую загружаем
     * @param uploadServer url куда будем грузить фото
     * @return URLRequest для загрузки фото на сервер вконтакте
     */
    public function uploadPhotoOnWall(foto:BitmapData, uploadServer:String):URLRequest {
        var ba:ByteArray;
        ba = PNGEncoder.encode(foto);
        var boundary:String = "OKSANA-SHEVCHENKO";
        var header1:* = "\r\n--" + boundary + "\r\n" + "Content-Disposition: form-data; name=\"photo\"; filename=\"file1.png\"\r\n" + "Content-Type: image/png\r\n\r\n" + "";
        var header2:* = "--" + boundary + "\r\n" + "Content-Disposition: form-data; name=\"Upload\"\r\n\r\n" + "Submit Query\r\n" + "--" + boundary + "--";
        var headerBytes1:ByteArray = new ByteArray();
        headerBytes1.writeMultiByte(header1, "ascii");
        var headerBytes2:ByteArray = new ByteArray();
        headerBytes2.writeMultiByte(header2, "ascii");
        var sendBytes:ByteArray = new ByteArray();
        sendBytes.writeBytes(headerBytes1, 0, headerBytes1.length);
        sendBytes.writeBytes(ba, 0, ba.length);
        sendBytes.writeBytes(headerBytes2, 0, headerBytes2.length);

        var request:URLRequest =new URLRequest(uploadServer);
        request.data=sendBytes;
        request.method=URLRequestMethod.POST;
        request.contentType = "multipart/form-data; boundary=" + boundary;

        return request;
    }

    /**
     * @param aid id альбома куда будем сохранять фото
     * @return URLRequest для взятия сервера куда необходимо загрузить фото
     */
    public function getWallUploadServer():URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "wall.getPhotoUploadServer";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] +
                                          "api_id=" + flashVars["api_id"] + "format=" + format +
                                          "method=" + apiVariables["method"] +
                                          "test_mode=" + testMode + "v=" + apiVersion + key);

        apiRequest.data = apiVariables;
        //  navigateToURL(apiRequest);
        return apiRequest;
    }


    public function saveOnWall(server:Object, photo:Object, hash:Object, message:String, wall_id:uint):URLRequest {
        var apiVariables:URLVariables = new URLVariables();
        var apiRequest:URLRequest = new URLRequest(flashVars["api_url"]);
        apiRequest.method = URLRequestMethod.GET;
        apiVariables["api_id"] = flashVars["api_id"];
        apiVariables["v"] = apiVersion;
        apiVariables["server"] = server;
        apiVariables["photo"] = photo;
        apiVariables["hash"] = hash;
        apiVariables["message"] = message;
        apiVariables["wall_id"] = wall_id;
        apiVariables["format"] = format;
        apiVariables["test_mode"] = testMode;
        apiVariables["method"] = "wall.savePost";
        apiVariables["sig"] = MD5.encrypt(flashVars["viewer_id"] +
                                          "api_id=" + flashVars["api_id"] + "format=" + format +
                                          "hash=" + apiVariables["hash"] + "message=" + apiVariables["message"] +
                                          "method=" + apiVariables["method"] +
                                          "photo=" + apiVariables["photo"] + "server=" + apiVariables["server"] +
                                          "test_mode=" + testMode + "v=" + apiVersion  + "wall_id=" + apiVariables["wall_id"] + key);

        apiRequest.data = apiVariables;
        return apiRequest;
    }
}


}