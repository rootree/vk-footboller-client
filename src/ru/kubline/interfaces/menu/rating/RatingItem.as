package ru.kubline.interfaces.menu.rating {
import flash.display.DisplayObject;

import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.interfaces.game.UserAvatar;
import ru.kubline.interfaces.hint.TeamHint; 
import flash.display.MovieClip;
import flash.text.TextField;
import ru.kubline.model.TeamProfiler;
import ru.kubline.utils.MessageUtils;

public class RatingItem extends UserAvatar implements IUIMenuItem, IHintProvider{

    private var teamName:TextField;
    private var win:TextField;
    private var choose:TextField;
    private var lose:TextField;
    private var place:TextField;
    private var medal:MovieClip;
    /**
     * ������� �����
     */
    private var hint:TeamHint = null;

    private var hintable:Hintable;
    private var selectable:Boolean;

    /**
     *
     * @param container
     */
    public function RatingItem(container:MovieClip) {
        
        super(container);

        teamName = TextField(container.getChildByName("teamName"));
        win = TextField(container.getChildByName("win"));
        choose = TextField(container.getChildByName("choose"));
        lose = TextField(container.getChildByName("lose"));
        place = TextField(container.getChildByName("place"));
        medal = MovieClip(container.getChildByName("medal"));

        hintable = new Hintable(container);
        hintable.setHintProvider(this);

    }

    public function setItem(value:Object):void {

        if (value) {

            var userProfile:TeamProfiler = TeamProfiler(value);
            super.setProfile(userProfile);
            super.getContainer().visible = true;

            teamName.text = userProfile.getTeamName();
            win.text = userProfile.getCounterWin().toString() ;
            choose.text = userProfile.getCounterChoose().toString();
            lose.text = userProfile.getCounterLose().toString();
            place.text = (userProfile.getPlaceInWorld() > 0)
                ? userProfile.getPlaceInWorld().toString()
                : Application.teamProfiler.getTotalPlace().toString();


            MessageUtils.optimizeParameterSize(place, 33, 30, 25);

            medal.visible = Boolean(userProfile.getPlaceInWorld() <= 3 && userProfile.getPlaceInWorld() > 0);
            medal.gotoAndStop("place" + userProfile.getPlaceInWorld());

        } else {
            super.getContainer().visible = false;
        }
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }

    public function getHint(): DisplayObject {
        if (hint == null) {
            hint = new TeamHint();
            if (userProfile) {
                hint.updateHint(userProfile);
            }
        }
        return hint.getContainer();
    }
    public function getItem():Object {
        return getUserProfile();
    }

    public function setSelected(selected:Boolean):void {
        this.selectable = selected; 
    }

    public function isSelected():Boolean {
        return selectable;
    }

    public function setSelectable(value:Boolean):void {
        selectable = value;
    }

    public function isSelectable():Boolean {
        return selectable;
    }
}
}