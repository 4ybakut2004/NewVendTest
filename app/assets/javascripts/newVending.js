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

			var scrollX = $('<div class="scrollX"></div>');
			var scrollInner = $('<div class="scrollInner"></div>');
			scrollX.append(scrollInner);

			var setWidth = function() {
				var headerVisibility = "visible";
				var headerPositionTop = $(document).scrollTop() + 50 - table.offset().top;
				if(0 > headerPositionTop) {
					headerVisibility = "hidden";
				}

				var scrollXVisibility = "visible";
				var defaultScrollXVisibility = "hidden";
				if($(document).scrollTop() + $(window).height() > element.offset().top + element.height()) {
					scrollXVisibility = "hidden";
					defaultScrollXVisibility = "auto";
				}

				if(fixedHeader) {
					fixedHeader.css({
						width: table.width(),
						top: headerPositionTop,
						visibility: headerVisibility
					});

					h.find('tr').first().find('th').each(function(index) {
						$(this).css({
							width: $(table.find('tr').first().find('th')[index]).innerWidth()
						});
					});

					scrollX.css({
						width: element.width(),
						visibility: scrollXVisibility
					});

					scrollInner.css({
						width: table.width()
					});
				}
			};

			$scope.scrollY = 0;
			$scope.setWidth = setWidth;

			$scope.rememberScroll = function() {
				$scope.scrollY = $(document).scrollTop();
				$(document).scrollTop(0);
			};

			$scope.restoreScroll = function() {
				$(document).scrollTop($scope.scrollY);
			};

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

				//scrollX.insertAfter(element);
				element.prepend(fh);
				element.prepend(scrollX);
			};

			cloneHeader();

			$(window).bind('scroll', function() {
				setWidth();
			});

			$(window).resize(function() {
				setWidth();
			});

			element.bind('scroll', function() {
				scrollX.scrollLeft(element.scrollLeft());
			});

			scrollX.bind('scroll', function() {
				element.scrollLeft(scrollX.scrollLeft());
			});
        }
    };
}

function DateTimePicker($compile) 
{       
    return {
	    link: function($scope, element, attrs) {
			element.datetimepicker({
		      lang: 'ru',
		      mask: true,
		      format: 'd.m.Y H:i:s',
		      dayOfWeekStart: 1,
		      allowBlank: true
		    });

		    var inputContainer = $('<div style="position: relative;"></div>');
		    var parent = element.parent();

		    var clearButton = $('<button type="button" class="close input-clear">&times;</button>');

		    clearButton.click(function() {
		    	element.val(DATE_MASK);
		    	$scope[attrs.ngModel] = DATE_MASK;
		    });

		   	inputContainer.append(element);
		   	inputContainer.append(clearButton);

		   	parent.append(inputContainer);
        }
    };
}

function DateTimePickerFromNow($compile) 
{       
    return {
	    link: function($scope, element, attrs) {
			element.datetimepicker({
		      lang: 'ru',
		      mask: true,
		      format: 'd.m.Y H:i:s',
		      dayOfWeekStart: 1,
		      allowBlank: true,
		      minDate: 0,
		      onChangeDateTime:function(dp,$input){
		        var now = new Date();
		        var val = new Date($input.val().replace(/(\d+).(\d+).(\d+)/, '$2/$1/$3'));
		        if(val < now) {
		          $input.val(formattedDate(now));
		        }
		      }
		    });

		    var inputContainer = $('<div style="position: relative;"></div>');
		    var parent = element.parent();

		    var clearButton = $('<button type="button" class="close input-clear">&times;</button>');

		    clearButton.click(function() {
		    	element.val(DATE_MASK);
		    	$scope[attrs.ngModel] = DATE_MASK;
		    });

		   	inputContainer.append(element);
		   	inputContainer.append(clearButton);

		   	parent.append(inputContainer);
        }
    };
}

newVending.directive('fixedheader', ['$compile', FixedHeader]);
newVending.directive('datetimepicker', ['$compile', DateTimePicker]);
newVending.directive('datetimepickerfromnow', ['$compile', DateTimePickerFromNow]);