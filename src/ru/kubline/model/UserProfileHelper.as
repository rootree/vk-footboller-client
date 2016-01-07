package ru.kubline.model {
import flash.net.URLRequest;
import flash.net.navigateToURL;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.menu.NotEnoughMoneyDialog;


public class UserProfileHelper {

    public static const MAX_LEN:int = 20;

    /**
     * Возвращает имя игрока которое не больше чем maxLen по длине
     * @param profile профайл игрока
     * @param maxLen максимальная длина
     * @return имя игрока
     */
    public static function getNameTextByProfile(profile:TeamProfiler, inGenName:Boolean = false):String {
        if (profile.getSocialData()) {
            var name:String;
            if(inGenName || TeamProfiler.getIsInstalled() != 1){
                name = profile.getSocialData().getFirstName() + ' ' + profile.getSocialData().getLastName();
            }else{
                name = profile.getSocialData().getServerName();
            }
            
            name = name.replace("ё", "е");
            name = name.replace("Ё", "Е");
            name = name.replace("і", "и");
            name = name.replace("І", "И");    
            name = name.replace("Ї", "Й");
            name = name.replace("ї", "й");    
            name = name.replace("Є", "Е");
            name = name.replace("є", "е");
            name = name.replace("Ґ", "Г");
            name = name.replace("ґ", "г");   
 
            return name;
        }else{
            if(profile.getUserName()){
                return profile.getUserName();
            }else {
                return "N/A";
            }
        }
    }

    public static function trim(word:String, length:uint):String {
        if (word) {

            if (word.length > length) {
                word = word.substring(0, length) + "...";
            }
            word = word.replace("ё", "е");
            word = word.replace("Ё", "Е");
            return word;
        } else {
            return "...";
        }
    }

    /**
     * проверяет достаточно ли денег у игрока и если не достаточно,
     * то показывает деологовое сообщение об этом на экран
     * @param profile профайл игрока для которого проверяем
     * @param moneyType тип денег который интересует
     * @param price цена
     * @return true если достаточно
     */
    public static function isEnoughMoney(profile:TeamProfiler, price:Price):Boolean {
        var isEnoughMoney:Boolean = true;

        if (profile.getRealMoney() < price.realPrice) {
            isEnoughMoney = false;
        }

        if (profile.getMoney() < price.price) {
            isEnoughMoney = false;
        }

        if (!isEnoughMoney) {
            new NotEnoughMoneyDialog().show();
        }
        return isEnoughMoney;
    }

    /**
     * открывает страницу из соц сети самого игрока
     * @param profile профайл игрока чью страницу будем открывать
     */
    public static function showUserPage(profile:TeamProfiler):void {
        navigateToURL(
                new URLRequest(
                        Singletons.vkontakteController.getUserPage(String(profile.getSocialUserId()))
                        ), "_blank");
    }

    /**
     * сортирует по уровню по убыванию
     * @param profiles
     * @return
     */
    public static function sortByLevel(profiles:Array):void {
        profiles.sort(levelComparator);
    }

    /**
     * сортирует по уровню по убыванию
     * @param p1
     * @param p2
     * @return
     */
    public static function levelComparator(p1:TeamProfiler, p2:TeamProfiler):int {
        if (p1.getLevel() > p2.getLevel()) {
            return -1;
        } else if (p1.getLevel() < p2.getLevel()) {
            return 1;
        } else {
            return 0;
        }
    }

    public function UserProfileHelper() {
    }
}

}