function Pager(attributes) {
    this.currentPage = 1;
    this.perPage = attributes.perPage;
    this.pageCount = 0;
    this.pages = [1, 2];
    this.pageLimit = 7;

    this.controllerScope = attributes.controllerScope;
    this.filterMethod = attributes.filterMethod;
    this.service = attributes.service;
    this.containerName = attributes.containerName;
}

Pager.prototype.setPage = function(page) {
    this.currentPage = page;
    var pager = this;

    var scope = this.controllerScope;
    var attr = this.filterMethod();
    this.calcPageCount(attr);
    var newRecords = this.service.all(attr);
    newRecords.$promise.then(function() {
        scope[pager.containerName] = newRecords;
    });
};

Pager.prototype.nextPage = function() {
    if(this.currentPage < this.pageCount) {
        this.setPage(this.currentPage + 1);
    }
};

Pager.prototype.prevPage = function() {
    if(this.currentPage > 1) {
        this.setPage(this.currentPage - 1);
    }
};

Pager.prototype.calcPageCount = function(attr) {
    var pager = this;
    this.service.count(attr).then(function(count) {
        pager.pageCount = count % pager.perPage === 0 ? Math.floor(count / pager.perPage) : Math.floor(count / pager.perPage) + 1;
        pager.pages = [];

        if(pager.pageCount < pager.pageLimit) {
            for(var i = 0; i < pager.pageCount; i++) {
                pager.pages.push({
                    label: (i + 1).toString(),
                    number: i + 1
                });
            }
        }
        else {
            var pushed = 0;
            var needs = pager.pageLimit - 2;

            pager.pages.push({
                label: (1).toString(),
                number: 1
            });

            var pagesOnSide = Math.floor((pager.pageLimit - 3) / 2);
            var startPage = pager.currentPage - pagesOnSide;
            var page = startPage;
            while(page < pager.pageCount && pushed != needs) {
                if(page > 1) {
                    pager.pages.push({
                        label: (page).toString(),
                        number: page
                    });
                    pushed++;
                }
                page++;
            }

            page = startPage - 1;
            while(page > 1 && pushed != needs) {
                pager.pages.splice(1, 0, {
                    label: (page).toString(),
                    number: page
                });
                pushed++;
                page--;
            }

            pager.pages.push({
                label: (pager.pageCount).toString(),
                number: pager.pageCount
            });

            if(pager.pages[1].number - pager.pages[0].number != 1) {
                pager.pages.splice(1, 0, {
                    label: '...',
                    number: pager.pages[1].number - 1
                });
            }

            var length = pager.pages.length;
            if(pager.pages[length - 1].number - pager.pages[length - 2].number != 1) {
                pager.pages.splice(length - 1, 0, {
                    label: '...',
                    number: pager.pages[length - 2].number + 1
                });
            }
        }
    });
};