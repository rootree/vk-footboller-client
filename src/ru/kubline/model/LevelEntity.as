package ru.kubline.model {

/**
 * Описание параметров для конкретного уровня
 * @autor denis
 */
public class LevelEntity {

    /**
     * номер уровня
     */
    private var level:uint;

    /**
     * необходимо опыта для перехода на следующий уровень
     */
    private var nextLevelExp:uint;

    private var energy:uint;
    
    private var stadyPoint:uint;

    /**
     * @param level номер уровня
     * @param nextLevelExp количество опыта необходимое для перехода на следующий уровень
     */
    public function LevelEntity(level:uint, nextLevelExp:uint, energy:uint, stadyPoint:uint) {
        this.level = level;
        this.nextLevelExp = nextLevelExp;
        this.energy = energy;
        this.stadyPoint = stadyPoint;
    }

    public function getLevel():uint {
        return level;
    }

    public function getEnergy():uint {
        return energy;
    }

    public function getNextLevelExp():uint {
        return nextLevelExp;
    }

    public function getStadyPoint():uint {
        return stadyPoint;
    }
}
}