package ru.kubline.interfaces.menu.shop.footballes {

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.errors.IllegalOperationError;
import flash.events.MouseEvent;
import flash.text.TextField;



import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.display.SimpleFootballer;
import ru.kubline.display.SimpleTeam;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.game.UIPriceContainer;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;

/**
 * Элемент основного магазина
 */
public class FootballersItem extends UIMenuItem implements IHintProvider{

    /**
     * Контейнер иконки элемента
     */
    private var iconPanel:MovieClip;

    /**
     * Иконка элемента
     */
    private var elementIcon:MovieClip;

    /**
     * Контейнер цен
     */
    private var priceContainer:UIPriceContainer;


    private var peopleName:TextField;
    private var peopleLevel:TextField; 

    private var peoplePrice:PriceContainer;

    private var hintable:Hintable;

    /**
     * инстанс хинта
     */
    private var hint:MovieClip = null;

    //  private var levelGrid:QuantityPanel;

    private var width:uint;
    private var height:uint;

    private var fType:MovieClip;


    private var lockLevel:TextField;
    private var lock:MovieClip;

    
    /**
     *
     * @param container
     */
    public function FootballersItem(container:MovieClip) {
        super(container); 
    }

    override protected function initComponent():void{
        super.initComponent();

       iconPanel = MovieClip(getChildByName("icon"));

        width = iconPanel.width - 3;
        height = iconPanel.height - 3;

        peopleName = TextField(getChildByName("peopleName"));
        peopleLevel = TextField(getChildByName("paramValue"));
        peoplePrice = new PriceContainer(MovieClip(getChildByName("pricer")));
        fType = MovieClip(getChildByName("fType"));

        lock = MovieClip(getChildByName("lock"));
        lockLevel = TextField(lock.getChildByName("level"));

        container.addEventListener(MouseEvent.CLICK, this.onMouseClick);

        hint = null;

        hintable = new Hintable(container);
        hintable.setHintProvider(this);

    }
 
    /**
     * Настраиваем элемент магазина
     * @param value
     */
    override public function setItem(value:Object):void {

    //    initComponent();
        
        super.setItem(value);
        hint = null;
        var itemR:ItemResource = ItemResource(value);

        peoplePrice.setPrice(itemR.getPrice(), true, true);

        if(itemR.getShopType() == ItemTypeStore.TYPE_TEAMLEAD){
            fType.gotoAndStop("type5");
            peopleLevel.text = "+" + itemR.getParams().studyRate ;
        }else{
            fType.gotoAndStop("type" + itemR.getShopType());
            peopleLevel.text = "+" + itemR.getParams().level ;
        }

        new Gallery(iconPanel, Gallery.TYPE_FOOTBALLER, itemR.getId().toString());
        peopleName.text = itemR.getName();
        super.getContainer().visible = true;


        if(Application.teamProfiler.getLevel() >= itemR.getRequiredLevel()){
            lock.visible = false;
        }else{
            lock.visible = true;
            lockLevel.text = itemR.getRequiredLevel().toString();
        }
        
        setSelectable(item != null);
        setDisabled(item == null);
 
    }

    override public function destroy():void {
        container.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        setItem(null);
        super.destroy();
    }



    private function updateHint(itemR:ItemResource):void {

        // var footboller:SimpleFootballer = SimpleFootballer(itemR);

        var action:TextField = hint.getChildByName("action") as TextField;
        var peopleName:TextField = hint.getChildByName("peopleName") as TextField;
        var peopleTeam:TextField = hint.getChildByName("peopleTeam") as TextField;
        var peopleCups:TextField = hint.getChildByName("peopleCups") as TextField;
        var peopleLevel:TextField = hint.getChildByName("peopleLevel") as TextField;
        var peopleYear:TextField = hint.getChildByName("peopleYear") as TextField;
        var countries:MovieClip = hint.getChildByName("countries") as MovieClip;
        var iconPanel:MovieClip = hint.getChildByName("iconPanel") as MovieClip;

        if(itemR.getShopType() == ItemTypeStore.TYPE_TEAMLEAD){
            action.text = 'Тренирует';
        }else{
            action.text = 'Играет за';
        }

        peopleName.text = itemR.getName();
        if(itemR.getRequiredLevel() > Application.teamProfiler.getLevel()){
            if(itemR.getShopType() == ItemTypeStore.TYPE_TEAMLEAD){
                peopleLevel.htmlText = 'Вы можете пригласить этого тренера в свой клуб только с <font color="#E40303">' + itemR.getRequiredLevel() +'</font>-го уровня';
            }else{
                peopleLevel.htmlText = 'Вы можете взять в команду этого футболиста только с <font color="#E40303">' + itemR.getRequiredLevel() + '</font>-го уровня';
            }

        }else{
            peopleLevel.text = itemR.getName() + " с радостью вступит в ваш клуб в любое время";
        }

        Singletons.statistic.increaseShopItem(itemR.getId(), Statistics.SHOP_ACTION_HOVER);

        if(itemR.getParams().year){
            peopleYear.text = itemR.getParams().year;
        }else{
            peopleYear.text = '19----';
        }


        if(!itemR.getParams().team){
            throw new IllegalOperationError("Номер команды ненайден");
        }

        if(!ItemTypeStore.getItemResourceById(itemR.getParams().team)){
            throw new IllegalOperationError("Команда по номеру " + itemR.getParams().team + " не найдена");
        }

        var teamPesorse:ItemResource = ItemTypeStore.getItemResourceById(itemR.getParams().team);
        peopleTeam.text = String(teamPesorse.getName());
  
        if(!teamPesorse.getParams().cup){
            throw new IllegalOperationError("Номер чемпионата не найден");
        }

        if(!ItemTypeStore.getItemResourceById(teamPesorse.getParams().cup)){
            throw new IllegalOperationError("Чемпионат по номеру " + teamPesorse.getParams().cup + " не найден");
        }

        var teamCup:ItemResource = ItemTypeStore.getItemResourceById(teamPesorse.getParams().cup);
        peopleCups.text =  String(teamCup.getName()) ;

        countries.gotoAndStop("country" + teamCup.getParams().ccode);

        new Gallery(iconPanel, Gallery.TYPE_FOOTBALLER, itemR.getId().toString());

    }

    /**
     * отображает hint при наведениии мышки на аватарку
     * <b>данный метод должен всегда возвращать
     * один и тот же инстанс хинта</b>
     */
    public function getHint(): DisplayObject {
        if (hint == null) {
            hint = ClassLoader.getNewInstance(Classes.MAIN_SHOP_HINT);
            if (item) {
                updateHint(ItemResource(item));
            }
        }
        return hint;
    }

}
}