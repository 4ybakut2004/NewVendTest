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