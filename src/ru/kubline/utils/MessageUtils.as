package  ru.kubline.utils  {
import flash.text.TextField;

import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.model.TeamProfiler;

public class MessageUtils {

    public static function showErrorMsgWithSound(title:String, status:int, msgList:Object, defaultMsg:String = "", noButtons:Boolean = false):void {
        var msg:String = msgList[status] ? msgList[status] : defaultMsg;
        new MessageBox(title, msg, noButtons ? MessageBox.BTN_NONE : MessageBox.OK_BTN).show();
    }

    public static function showMsg(title:String, status:int, msgList:Object, defaultMsg:String = "", noButtons:Boolean = false):void {
        var msg:String = msgList[status] ? msgList[status] : defaultMsg;
        new MessageBox(title, msg, noButtons ? MessageBox.BTN_NONE : MessageBox.OK_BTN).show();
    }

    public static function wordBySex(user:TeamProfiler, forMan:String, forWoman:String):String {
        var userSexId:uint = user.getSocialData().getSex();
        if(userSexId != 1){
            return forWoman;
        }else{
            return forMan;
        }
    }

    public function MessageUtils() {
    }

    public static function converDateToStr(date:Date):String {
        var D:uint = date.getDate();
        var Mi:uint = date.getMonth()+ 1;
        var M:String = Mi.toString();
        switch (Mi){
            case 1: M = "января"; break;
            case 2: M = "февраля"; break;
            case 3: M = "марта"; break;
            case 4: M = "апреля"; break;
            case 5: M = "мая"; break;
            case 6: M = "июня"; break;
            case 7: M = "июля"; break;
            case 8: M = "августа"; break;
            case 9: M = "сентября"; break;
            case 10: M = "октября"; break;
            case 11: M = "ноября"; break;
            case 12: M = "декабря"; break;
        }

        var Y:uint = date.getFullYear();

        var theDate:String = (D + " " + M + " " + Y);
        return theDate;
    }


    public static function converTimeToShortString(sec:uint):String {

        var seconds:uint;
        var minutes:uint;
        var hours:uint;

        var secondsStr:String;
        var minutesStr:String;
        var hoursStr:String;
        var returnTime:String;

        seconds = sec % 60;
        minutes = (sec - seconds) / 60;
        minutes = minutes % 60;
        hours = (sec - minutes * 60 - seconds) / 3600;
 
        secondsStr = seconds.toString();
        minutesStr = minutes.toString();
        hoursStr = hours.toString();

        if (secondsStr.length == 1) { secondsStr = "0" + secondsStr; }
        if (minutesStr.length == 1) { minutesStr = "0" + minutesStr; }
        if (hoursStr.length == 1) { hoursStr = "0" + hoursStr; }

        returnTime = hoursStr + ":" + minutesStr + ":" + secondsStr;

        return returnTime;
    }


    public static function optimizeParameterSize(field:TextField,three:uint = 28, four:uint = 20, fife:uint = 17):void{

        var size:uint = three;
        switch (field.length){
            case 5:
                size = fife; 
                break;
            case 4:
                size = four;
                break;
        }
        field.htmlText = "<font size='" + size + "'>" + field.text + "</font>";
    }

}
}