var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

$(document).on('ready page:load', function() {
  angular.bootstrap(document.getElementById('newVending'), ['newVending']);
});

function DoubleScroll($compile, $window) 
{       
    return {
        link: function($scope, element, attrs) {
        	$scope.scrollBarWidth = function() {
        		return {
					width: element.width()
				};
        	};

        	$scope.scrollContentWidth = function() {
        		return {
					width: element.find('table').first().width()
				};
        	};

			var scrollBar = $compile('<div ng-style="scrollBarWidth()"></div>')($scope);
			var scrollContent = $compile('<div ng-style="scrollContentWidth()"></div>')($scope);

			scrollBar.addClass('scroll');

			function setSize() {
				scrollBar.css({
					width: element.width()
				});

				scrollContent.css({
					width: element.find('table').first().width()
				});
			}
			
			angular.element($window).bind('resize', setSize);
			element.scroll(function() {
		        scrollBar.scrollLeft(element.scrollLeft());
		    });
		    scrollBar.scroll(function() {
		        element.scrollLeft(scrollBar.scrollLeft());
		    });

			scrollBar.append(scrollContent);
			scrollBar.insertBefore(element);
        }
    };
}

newVending.directive('doublescroll', DoubleScroll);

function FixedHeader($compile, $window) 
{       
    return {
	    link: function($scope, element, attrs) {
			var fixedHeader;
			var table = element.find('table').first();
			var h;

			var setWidth = function() {
				if(fixedHeader) {
					fixedHeader.css({
						width: table.width()
					});
					h.find('tr').first().find('th').each(function(index) {
						$(this).css({
							width: $(table.find('tr').first().find('th')[index]).innerWidth()
						});
					});
				}
			};

			$scope.setWidth = setWidth;

			var cloneHeader = function() {
				if(fixedHeader) {
					fixedHeader.remove();
					fixedHeader = undefined;
				}

				h = element.find('thead').first().clone();

				fh = $('<table></table>');
				fh.addClass('standart-table-header table table-striped table-hover table-condensed');
				fh.append(h);
				fixedHeader = $compile(fh)($scope);

				setWidth();

				element.prepend(fixedHeader);
			};

			element.bind('scroll', function() {
				if(!fixedHeader) {
					cloneHeader();
				}
				fixedHeader.css({
					top: -table.position().top
				});
				setWidth();
			});

			$(window).resize(function() {
				setWidth();
			});
        }
    };
}

newVending.directive('fixedheader', FixedHeader);