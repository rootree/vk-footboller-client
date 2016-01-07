package ru.kubline.interfaces.menu {

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.TextEvent;
import flash.text.TextField;

import flash.text.TextFieldAutoSize;

import ru.kubline.comon.Classes;
import ru.kubline.comon.ExchangeRate;
import ru.kubline.events.InterfaceEvent;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.gui.controls.Slider;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.loader.ClassLoader;
import ru.kubline.model.MoneyType;

public class BankMenu extends UIWindow {

    /**
     * Кнопка закрытия
     */
    private var closeBtn:UISimpleButton;

    /**
     * Кнопка купить
     */
    private var buyBtn:UIButton;

    /**
     * Кнобка обмена игровых денег
     */
    private var exchangeMoneyBtn:UISimpleButton;

    /**
     * Кнобка обмена реальных денег
     */
    private var exchangeRealMoneyBtn:UISimpleButton;

    /**
     * Контейнер первого шага
     */
    private var stepI:UIComponent;

    /**
     * Контейнер второго шага
     */
    private var stepII:UIComponent;

    /**
     * Курс обмена
     */
    private var exchangeRate:TextField;

    private var balance:TextField;
    private var voices:TextField;

    private var exchangeInfo:TextField;

    /**
     * При втором шаге выбраны реильные деньги или игровые
     */
    private var isRealMoneyChoosed:Boolean;

    private var selectedValue:uint;
    
    private var slider:Slider;

    private var choosedMoneyType:MoneyType;

    public function BankMenu() {

        super(ClassLoader.getNewInstance(Classes.BANK_PANEL));
 
    }

    override protected function initComponent():void{
        super.initComponent();

        // Кнопка закрытия
        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        // Кнопка покупки валюты
        buyBtn = new UIButton(MovieClip(getChildByName("buyBtn")));
        buyBtn.addHandler(onBuyMoney);

        // Разделяем шаги банка по контейнерам
        stepI = new UIComponent(DisplayObjectContainer(getChildByName("stepI")));
        stepII = new UIComponent(DisplayObjectContainer(getChildByName("stepII")));

        // Кнопка выбора игровых денег
        exchangeMoneyBtn = new UISimpleButton(SimpleButton(stepI.getContainer().getChildByName("exchangeMoney")));
        exchangeMoneyBtn.addHandler(onChooseMoney);

        // Кнопка выбора реальных денег
        exchangeRealMoneyBtn = new UISimpleButton(SimpleButton(stepI.getContainer().getChildByName("exchangeRealMoney")));
        exchangeRealMoneyBtn.addHandler(onChooseRealMoney);

        // Разбираемся с элементами шага 2
        exchangeRate = TextField(stepII.getContainer().getChildByName("exchangeRate"));

        exchangeInfo = TextField(stepII.getContainer().getChildByName("exchangeInfo"));
        exchangeInfo.addEventListener(TextEvent.LINK, onChangeBalanceClick);

        balance = TextField(stepII.getContainer().getChildByName("voices"));;
        voices = TextField(stepII.getContainer().getChildByName("money"));;

        slider = new Slider(MovieClip(stepII.getContainer().getChildByName("slider")), false);
        slider.addEventListener(Event.CHANGE, onSliderMove);

    }

    override public function destroy():void{
        exchangeMoneyBtn.removeHandler(onChooseMoney);
        buyBtn.removeHandler(onBuyMoney);
        closeBtn.removeHandler(onCloseClick);
        slider.removeEventListener(Event.CHANGE, onSliderMove);
        exchangeInfo.removeEventListener(TextEvent.LINK, onChangeBalanceClick);
        super.destroy();
    }

    /**
     * Изменяем слайдер, меняем курс
     * @param event
     */
    private function onSliderMove(event:Event):void {
        balance.text = (slider.getValue()).toString();
        voices.text = (slider.getValue() * getChoosedCurrency()).toString();
        buyBtn.setDisabled(slider.getValue() < 1);
    }

    /**
     * Производим покупку
     * @param event
     */
    private function onBuyMoney(event:Event):void{
        selectedValue = slider.getValue();
        if(selectedValue > 0){
            this.dispatchEvent(new Event(InterfaceEvent.BUY_CURRENCY)); 
        }
    }

    private function onChooseMoney(event:Event):void{
        isRealMoneyChoosed = false;
        choosedMoneyType = MoneyType.MONEY;
        exchangeStepII();
    }

    private function onChooseRealMoney(event:Event):void{
        isRealMoneyChoosed = true;
        choosedMoneyType = MoneyType.REAL_MONEY;
        exchangeStepII();
    }

    public function setIsRealTypeSelected(isSelected:Boolean):void{
        isRealMoneyChoosed = isSelected;
        choosedMoneyType = (isSelected) ? MoneyType.REAL_MONEY : MoneyType.MONEY; 
    }

    /**
     * Переходим к второму шагу покупки, после выбора на что хотим поменять голоса (реалы/игровые)
     */
    public function exchangeStepII():void{
        // Скрываем выбор валют и отображаем ползунок
        stepI.getContainer().visible = false;
        stepII.getContainer().visible = true;

        // Показываем кнопку купить
        buyBtn.getContainer().visible = true;

        if(isRealMoneyChoosed){
            exchangeRate.htmlText = ExchangeRate.VOICE_VS_REAL_MONEY.toString();
        }else{
            exchangeRate.htmlText = ExchangeRate.VOICE_VS_MONEY.toString();
        }
        // exchangeRate.htmlText = "<B>" + exchangeRate.htmlText + "</B>";

        stepII.getContainer().getChildByName("realMoneyRed").visible = isRealMoneyChoosed;
        stepII.getContainer().getChildByName("moneyRed").visible = !isRealMoneyChoosed;

        // Выравниваем кнопки по центру
        var shiftCloseBtn:uint = 15;

        buyBtn.getContainer().x = getContainer().width / 2 - (buyBtn.getContainer().width + shiftCloseBtn + closeBtn.getContainer().width ) / 2;
        closeBtn.getContainer().x =  buyBtn.getContainer().x + buyBtn.getContainer().width + shiftCloseBtn;
        /*
        closeBtn.getContainer().x = getContainer().width / 2 - (closeBtn.getContainer().width + shiftCloseBtn + buyBtn.getContainer().width ) / 2;
        buyBtn.getContainer().x =  closeBtn.getContainer().x + closeBtn.getContainer().width + shiftCloseBtn;*/
    }

    /**
     * Первый шаг в банке, выбор валюты
     */
    public override function show():void{
        super.show();
        // Скрываем ползунок и курс обмена
        stepI.getContainer().visible = true;
        stepII.getContainer().visible = false;
        // Скрываем кнопку покупки
        buyBtn.getContainer().visible = false;
        closeBtn.getContainer().x =  getContainer().width / 2 - closeBtn.getContainer().width / 2;
    }

    /**
     * Что на ползунке выбранно
     * @return
     */
    public function getSelectedValues():uint {
        return selectedValue;
    }

    public function getSelectedMoneyType():MoneyType {
        return choosedMoneyType;
    }

    /**
     * Устанавливаем максимальные значения для ползунка
     * @param value
     */
    public function setBalance(value:uint):void {
        slider.setMaxValue(value);
        slider.setValue(0);

        voices.text = balance.text = "0";
        buyBtn.setDisabled(true);

        exchangeInfo.autoSize = TextFieldAutoSize.CENTER;
        exchangeInfo.wordWrap = true;
        exchangeInfo.htmlText = value ? "Вы всегда можете пополнить Ваш игровой баланс" : Messages.sprintf('<font color="#E40303">На Вашем счету нет голосов.</font> Чтобы пополнить счет, нажмите <u><a href="{0}">здесь</a></u>', "event:changeBalance");

    }

    /**
     * Получаем тип выбранной валюты
     * @return
     */
    public function getChoosedCurrency():uint {
        if(isRealMoneyChoosed){
            return ExchangeRate.VOICE_VS_REAL_MONEY;
        }else{
            return ExchangeRate.VOICE_VS_MONEY;
        }
    }

    /**
     * Вызываем врапер для внечения голосов в приложения
     * @param event
     */
    private function onChangeBalanceClick(event:TextEvent):void {
        dispatchEvent(new Event(InterfaceEvent.CHANGE_BALANCE));
    }
}
}