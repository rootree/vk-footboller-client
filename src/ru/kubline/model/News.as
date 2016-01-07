package ru.kubline.model {
public class News {

    public var newsId:uint ;
    public var title:String  ;
    public var content:String ;
    public var image:String ;
    public var subTitle:String ;

    public function News(newsId:uint, title:String, content:String, image:String, subTitle:String) {
        this.newsId = newsId;
        this.title = title;
        this.content = content;
        this.image = image;
        this.subTitle = subTitle;
    }
}
}