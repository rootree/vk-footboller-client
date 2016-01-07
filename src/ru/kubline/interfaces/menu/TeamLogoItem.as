package ru.kubline.interfaces.menu {
import flash.display.MovieClip;

import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.resources.ItemResource;

public class TeamLogoItem extends UIMenuItem{
 
    private var iconPanel:UIComponent;
 
    /**
     *
     * @param container
     */
    public function TeamLogoItem(container:MovieClip) {
        super(container); 
        iconPanel = new UIComponent(MovieClip(getChildByName("icon")));
    }

    override public function setItem(value:Object):void {

        super.setItem(value);

        var item:ItemResource = ItemResource(value);

        if (item) {
            new Gallery(MovieClip(iconPanel.getContainer()), Gallery.TYPE_TEAM, item.getId().toString());
            super.getContainer().visible = true;
            iconPanel.setQtip(item.getName());

        } else {
            setDisabled(false);
        }
        setSelectable((item != null));
    }

    override public function destroy():void {
        setItem(null);
        super.destroy();
    }

}
}