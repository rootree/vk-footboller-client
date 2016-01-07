package ru.kubline.interfaces.menu.team {
import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.InterfaceEvent;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.ChooserJobMenu;
import ru.kubline.interfaces.menu.friends.FriendAvatar;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.interfaces.window.Message;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ItemUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:59:44 PM
 */

public class UserPlayersItem extends UIMenuItem implements IHintProvider{

    public static const COLOR_SELECTED:uint = 0x425380;
    
    public static const COLOR_UNSELECTED:uint = 0xC5CCE0;

    public static const COLOR_SELECTED_FAVORITE:uint = 0x4A5B8C;

    public static const COLOR_UNSELECTED_FAVORITE:uint = 0xFFFFFF;
    /**
     * инстанс хинта
     */
    private var hint:MovieClip = null;

    /**
     * Контейнер иконки элемента
     */
    private var iconPanel:MovieClip;
    
    private var health:MovieClip;

    private var fType:MovieClip;
    
    private var cellParametersBG:MovieClip;
    
    private var starFootball:MovieClip;

    private var levelPlayer:TextField;

    private var itemStore:UserPlayersMenu;

    private var hintable:Hintable;
    /**
     *
     * @param container
     */
    public function UserPlayersItem(container:MovieClip) {
        super(container);
        iconPanel = MovieClip(getChildByName("icon"));
        fType = MovieClip(getChildByName("fType"));
        cellParametersBG = MovieClip(getChildByName("cellParametersBG")); 
        starFootball = MovieClip(getChildByName("star"));
        health = MovieClip(getChildByName("health"));
        levelPlayer = TextField(getChildByName("playerLevel"));
 
        hint = null;

        hintable = new Hintable(container);
        hintable.setHintProvider(this);
    }
 

    public static function updateHint(itemR:Object, hint:MovieClip):void {

        var player:Footballer = Footballer(itemR);
        // var footboller:SimpleFootballer = SimpleFootballer(itemR);

        var peopleName:TextField = hint.getChildByName("peopleName") as TextField;
        var peopleTeam:TextField = hint.getChildByName("peopleTeam") as TextField;
        var peopleCups:TextField = hint.getChildByName("peopleCups") as TextField;
        var peopleYear:TextField = hint.getChildByName("peopleYear") as TextField;
        var peopleStyle:TextField = hint.getChildByName("peopleStyle") as TextField;
        var countries:MovieClip = hint.getChildByName("countries") as MovieClip;
        var iconPanel:MovieClip = hint.getChildByName("iconPanel") as MovieClip;
        var favorite:MovieClip = hint.getChildByName("favorite") as MovieClip;

        favorite.visible = player.isFavorite(); 

        if(player.getIsFriend()){

            if(player.getTeamName()){
                peopleTeam.text = player.getTeamName();
            }else{
                peopleTeam.text = Application.teamProfiler.getTeamName();
            }

            new Gallery(iconPanel, Gallery.TYPE_OUTSOURCE, player.getPhoto());

            var freand:TeamProfiler = FriendProfilesStore.getFriendById(itemR.getId()); 
            peopleYear.text = (player.getYear()
                    ? player.getYear().toString()
                    : ((freand && freand.getSocialData() && freand.getSocialData().getBirthday())
                        ? freand.getSocialData().getBirthday().getFullYear().toString()
                        : "----")
                    );
            
            countries.gotoAndStop('country' + player.getCountryCode());

            peopleName.text = (player.getFootballerName() ? player.getFootballerName() : UserProfileHelper.getNameTextByProfile(freand));
            peopleCups.text = "Чемпионат ВКонтакта" ;

            new Gallery(iconPanel, Gallery.TYPE_OUTSOURCE, (freand && freand.getSocialData() && freand.getSocialData().getPhotoBig())
                    ? freand.getSocialData().getPhotoBig()
                    : player.getPhoto()
                );

            if(peopleYear.text == '0' || peopleYear.text == 'NaN'){
                peopleYear.text = "--";
            }
        }else{
            var item:ItemResource = ItemTypeStore.getItemResourceById(player.getId());
            new Gallery(iconPanel, Gallery.TYPE_FOOTBALLER, player.getId().toString());


            if(item.getParams().year){
                peopleYear.text = item.getParams().year;
            }else{
                peopleYear.text = '19----';
            }

            if(!item.getParams().team){
                throw new IllegalOperationError("Номер команды ненайден");
            }

            if(!ItemTypeStore.getItemResourceById(item.getParams().team)){
                throw new IllegalOperationError("Команда по номеру " + item.getParams().team + " не найдена");
            }

            var teamPesorse:ItemResource = ItemTypeStore.getItemResourceById(item.getParams().team);
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

            new Gallery(iconPanel, Gallery.TYPE_FOOTBALLER, item.getId().toString());

            peopleName.text = item.getName();

        }

        peopleStyle.text = player.getTypeToString();

    }

    /**
     * Настраиваем элемент магазина
     * @param value
     */
    override public function setItem(value:Object):void {
        super.setItem(value);

        starFootball.visible = false;    
        hint = null;

        var player:Footballer = Footballer(value);
        if (player.getId()) {

            if(health){
                health.visible = Boolean(player.getHealthDown());
            }

            if(player.isFavorite()){
                TweenMax.to(cellParametersBG, 0.5, {tint:COLOR_SELECTED_FAVORITE});
                levelPlayer.textColor = COLOR_UNSELECTED_FAVORITE;
                starFootball.visible = true;
            }else{
                TweenMax.to(cellParametersBG, 0.5, {tint:COLOR_UNSELECTED});
                levelPlayer.textColor = COLOR_SELECTED;
            }

            levelPlayer.visible = Boolean(player.getLevel());
            levelPlayer.text = "+" + player.getLevel().toString();

            if(player.getIsFriend()){
                new Gallery(iconPanel, Gallery.TYPE_OUTSOURCE, player.getPhoto());
            }else{
                var item:ItemResource = ItemTypeStore.getItemResourceById(player.getId());
                new Gallery(iconPanel, Gallery.TYPE_FOOTBALLER, player.getId().toString());
            }

            if(player.getType() == "0"){
                fType.visible = false;
            }else{
                fType.visible = true;
                fType.gotoAndStop("type" + player.getType());
            }

            super.getContainer().visible = true;

        }
        setSelectable(player != null);
        setDisabled(player == null);
    }

    override public function destroy():void {
        setItem(null);
        if (hintable) {
            hintable.removeHintProvider();
        }
        super.destroy();
    }


    /**
     * отображает hint при наведениии мышки на аватарку
     * <b>данный метод должен всегда возвращать
     * один и тот же инстанс хинта</b>
     */
    public function getHint(): DisplayObject {
        if (hint == null) {
             
            hint = ClassLoader.getNewInstance(Classes.FOOTBOLLER_HINT);
            if (item) {
                updateHint(item, hint);
            }
        }
        return hint;
    }

}
}