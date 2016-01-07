package ru.kubline.interfaces.game {
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.MovieClip;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.loader.Gallery;
import ru.kubline.model.TeamProfiler;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.hint.Hintable;
import ru.kubline.gui.controls.hint.IHintProvider;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.loader.ClassLoader;


/**
 * Класс аватарки пользователя
 * (фото юзера и hint с инфой о нем)
 */
public class UserAvatar extends UIComponent {

    protected var userProfile:TeamProfiler;

    /**
     * панелька с аватаркой
     */
    protected var avatar:MovieClip;

    /**
     * панелька с крутилкой
     */
    protected var loading:MovieClip;

    protected var photo:Loader;

    protected var defaultPhoto:MovieClip;

    public function UserAvatar(avatarPanel:MovieClip, showHint:Boolean = true) {
        super(avatarPanel); 
        avatar = MovieClip(avatarPanel.getChildByName("avatar"));
    }

    public function setProfile(userProfile:TeamProfiler):void {
        if (!this.userProfile || this.userProfile.getSocialUserId() != userProfile.getSocialUserId()) {
            if(userProfile.getSocialData() && userProfile.getSocialData().getPhotoBig()){
                new Gallery(avatar, Gallery.TYPE_OUTSOURCE, userProfile.getSocialData().getPhotoBig());
            }else{
                new Gallery(avatar, Gallery.TYPE_OUTSOURCE, userProfile.getUserPhoto());
            }
        }
        this.userProfile = userProfile;
    }

 
    public function getUserProfile():TeamProfiler {
        return userProfile;
    }}
}