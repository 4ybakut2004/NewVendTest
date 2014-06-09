// Описание ошибок, возвращаемых сервером
var ResponseErrors = {
	"has already been taken": "Запись с таким значением уже существует",
	"can't be blank": "Поле должно быть заполнено"
};

function showErrors (data, container) {
	angular.forEach(data, function(fieldErrors, fieldName) {
		// Преобразовываем массив английских ошибок в массив русских
		var rusErrors = [];
		angular.forEach(fieldErrors, function(errorName) {
			rusErrors.push(ResponseErrors[errorName]);
		});

		// Показываем сообщение об ошибке
		container[fieldName] = errorMessage = rusErrors.join(', ');
	});
}

var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

$(document).on('ready page:load', function() {
  angular.bootstrap(document.getElementById('newVending'), ['newVending']);
});

function Application($compile, User) 
{       
    return {
	    link: function($scope, element, attrs) {
	    	var menuPosition = attrs["menuPosition"];
	    	var userId = parseInt(attrs["userId"]) || 0;
	    	var hidden;

	    	if(menuPosition == "shown") {
	    		hidden = false;
	    	}
	    	else {
	    		hidden = true;
	    	}

	    	var signed = attrs.signed;

	    	var closeButton;
	    	var closeButtonWidth; // Уменьшим меню на эту ширину, чтобы засунуть кнопку закрытия
	    	var menuWidth;        // На данный отступ сейчас смещена рабочая область. Запомнить для открытия меню
	    	var showButton;
	    	var hideButton;

	    	// DOM элементы
			var workspace = element.find('.workspace').first();
			var menuContainer = element.find('.menu').first();
			var menu = menuContainer.find('.menu-nav').first();
			menuWidth = menu.width();

			if(signed != "true") {
				menuContainer.css({
					width: '0px'
				});
				workspace.css({
					'margin-left': '0px'
				});
				return;
			}

			var triangleLeft = $('<div class="close-button-triangle-left"></div>');
			var triangleRight = $('<div class="close-button-triangle-right"></div>');

			// Кнопка скрытия меню
			closeButton = $('<div class="close-button"></div>');

			if(hidden) {
				closeButton.append(triangleRight);
			}
			else {
				closeButton.append(triangleLeft);
			}

			closeButton.click(function(event) {
				event.preventDefault();

				if(hidden) {
					menuContainer.animate({
						'margin-left': '0px'
					});

					workspace.animate({
						'margin-left': menuWidth + 'px'
					}, function() {
						if($scope.setWidth) {
							$scope.setWidth();
						}

						closeButton.empty();
						closeButton.append(triangleLeft);
					});
				}
				else {
					menuContainer.animate({
						'margin-left': (closeButtonWidth - menuWidth) + 'px'
					});

					workspace.animate({
						'margin-left': closeButtonWidth + 'px'
					}, function() {
						if($scope.setWidth) {
							$scope.setWidth();
						}

						closeButton.empty();
						closeButton.append(triangleRight);
					});
				}

				hidden = !hidden;
			});

			closeButton.insertAfter(menu);
			closeButtonWidth = closeButton.width();
			menu.css({width: (menuWidth - closeButtonWidth) + 'px'});

			// Кнопка смены типа меню
			showButton = $('<button class="btn btn-link"><small>Показывать меню</small></button>');
			hideButton = $('<button class="btn btn-link"><small>Прятать меню</small></button>');

			showButton.click(function(event) {
				event.preventDefault();

				var attr = {
					'menu_position': 'shown'
				};

				User.update(userId, attr);

				changeTypeButtonLi.empty();
				changeTypeButtonLi.append(hideButton);
			});

			hideButton.click(function(event) {
				event.preventDefault();

				var attr = {
					'menu_position': 'hidden'
				};

				User.update(userId, attr);

				changeTypeButtonLi.empty();
				changeTypeButtonLi.append(showButton);
			});

			var changeTypeButtonLi = $('<li></li>');

			if(menuPosition == "hidden") {
				changeTypeButtonLi.append(showButton);
			}
			else {
				changeTypeButtonLi.append(hideButton);
			}

			changeTypeButtonLi.appendTo(menu);

			// Настройка размеров меню
			function setMenuHeight() {
				menuContainer.css({
					height: $(window).height() - 70
				});
			}

			$(window).bind('resize', function() {
				setMenuHeight();
			});

			setMenuHeight();

			if(hidden) {
				menuContainer.css({
					'margin-left': (closeButtonWidth - menuWidth) + 'px'
				});

				workspace.css({
						'margin-left': closeButtonWidth + 'px'
				});
			}
			else {
				menuContainer.css({
					'margin-left': '0px'
				});

				workspace.css({
						'margin-left': menuWidth + 'px'
				});
			}
        }
    };
}

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

				scrollX.offset({
					top: $(window).height() + $(document).scrollTop() - scrollX.height()
				});

				scrollInner.css({
					width: table.width()
				});
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
				scrollX.insertAfter(element);
			};

			cloneHeader();

			$(window).bind('scroll', function() {
				setWidth();
			});

			$(window).bind('resize', function() {
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
		      onChangeDateTime:function(dp,$input) {
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

newVending.directive('application', ['$compile', 'User', Application]);
newVending.directive('fixedheader', ['$compile', FixedHeader]);
newVending.directive('datetimepicker', ['$compile', DateTimePicker]);
newVending.directive('datetimepickerfromnow', ['$compile', DateTimePickerFromNow]);