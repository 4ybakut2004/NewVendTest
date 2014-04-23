var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

$(document).on('ready page:load', function() {
  angular.bootstrap(document.getElementById('newVending'), ['newVending']);
});

function FixedHeader($compile) 
{       
    return {
	    link: function($scope, element, attrs) {
			var fixedHeader;
			var table = element.find('table').first();
			var h;

			var setWidth = function() {
				element.css({
					height: $( window ).height() - element.offset().top
				});
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
				fh.addClass('standart-table-header table table-hover table-condensed');
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

newVending.directive('fixedheader', ['$compile', FixedHeader]);