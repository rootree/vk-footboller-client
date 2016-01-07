package ru.kubline.settings {
import ru.kubline.model.LevelEntity;

/**
 * сетка уровней
 * @autor denis
 */
public class LevelsGrid {

    /**
     *  кол-во опыта необходимое для следующего уровня
     */
    private var levelsGrid:Array = [];

    public static const instance:LevelsGrid = new LevelsGrid();

    public function LevelsGrid() {
        levelsGrid.push( new LevelEntity(/*level*/0, /*nextExperiance*/ 0, /*baseEnergy*/100, /*studyPoints*/17) );
        levelsGrid.push(  new LevelEntity(1, 20, 100, 5) );
        levelsGrid.push( new LevelEntity(2, 100, 115, 6) );
        levelsGrid.push( new LevelEntity(3, 300, 130, 7) );
        levelsGrid.push( new LevelEntity(4, 700, 140, 9) );
        levelsGrid.push( new LevelEntity(5, 1500, 150, 12) );
        levelsGrid.push( new LevelEntity(6, 4000, 160, 15) );
        levelsGrid.push( new LevelEntity(7, 8000, 180, 17) );
        levelsGrid.push( new LevelEntity(8, 12000, 200, 20) );
        levelsGrid.push( new LevelEntity(9, 18000, 225, 37));
        levelsGrid.push( new LevelEntity(10, 25000, 235, 40));
        levelsGrid.push( new LevelEntity(11, 33000, 250, 50));
        levelsGrid.push( new LevelEntity(12, 40000, 270, 70));
        levelsGrid.push( new LevelEntity(13, 48000, 290, 85));
        levelsGrid.push( new LevelEntity(14, 55000, 330, 99));
        levelsGrid.push( new LevelEntity(15, 60000, 370, 110));
        levelsGrid.push( new LevelEntity(16, 65000, 400, 130));
        levelsGrid.push( new LevelEntity(17, 70000, 450, 150));
        levelsGrid.push( new LevelEntity(18, 77000, 500, 170));

        levelsGrid.push( new LevelEntity(19, 85000, 600, 190));
        levelsGrid.push( new LevelEntity(20, 100000, 800, 220));
        levelsGrid.push( new LevelEntity(21, 120000, 1000, 250));
        levelsGrid.push( new LevelEntity(22, 150000, 1200, 300));
        levelsGrid.push( new LevelEntity(23, 170000, 1300, 350));
        levelsGrid.push( new LevelEntity(24, 190000, 1500, 500));
        levelsGrid.push( new LevelEntity(25, 220000, 1800, 800));
        levelsGrid.push( new LevelEntity(26, 260000, 2000, 1200));
        levelsGrid.push( new LevelEntity(27, 300000, 2340, 1500));
        levelsGrid.push( new LevelEntity(28, 350000, 2600, 2000));
        levelsGrid.push( new LevelEntity(29, 390000, 3000, 2500));
        levelsGrid.push( new LevelEntity(30, 430000, 3300, 3000));
        levelsGrid.push( new LevelEntity(31, 490000, 4000, 4000));
        levelsGrid.push( new LevelEntity(32, 600000, 4500, 5000));
        levelsGrid.push( new LevelEntity(33, 660000, 5000, 6000));
        levelsGrid.push( new LevelEntity(34, 750000, 5600, 7000));
        levelsGrid.push( new LevelEntity(35, 850000, 6000, 10000));
        levelsGrid.push( new LevelEntity(36, 1000000, 6700, 12000));
        levelsGrid.push( new LevelEntity(37, 110000, 7500, 15000));
        levelsGrid.push( new LevelEntity(38, 130000, 8000, 20000));
        levelsGrid.push( new LevelEntity(39, 150000, 8600, 22000));
        levelsGrid.push( new LevelEntity(40, 180000, 9300, 23000));
        levelsGrid.push( new LevelEntity(41, 210000, 9900, 24000));
        levelsGrid.push( new LevelEntity(42, 250000, 12000, 25000));
        levelsGrid.push( new LevelEntity(43, 300000, 13000, 26000));
        levelsGrid.push( new LevelEntity(44, 500000, 15000, 27000));
        levelsGrid.push( new LevelEntity(45, 700000, 17000, 28000));
        levelsGrid.push( new LevelEntity(46, 900000, 19000, 29000));
        levelsGrid.push( new LevelEntity(47, 1200000, 23000, 30000));
        levelsGrid.push( new LevelEntity(48, 1500000, 25000, 32000));
        levelsGrid.push( new LevelEntity(49, 1800000, 27000, 35000));
        levelsGrid.push( new LevelEntity(50, 2000000, 30000, 40000));
    }
 
    
    public static function getNextLevelXp(curLevel:uint):uint {
        var level:LevelEntity = LevelEntity(instance.levelsGrid[curLevel]);
        return level.getNextLevelExp();
    }

    public static function levelExist(level:uint):Boolean {
        return instance.levelsGrid[level] != null;
    }

    public static function levelMaxEnergy(curLevel:uint):uint {
        var level:LevelEntity = LevelEntity(instance.levelsGrid[curLevel]);
        return level.getEnergy();
    }

    public static function levelStadyPoint(curLevel:uint):uint {
        var level:LevelEntity = LevelEntity(instance.levelsGrid[curLevel]);
        return level.getStadyPoint();
    }
}

}