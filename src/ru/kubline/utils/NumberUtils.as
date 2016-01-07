package  ru.kubline.utils  {
public class NumberUtils {

    public static const SYMBOL:String = " ";

    public function NumberUtils() {
    }

    public static function toNumberFormat(num:int):String {
        var str:String = String(num);
        var len:int = str.length;

        str = revertString(str);

        var pos:int = 3;

        while(len > 3) {
            str = str.substring(0, pos) + SYMBOL + str.substring(pos, str.length);
            len -= 3;
            pos +=4;
        }

        str = revertString(str);

        return str;
    }

    private static function revertString(str:String):String {
        var revertStr:String = "";

        for (var i:int=0; i<str.length; i++) {
            revertStr += str.charAt(str.length-i-1);
        }

        return revertStr;
    }
}
}