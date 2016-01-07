package ru.kubline.loader {
import flash.events.Event;
import flash.events.EventDispatcher;

import flash.events.IOErrorEvent;
import flash.net.URLLoader;

import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.getDefinitionByName;

import nochump.util.zip.ZipEntry;

import nochump.util.zip.ZipFile;

import ru.kubline.display.AbstractItem;
import ru.kubline.display.SimpleCup;
import ru.kubline.display.SimpleFootballer;
import ru.kubline.display.SimpleTeam;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.loader.ClassLoader;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.utils.ItemUtils;


/*
 * класс для загрузки типов изо-элементов на сцене. доступ к каждому экземпляру типа на сцене можно осуществить через вызов функции   getNewInstanceSceneIsoElement
 * * */
public class ItemTypeStore extends EventDispatcher{

    public static const TYPE_GOALKEEPER:String = "4";
    public static const TYPE_FORWARD:String = "1";
    public static const TYPE_SAFER:String = "3";
    public static const TYPE_HALFSAFER:String = "2";
    public static const TYPE_TEAMLEAD:String = "5";


    public static const TYPE_LOGO_TEAM:String = "Team";
    public static const TYPE_LOGO_SPONSOR:String = "Sponsor";
    public static const TYPE_STADIUM:String = "Stadium";
    public static const TYPE_CUPS:String = "Cups";

    private static var instance:ItemTypeStore;

    /**
     * содержит все загружениые типы зданий
     * объекты типа BuildingResource
     */
    private var store:Object;
    private var storeTeams:Object;
    private var storeCups:Object;

    private var path:String = "data/";

    private var baseURL:String;

    private var xmlLoader:URLLoader;

    private var log:Logger = new Logger(ItemTypeStore);

    public function ItemTypeStore(baseURL:String) {
        instance = this;
        this.baseURL = baseURL;
        this.path = baseURL + path;
        store = new Object();
    }

    /**
     * Создание нового инстанса элемента для отображения на сцене
     * @param id идентификатор типа здания по которому нужно построить инстанс элемента для отображения на счене
     * @return AbstractItem
     */
    public static function getNewInstanceSceneIsoElement(id:int):AbstractItem {
        var buildingResource:ItemResource = ItemResource(instance.store[id]);
        var mainClass:Class = buildingResource.getBuildingClass();
        return new mainClass(buildingResource);
    }

    /**
     * @param id идентификатор типа здания кот орый нужно вернуть
     * @return класс описанием описанием загруженого типа здания
     */
    public static function getItemResourceById(id:int):ItemResource {

        if(ItemResource(instance.store[id])){
            return ItemResource(instance.store[id]);
        }
        var building:ItemResource = new ItemResource();

        building.setId(id);

        building.setName("Неизвестно");
        building.setDisplayClass(id.toString());

        var params: Object = new Object();

        params['level'] = 1;
        params['cup'] = 1;
        params['ccode'] = 1;
        params['multiplier'] = 1;
        params['rating'] = 1;
        params['team'] = 1;
        params['year'] = 1990;
        
        building.setParams(params);

        return building;
    }

    /**
     * метод начинает загругку типов зданий из XML
     */
    public function load():void {
        xmlLoader = new URLLoader();
        xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
        xmlLoader.addEventListener(Event.COMPLETE, itemConfXmlLoaded);
        xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        xmlLoader.load(new URLRequest(path + "itemsConf.zip"));
    }

    public function itemConfXmlLoaded(event:Event):void {

        var loadedData:IDataInput;
        // load a zip via URLStream or URLLoader using binary data format...
        // create zip file
        var zipFile:ZipFile = new ZipFile(event.target.data);
        for(var i:int = 0; i < zipFile.entries.length; i++) {
            var entry:ZipEntry = zipFile.entries[i];

            // extract the entry's data from the zip
            var data:ByteArray = zipFile.getInput(entry);

        }


        var itemConfXML:XML = new XML(data);

        for each(var item:XML in itemConfXML..it) {
            //заполняем созданный объект BuildingResource инфой из building-config.xml
            var building:ItemResource = new ItemResource();

            building.setId(parseInt(item.@id.toString()));

            building.setOrder(parseInt(item.orb.toString()));

            building.setShopType(ItemUtils.converStringTypeToInt(item.st.toString()).toString());

            building.setRequiredLevel(parseInt(item.reql.toString()));

            if (item.his && item.his.toString() == "0") {
                building.setHideInShop(false);
            } else {
                building.setHideInShop(true);
            }

            building.setName(item.nm.toString());
            building.setDisplayClass(item.@id.toString());

            building.setPrice(parseInt(item.pr.toString()), parseInt(item.rlpr.toString()));

            var className:String = "ru.kubline.display." + item.cln.toString();
            building.setBuildingClass(getDefinitionByName(className) as Class);
            building.setItemClass(item.cln.toString());

            if (item.prm.toString()) {
                var params: Object = new Object();
                for each (var param: XML in item.child("prm").children()) {
                    params[param.name()] = param.toString();
                }
                building.setParams(params);
            }
            store[building.getId()] = building;
        }

        onCompleteLoading();

    }

    private function onCompleteLoading():void {
        log.info("ItemTypeStore.dispatchEvent() ");
        dispatchEvent(new Event(Event.COMPLETE));
    }

    public function ioErrorListener(e:IOErrorEvent):void {
        log.info("Load Error: " + e.text);
        dispatchEvent(e);
    }

    /**
     * Возращает все полученные из XML ресурсы
     * @return ar
     */
    public static function getStore():Object {
        return instance.store;
    }

    /**
     * Выдать ресурсы согласно условиям
     * @param type Тип ресурса (дорога, здание и т.д.)
     * @return ar
     */
    public static function getStoreByGlobalType(type:String):Array{
        var ar:Array = [];
        var className:String;
        for each(var item:ItemResource in instance.store) {
            className = item.getItemClass() ;
            switch(type){
                case ItemTypeStore.TYPE_LOGO_TEAM:
                    if(className == 'SimpleTeam'){
                        ar.push(item);
                    }
                    break;
                case ItemTypeStore.TYPE_CUPS:
                    if(className == 'SimpleCup'){
                        ar.push(item);
                    }
                    break;
            }
        }
        //сортируем предметы по order
        ItemTypeStore.sort(ar);
        return ar;
    }

    /**
     * Выдать ресурсы согласно условиям
     * @param type Тип ресурса (дорога, здание и т.д.)
     * @return ar
     */
    public static function getStoreByType(type:String):Array{
        var ar:Array = [];
        for each(var item:ItemResource in instance.store) {
            if (type == item.getShopType()) {
                ar.push(item);
            }
        }
        //сортируем предметы по order
        ItemTypeStore.sort(ar);
        return ar;
    }

    /**
     * Выдать ресурсы согласно условиям
     * @param type Тип ресурса (дорога, здание и т.д.)
     * @return ar
     */
    public static function getStoreByTypeAndLevel(type:String):Array{

        var ar:Array = [];
        for each(var item:ItemResource in instance.store) {
            var level:uint = Application.teamProfiler.getLevel() + 1;
            var levelCheck:uint = item.getRequiredLevel();
            if (type == item.getShopType() && level >= levelCheck) {
                ar.push(item);
            }
        }
        //сортируем предметы по order
        ItemTypeStore.sort(ar);
        return ar;
    }

    /**
     * Выдать ресурсы согласно условиям
     * @param type Тип ресурса (дорога, здание и т.д.)
     * @return ar
     */
    public static function getFootballerByType(type:String, teamId:uint):Array{
        var ar:Array = [];
        for each(var item:ItemResource in instance.store) {
            var className:String = item.getItemClass() ;
            if (type == item.getShopType() && teamId == item.getParams().team && className == 'SimpleFootballer') {
                ar.push(item);
            }
        }
        //сортируем предметы по order
        ItemTypeStore.sort(ar);
        return ar;
    }

    /**
     * Сортировка строений согласно XML
     * @param items
     */
    public static function sort(items:Array):void {
        items.sort(itemsComparator);
    }

    /**
     * Писькомер для массивов, возрашает от меньшего к большему
     * @param a
     * @param b
     * @return ar
     */
    public static function itemsComparator(a:ItemResource, b:ItemResource):int {
        if (a.getRequiredLevel() > b.getRequiredLevel()) {
            return 1;
        } else if (a.getRequiredLevel() < b.getRequiredLevel()) {
            return -1;
        } else {
            return 0;
        }
    }

}
}