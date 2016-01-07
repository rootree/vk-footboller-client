package ru.kubline.gui.controls {

/**
 * хранилище данных для постраничного вывода
 */
public class PagingStore {

    /**
     * массив данных
     */
    protected var data:Array;

    /**
     * текущая страница
     */
    private var page:int;

    /**
     * общее кол-во страниц
     */
    private var pageCount:int;

    /**
     * кол-во элементов на странице
     */
    private var pageSize:int;

    public function PagingStore(data:Array, pageSize:int, totalCount:int = 0) {
        this.data = data;
        this.pageSize = pageSize;
        this.pageCount = totalCount ? calculatePageCount(totalCount) : calculatePageCount(data.length);
    }

   private function calculatePageCount(totalCount:uint):int {
        if (!totalCount) {
            return 1;
        } else {
            return Math.ceil( totalCount / pageSize );
        }
    }

    /**
     * возвращает 1й индекс эл-та на странице
     */
    protected function getFirstIndex():int {
        return (page - 1) * pageSize;
    }

    /**
     * callback with argument Array
     * @param callback
     */
    public function loadCurPageData(callback:Function):void {
        var fi:int = getFirstIndex();
        callback(this.data.slice(fi, fi + pageSize));
    }

    /**
     * общее кол-во элементов
     * @return
     */
    public function getTotalCount():int {
        return data.length;
    }

    /**
     * текущая страница
     * @return
     */
    public function getPage():int {
        return page;
    }

    public function setPage(page:int):void {
        this.page = page;
    }

    /**
     * текущая страница 1я
     * @return
     */
    public function isFirstPage():Boolean {
        return this.page == 1;
    }

    /**
     * кол-во элементов на странице
     * @return
     */
    public function getPageSize():int {
        return this.pageSize;
    }

    /**
     * текущая страница последняя
     * @return
     */
    public function isLastPage(): Boolean {
        return this.page == this.pageCount;
    }

    /**
     * кол-во страниц
     * @return
     */
    public function getPageCount():int {
        return pageCount;
    }
}
}