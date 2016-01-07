package ru.kubline.controllers {

import flash.events.Event;

import flash.events.IOErrorEvent;

import ru.kubline.events.InterfaceEvent;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.BankMenu;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.model.MoneyType;
import ru.kubline.net.HTTPConnection;
import ru.kubline.social.events.LoadBalanceEvent;

public class BankController {

    private var bankMenu:BankMenu;

    private var choosedMoneyType:MoneyType;

    public function BankController() {
        choosedMoneyType = null;
        this.bankMenu = new BankMenu();
    }

    /**
     * Отправляем сообщение на сервер о покупке денех
     * @param e
     */
    private function onBuyCurrency(e:Event):void {
        bankMenu.hide();
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_ADD_MONEY, onBuyedCurrency);
        Singletons.connection.send(HTTPConnection.COMMAND_ADD_MONEY, {moneyType:bankMenu.getSelectedMoneyType().value, value:bankMenu.getSelectedValues()});
    }

    /**
     * Отправляем сообщение на сервер о покупке денех
     * @param e
     */
    private function onBuyedCurrency(e:Event):void {
        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_ADD_MONEY, onBuyedCurrency);
        var result:Object = HTTPConnection.getResponse();
        if(result.balance){
            Application.teamProfiler.setMoney(result.balance.money);
            Application.teamProfiler.setRealMoney(result.balance.realMoney);
            new MessageBox("Сообщение", "Ваш игровой баланс успешно пополнен.", MessageBox.OK_BTN).show();
        }
        if(Application.mainMenu.shop){
            Application.mainMenu.shop.updateMoney();
        }
        Application.mainMenu.userPanel.update();
    }

    /**
     * Запрашиваем кол-во голосов в соц.сети у пользователя
     */
    private function loadUserBalance():void {
        Singletons.loadingMsg.start("Получение баланса приложения");
        Singletons.vkontakteController.addEventListener(LoadBalanceEvent.LOAD_USER_BALANCE, onLoadUserBalance);
        Singletons.vkontakteController.getUserBalance();
    }

    /**
     * Устанавливаем полученный баланс в меню банка
     * @param e
     */
    private function onLoadUserBalance(e:LoadBalanceEvent):void {
        Singletons.vkontakteController.removeEventListener(LoadBalanceEvent.LOAD_USER_BALANCE, onLoadUserBalance); 
        Singletons.loadingMsg.delayHide("Баланс получен");

        if (!e.success) {
            new MessageBox(Messages.getMessage("TITLE_ERROR"), Messages.getMessage("ERROR_SOCIAL"), MessageBox.OK_BTN).show();
            return;
        }

        bankMenu.show();

        bankMenu.setBalance(e.balance);
  
        if(choosedMoneyType != null){
            bankMenu.setIsRealTypeSelected((choosedMoneyType == MoneyType.REAL_MONEY));
            bankMenu.exchangeStepII();
        }
    }

    /**
     * Вызываем окно соц.сети о пополнеии баланса приложения
     * @param e
     */
    private function onChangeBalance(e:Event):void {
        var wrapper:Object = Singletons.context.getWrapper();
        if (wrapper != null) {
            wrapper.addEventListener("onBalanceChanged", onBalanceChanged);
            wrapper.external.showPaymentBox();
        }
    }

    /**
     * Перехватываем сообщение от соц.врапера об изменении баланса
     * @param e
     */
    private function onBalanceChanged(e: Object): void {
        var wrapper:Object = Singletons.context.getWrapper();
        wrapper.removeEventListener("onBalanceChanged", onBalanceChanged);
        bankMenu.setBalance(e.balance / 100);
    }

    /**
     * Показываем окошко банка
     */
    public function showMenu(moneyType:MoneyType = null):void {
        this.choosedMoneyType = moneyType;
        if(bankMenu){
            bankMenu.addEventListener(InterfaceEvent.BUY_CURRENCY, this.onBuyCurrency);
            bankMenu.addEventListener(InterfaceEvent.CHANGE_BALANCE, this.onChangeBalance);
        }
        loadUserBalance();
    }

}

}