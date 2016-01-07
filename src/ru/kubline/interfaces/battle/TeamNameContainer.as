package ru.kubline.interfaces.battle {
import com.greensock.TweenMax;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.interfaces.hint.TeamHint;
import ru.kubline.model.CupPlaces;
import ru.kubline.model.TeamProfiler;
import ru.kubline.store.TourIIIStore;

public class TeamNameContainer extends UIComponent implements IHintProvider {

    private var hintable:Hintable;

    private var teamName:TextField;

    private var teamProfile:TeamProfiler;

    /**
     * ������� �����
     */
    private var hint:TeamHint = null;

    public function TeamNameContainer(container:MovieClip) {
        super(container);
        teamName = TextField(container.getChildByName("teamName"));
        hintable = new Hintable(container);

    }

    public function initContainer(teamProfile:TeamProfiler):void{
        hint = null;
        this.teamProfile = teamProfile;
        teamName.text = teamProfile.getTeamName();

        hintable.setHintProvider(this);

        var champions:CupPlaces = TourIIIStore.getChampionsByType(TourIIIResult.tourType);

        if(Application.teamProfiler.isNewTour()){
 
            switch(teamProfile.getSocialUserId()){
                case champions.first: TweenMax.to(container, 1, {glowFilter:{color:0xF5E48C, alpha:1, blurX:3, blurY:3, strength:13}}); break;
                case champions.second: TweenMax.to(container, 1, {glowFilter:{color:0xFFFFFF, alpha:1, blurX:3, blurY:3, strength:13}});break;
                case champions.third: TweenMax.to(container, 1, {glowFilter:{color:0xCD9A61, alpha:1, blurX:3, blurY:3, strength:13}});break;   
                //case Application.teamProfiler.getSocialUserId(): TweenMax.to(container, 1, {glowFilter:{color:0xFFFFFF, alpha:1, blurX:2, blurY:2, strength:13}});break;
                default: container.filters = [];; break;
            }
        } 
    }

    override public function destroy():void{
        // hint = null;
        hintable.removeHintProvider();
        super.destroy();
    }

    /**
     * ���������� hint ��� ���������� ����� �� ��������
     * <b>������ ����� ������ ������ ����������
     * ���� � ��� �� ������� �����</b>
     */
    public function getHint(): DisplayObject {
        if (hint == null) {
            hint = new TeamHint();
            if (teamProfile) {
                hint.updateHint(teamProfile);
            }
        }
        return hint.getContainer();
    }

}
}