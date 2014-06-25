function Pager(_perPage) {
    this.currentPage = 1;
    this.perPage = _perPage;
    this.pageCount = 0;
    this.pages = [];
    this.pageLimit = 7;
}

Pager.prototype.calcPageCount = function(count) {
    this.pageCount = count % this.perPage === 0 ? Math.floor(count / this.perPage) : Math.floor(count / this.perPage) + 1;
    this.pages = [];

    if(this.pageCount < this.pageLimit) {
        for(var i = 0; i < this.pageCount; i++) {
            this.pages.push({
                label: (i + 1).toString(),
                number: i + 1
            });
        }
    }
    else {
        var pushed = 0;
        var needs = this.pageLimit - 2;

        this.pages.push({
            label: (1).toString(),
            number: 1
        });

        var pagesOnSide = Math.floor((this.pageLimit - 3) / 2);
        var startPage = this.currentPage - pagesOnSide;
        var page = startPage;
        while(page < this.pageCount && pushed != needs) {
            if(page > 1) {
                this.pages.push({
                    label: (page).toString(),
                    number: page
                });
                pushed++;
            }
            page++;
        }

        page = startPage - 1;
        while(page > 1 && pushed != needs) {
            this.pages.splice(1, 0, {
                label: (page).toString(),
                number: page
            });
            pushed++;
            page--;
        }

        this.pages.push({
            label: (this.pageCount).toString(),
            number: this.pageCount
        });

        if(this.pages[1].number - this.pages[0].number != 1) {
            this.pages.splice(1, 0, {
                label: '...',
                number: this.pages[1].number - 1
            });
        }

        var length = this.pages.length;
        if(this.pages[length - 1].number - this.pages[length - 2].number != 1) {
            this.pages.splice(length - 1, 0, {
                label: '...',
                number: this.pages[length - 2].number + 1
            });
        }
    }
};