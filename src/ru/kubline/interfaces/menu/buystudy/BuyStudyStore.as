package ru.kubline.interfaces.menu.buystudy {
import ru.kubline.model.News;
import ru.kubline.model.Price;
import ru.kubline.model.StudyPayment;

public class BuyStudyStore {

    private static var initialData:Array = new Array(
            new StudyPayment(101, 5, new Price(detectStudyPrice(5), detectStudyPriceReal(5)), 0xFF6600, 0xFFCC00),
            new StudyPayment(102, 15, new Price(detectStudyPrice(15), detectStudyPriceReal(15)), 0x009932, 0x33CC33),
            new StudyPayment(103, 50, new Price(detectStudyPrice(50), detectStudyPriceReal(50)), 0x00CBFF, 0x99FFFF),
            new StudyPayment(104, 99, new Price(detectStudyPrice(99), detectStudyPriceReal(99)), 0xCC32FF, 0xFF99FF)
        );

    public function BuyStudyStore() { 
    }

    public static function getStore():Array{
        return initialData;
    }

    private static function detectStudyPrice(valueCount:uint):uint{
        return Math.floor (valueCount * Application.teamProfiler.getStudyPointCount() * 2.3 );    }

    private static function detectStudyPriceReal(valueCount:uint):uint{
        return Math.floor ( detectStudyPrice(valueCount) / 500 );
    }


}
}