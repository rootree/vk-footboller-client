package ru.kubline.model {
public class StudyPayment {

    public var paymentId:uint ;
    public var studyCount:uint  ;
    public var price:Price ;
    public var normalColor:uint ;
    public var hoverColor:uint ;

    public function StudyPayment(paymentId:uint, studyCount:uint, price:Price, normalColor:uint, hoverColor:uint) {
        this.paymentId = paymentId;
        this.studyCount = studyCount;
        this.price = price;
        this.normalColor = normalColor;
        this.hoverColor = hoverColor;
    }

    public function getPrice():Price {
        return price;
    }

    public function getRequiredLevel ():uint {
        return 0;
    }
}
}