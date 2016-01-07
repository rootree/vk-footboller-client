package ru.kubline.model {

/**
 * класс описывает цену предмета
 */
public class Price {

    /**
     * ежедневынй подарок
     */
    public static const DAILY_BONUS:Price = new Price(50, 0);

    /**
     * награда за одно приглашение друга
     */
    public static const FRIENDS_AWARD:Price = new Price(100, 0);

    public var realPrice:uint;

    public var price:uint;

    public function Price(price:uint, realPrice:uint) {
        this.realPrice = realPrice;
        this.price = price;
    }
}
}