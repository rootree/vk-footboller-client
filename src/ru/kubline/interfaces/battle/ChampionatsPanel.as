package ru.kubline.interfaces.battle {
import flash.text.TextField;

import ru.kubline.gui.controls.UIComponent;
import flash.display.MovieClip;

import ru.kubline.loader.Gallery;
import ru.kubline.model.CupPlaces;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.store.TeamProfilesStore;
import ru.kubline.store.TourIIIStore;
import ru.kubline.utils.MessageUtils;


public class ChampionatsPanel extends UIComponent  {

    private var teamLevel:TextField;
    private var teamLeadName:TextField;
    private var teamName:TextField;
   
    private var paramForward:TextField;
    private var paramHalf:TextField;
    private var paramSafe:TextField;

    private var secondPlaceName:TextField;
    private var thirdPlaceName:TextField;
 
    public function ChampionatsPanel(container:MovieClip) {
        super(container);
    }

    override protected function initComponent():void{
        super.initComponent();
 
        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

        teamLevel = TextField(getContainer().getChildByName("teamLevel"));
        teamLeadName = TextField(getContainer().getChildByName("teamLeadName"));
        teamName = TextField(getContainer().getChildByName("teamName")); 

        secondPlaceName = TextField(getContainer().getChildByName("secondPlaceName"));
        thirdPlaceName = TextField(getContainer().getChildByName("thirdPlaceName"));
    }

    override public function destroy():void{ 
        super.destroy();
    }
 
    public function initTeams(tourType:uint):void{
 
        var cups:CupPlaces = TourIIIStore.getChampionsByType(tourType);

        var firstPlaceTeam:TeamProfiler = TeamProfilesStore.getProfileById(cups.first);
        var secondPlaceTeam:TeamProfiler = TeamProfilesStore.getProfileById(cups.second);
        var thirdPlaceTeam:TeamProfiler = TeamProfilesStore.getProfileById(cups.third);
      
        paramForward.text = firstPlaceTeam.getParamForward().toString();
        paramHalf.text = firstPlaceTeam.getParamHalf().toString();
        paramSafe.text = firstPlaceTeam.getParamSafe().toString();

        MessageUtils.optimizeParameterSize(paramForward, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramHalf, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramSafe, 28, 26, 20);

        teamLevel.text = firstPlaceTeam.getLevel().toString() + "-й уровень";
        teamName.text = firstPlaceTeam.getTeamName();


        if(firstPlaceTeam.getTrainer().getId()){
            teamLeadName.text = firstPlaceTeam.getTrainer().getName();
        }else{
            teamLeadName.text = UserProfileHelper.getNameTextByProfile(firstPlaceTeam);
        }

        if(firstPlaceTeam.getTrainer().getId()){
            new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_FOOTBALLER, firstPlaceTeam.getTrainer().getId().toString());
        }else{
            if(Application.VKIsEnabled){

                if(firstPlaceTeam.getSocialData() && firstPlaceTeam.getSocialData().getPhotoBig()){
                    new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_OUTSOURCE, firstPlaceTeam.getSocialData().getPhotoBig());
                }else{
                    new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_OUTSOURCE, firstPlaceTeam.getUserPhoto());
                }

            }else{
                new Gallery(MovieClip(getChildByName("teamLeadAvatar")), Gallery.TYPE_OUTSOURCE, "3000");
            }
        }
        
        secondPlaceName.text = secondPlaceTeam.getTeamName();
        thirdPlaceName.text = thirdPlaceTeam.getTeamName();

        new Gallery(MovieClip(getChildByName("teamLogo")), Gallery.TYPE_TEAM, firstPlaceTeam.getTeamLogoId().toString());
        new Gallery(MovieClip(getChildByName("secondPlaceAva")), Gallery.TYPE_TEAM, secondPlaceTeam.getTeamLogoId().toString());
        new Gallery(MovieClip(getChildByName("thirdPlaceAva")), Gallery.TYPE_TEAM, thirdPlaceTeam.getTeamLogoId().toString());

    }

 
}
}