package ru.kubline.interfaces.menu {
import flash.display.SimpleButton;

import flash.events.Event;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.loader.ClassLoader;

public class NotEnoughMoneyDialog extends UIWindow {

    private var inviteFriendBtn:UISimpleButton;
    private var goInBankBtn:UISimpleButton;


    public function NotEnoughMoneyDialog() {
        super(ClassLoader.getNewInstance(Classes.NOT_ENOUGH_MONEY_DIALOG)); 
    }

    override protected function initComponent():void{
        super.initComponent();

        inviteFriendBtn = new UISimpleButton(SimpleButton(getChildByName("inviteFriend")));
        inviteFriendBtn.addHandler(onInviteFriendClick);
        goInBankBtn = new UISimpleButton(SimpleButton(getChildByName("goInBank")));
        goInBankBtn.addHandler(onGoInBankClick);

    }

    override public function destroy():void{
        goInBankBtn.removeHandler(onGoInBankClick);
        inviteFriendBtn.removeHandler(onInviteFriendClick);
        super.destroy();
    }

    private function onGoInBankClick(e:Event):void {
        hide();
        UserPanel.bankController.showMenu();
    }

    private function onInviteFriendClick(e:Event):void {
        hide();
        var wrapper:Object = Singletons.context.getWrapper();
        if (wrapper != null) {
            wrapper.external.showInviteBox();
        }
    }

}
}