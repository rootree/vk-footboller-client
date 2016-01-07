package ru.kubline.interfaces.hint {
import flash.display.MovieClip;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.utils.MessageUtils;

public class TeamHint {

    private var hintMovie:MovieClip;

    private var teamLogo:MovieClip;
    private var teamLeadAvatar:MovieClip;

    private var paramForward:TextField;
    private var paramHalf:TextField;
    private var paramSafe:TextField;

    private var teamName:TextField;
    private var teamLevel:TextField;
    private var teamLeadName:TextField;

    public function TeamHint() {

        hintMovie = ClassLoader.getNewInstance(Classes.TEAM_HINT);

        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

        teamName = TextField(getContainer().getChildByName("teamName"));
        teamLevel = TextField(getContainer().getChildByName("teamLevel"));
        teamLeadName = TextField(getContainer().getChildByName("teamLeadName"));

        teamLogo = MovieClip(getContainer().getChildByName("teamLogo"));
        teamLeadAvatar = MovieClip(getContainer().getChildByName("teamLeadAvatar"));

    }

    public function getContainer():MovieClip {
        return hintMovie;
    }

    public function updateHint(userProfile:TeamProfiler):void {

        paramForward.text = userProfile.getParamForward().toString();
        paramHalf.text = userProfile.getParamHalf().toString();
        paramSafe.text = userProfile.getParamSafe().toString();

        MessageUtils.optimizeParameterSize(paramForward, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramHalf, 28, 26, 20);
        MessageUtils.optimizeParameterSize(paramSafe, 28, 26, 20);
 
        teamName.text = userProfile.getTeamName();
        teamLevel.text =  userProfile.getLevel().toString() + '-й уровень';

        if(userProfile.getTrainer().getId()){
            teamLeadName.text = userProfile.getTrainer().getName();
            new Gallery(teamLeadAvatar, Gallery.TYPE_FOOTBALLER, userProfile.getTrainer().getId().toString());

        }else{
            teamLeadName.text = UserProfileHelper.getNameTextByProfile(userProfile) ;
            if(userProfile.getSocialData() && userProfile.getSocialData().getPhotoBig()){
                new Gallery(teamLeadAvatar, Gallery.TYPE_OUTSOURCE, userProfile.getSocialData().getPhotoBig());
            }else{
                new Gallery(teamLeadAvatar, Gallery.TYPE_OUTSOURCE, userProfile.getUserPhoto());
            }
        }

        new Gallery(teamLogo, Gallery.TYPE_TEAM, userProfile.getTeamLogoId().toString());

    }

}
}