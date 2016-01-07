package ru.kubline.model {
import flash.display.MovieClip;

import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

public class Trainer {

    private var trainerName:String;

    private var multiplier:uint;

    private var id:uint;

    private var photo:String;

    public function getName():String {
        return trainerName;
    }

    public function setName(value:String):void {
        trainerName = value;
    }

    public function getMulti():uint {
        return multiplier;
    }

    public function setMulti(value:uint):void {
        multiplier = value;
    }

    public function Trainer(id:uint) {

        if(id){
            var trainer:ItemResource = ItemTypeStore.getItemResourceById(id);
            this.trainerName = trainer.getName();
            this.id = trainer.getId();
            this.photo = trainer.getDisplayClass();
            this.multiplier = trainer.getParams().studyRate;
        }else{
           
            this.trainerName = "--";
            this.id = 0;
            this.photo = "";
            this.multiplier = 1;
        }

    }

    public function getId():uint {
        return id;
    }

    public function setId(value:uint):void {
        id = value;
    }
}
}