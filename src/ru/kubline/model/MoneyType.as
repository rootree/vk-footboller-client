package ru.kubline.model {

/**
 * класс описывает тип игровых денег
 * @author denis
 */
public class MoneyType {

    public static const MONEY:MoneyType = new MoneyType(1);

    public static const REAL_MONEY:MoneyType = new MoneyType(0);

    public var value:int;

    public function MoneyType(value:int) {
        this.value = value;
    }
}
}