package  ru.kubline.utils {

public class EndingUtils {
    public function EndingUtils() {
    }

    /**
     * метод для выбора правильного окончания для числа
     * @param number - число
     * @param ending0 - долларов, проверочное число 10
     * @param ending1 - доллар, проверочное число 21
     * @param ending2 - доллара, проверочное число 32
     * @return
     */
    public static function chooseEnding(number:uint, ending0:String, ending1:String, ending2:String):String {
        var num100:uint = number % 100;
        var num10:uint = number % 10;
        if (num100 >= 5 && num100 <= 20) {
            return ending0;
        } else if (num10 == 0) {
            return ending0;
        } else if (num10 == 1) {
            return ending1;
        } else if (num10 >= 2 && num10 <= 4) {
            return ending2;
        } else if (num10 >= 5 && num10 <= 9) {
            return ending0;
        } else {
            return ending2;
        }
    }

    public static function createEndingDollars(dollars:uint):String {
        return chooseEnding(dollars, " долларов", " доллар", " доллара");
    }

    public static function createEndingMinuts(minuts:uint):String {
        return chooseEnding(minuts, " минут", " минута", " минуты");
    }

    public static function createEndingHours(hours:uint):String {
        return chooseEnding(hours, " часов", " час", " часа");
    }

    public static function createEndingCookies(cookies:uint):String {
        return chooseEnding(cookies, " печенек", " печенька", " печеньки");
    }
}
}