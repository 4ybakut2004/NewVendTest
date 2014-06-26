/***********************************************************
 ** request_tasks_ctrl.js **********************************
 ***********************************************************
 * Контроллер страницы Поручения.
 **********************************************************/

function RequestTasksCtrl($scope, $timeout, RequestTask, Employee) {
	/*
	 * init()
	 * Конструктор
	 */
	function init() {
		$scope.requestId = getURLParameter('request_id');
		$scope.requestTasks = RequestTask.all({
			request_id: $scope.requestId,
			page: $scope.currentPage
		});

		RequestTask.count({
			request_id: $scope.requestId
		}).then(function(d) {
			$scope.pager = new Pager(10);
			$scope.pager.calcPageCount(d);
		});

		$scope.employees = Employee.all();
		Employee.current_employee().then(function(d) {
			$scope.currentEmployee = d;
		});

		// Получаем количества индикаторных поручений и поручений, которые нужно прочитать
		$scope.setIndicatorsCounts();
		$scope.setReadIndicatorsCounts();
		$scope.setReadByIndicatorsCounts();

		// Переменая, отвечающая за показ окна редактирования
		$scope.editing = false;
		// Фильтр отмеченных строк
		$scope.search = { checked: false };

		// Нужны для редактируемых полей. Отвечают за стили
		$scope.editingInputs = {
			executorId: false,
			auditorId: false,
			description: false,
			deadlineDate: false,
			executionDate: false,
			auditionDate: false,
			registrarDescription: false,
			assignerDescription: false,
			executorDescription: false,
			auditorDescription: false
		};

		$scope.editingErrors = {
			description: "",
			registrar_description: "",
			assigner_description: "",
			executor_description: "",
			auditor_description: ""
		};

		// Фильтры по принадлежности поручений
		$scope.whoAmI = {
			assigner: false,
			executor: false,
			auditor: false
		};

		// Фильтры сигнальных индикаторов
		$scope.indicators = {
			assign: false,
			execute: false,
			audit: false
		};

		// Фильтры просроченности
		$scope.overdued = {
			done: false,
			not_done: false
		};

		// Фильтры прочитанности
		$scope.to_read = {
			assigner: false,
			executor: false
		};

		// Настраиваем доступ к функциям с html страницы
		$scope.formattedDate = formattedDate;
		$scope.dateForInput = dateForInput;
	}

	/*
	 * $scope.setIndicatorsCounts()
	 * Получение количеств поручений, с которыми необходимо совершить действия
	 */
	$scope.setIndicatorsCounts = function() {
		RequestTask.to_assign_count().then(function(d) {
			$scope.toAssignCount = d;
		});

		RequestTask.to_execute_count().then(function(d) {
			$scope.toExecuteCount = d;
		});

		RequestTask.to_audit_count().then(function(d) {
			$scope.toAuditCount = d;
		});
	};

	/*
	 * $scope.setReadIndicatorsCounts()
	 * Получение количеств поручений, которые необходимо прочитать назначенным человеком
	 */
	$scope.setReadIndicatorsCounts = function() {
		RequestTask.to_read_assign_count().then(function(d) {
			$scope.toReadAssignCount = d;
		});

		RequestTask.to_read_execute_count().then(function(d) {
			$scope.toReadExecuteCount = d;
		});
	};

	/*
	 * $scope.setReadByIndicatorsCounts()
	 * Получение количеств поручений, которые необходимо прочитать у себя
	 */
	$scope.setReadByIndicatorsCounts = function() {
		RequestTask.to_read_by_assigner_count().then(function(d) {
			$scope.toReadByAssignerCount = d;
		});

		RequestTask.to_read_by_executor_count().then(function(d) {
			$scope.toReadByExecutorCount = d;
		});

		RequestTask.to_read_by_auditor_count().then(function(d) {
			$scope.toReadByAuditorCount = d;
		});

		RequestTask.to_read_by_employee_count().then(function(d) {
			$scope.toReadByCount = d;
		});
	};

	init();

//- Мониторинг изменения моделей ---------------------------
	$scope.changeWidth = function() {
		$timeout(function(){$scope.setWidth();}, 300);
	};

	$scope.changeScroll = function() {
		$timeout(function(){$scope.restoreScroll();}, 100);
	};

	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$scope.changeWidth();
		}
	});

	// Умный поиск по плановому сроку
	$scope.$watch('deadlineDateFilter', function() {
		var date;
		if($scope.deadlineDateFilter) {
			date = $scope.deadlineDateFilter.match(/([<>=])\s*(0[1-9]|[12][0-9]|3[01])[- //.](0[1-9]|1[012])[- //.](19|20\d\d)/);
			if(date) {
				var filterDate = new Date(date[4], date[3] - 1, date[2]);
				angular.forEach($scope.requestTasks, function(requestTask) {
					var deadlineDate = new Date(requestTask.deadline_date);
					switch(date[1]) {
						case '<':
							if(deadlineDate < filterDate) {
								requestTask.checked = false;
							}
							else {
								requestTask.checked = true;
							}
							break;

						case '>':
							if(deadlineDate > filterDate) {
								requestTask.checked = false;
							}
							else {
								requestTask.checked = true;
							}
							break;

						case '=':
							if(deadlineDate.getFullYear() == filterDate.getFullYear() &&
							deadlineDate.getMonth() == filterDate.getMonth() &&
							deadlineDate.getDate() == filterDate.getDate()) {
								requestTask.checked = false;
							}
							else {
								requestTask.checked = true;
							}
							break;
					}
				});
			}
			else {
				angular.forEach($scope.requestTasks, function(requestTask) {
					requestTask.checked = false;
				});	
			}
		}
	});

	$scope.$watch('editingExecutorId', function() {
		$scope.editingInputs.executorId = ($scope.editingExecutorId != "" && $scope.editingExecutorId != null);
	});

	$scope.$watch('editingAuditorId', function() {
		$scope.editingInputs.auditorId = ($scope.editingAuditorId != "" && $scope.editingAuditorId != null);
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
		$scope.editingErrors.description = "";
	});

	$scope.$watch('editingDeadlineDate', function() {
		$scope.editingInputs.deadlineDate = ($scope.editingDeadlineDate != "" && $scope.editingDeadlineDate != null && $scope.editingDeadlineDate != DATE_MASK);
	});

	$scope.$watch('editingExecutionDate', function() {
		$scope.editingInputs.executionDate = ($scope.editingExecutionDate != "" && $scope.editingExecutionDate != null && $scope.editingExecutionDate != DATE_MASK);
	});

	$scope.$watch('editingAuditionDate', function() {
		$scope.editingInputs.auditionDate = ($scope.editingAuditionDate != "" && $scope.editingAuditionDate != null && $scope.editingAuditionDate != DATE_MASK);
	});

	$scope.$watch('editingRegistrarDescription', function() {
		$scope.editingInputs.registrarDescription = ($scope.editingRegistrarDescription != "" && $scope.editingRegistrarDescription != null);
		$scope.editingErrors.registrar_description = "";
	});

	$scope.$watch('editingAssignerDescription', function() {
		$scope.editingInputs.assignerDescription = ($scope.editingAssignerDescription != "" && $scope.editingAssignerDescription != null);
		$scope.editingErrors.assigner_description = "";
	});

	$scope.$watch('editingExecutorDescription', function() {
		$scope.editingInputs.executorDescription = ($scope.editingExecutorDescription != "" && $scope.editingExecutorDescription != null);
		$scope.editingErrors.executor_description = "";
	});

	$scope.$watch('editingAuditorDescription', function() {
		$scope.editingInputs.auditorDescription = ($scope.editingAuditorDescription != "" && $scope.editingAuditorDescription != null);
		$scope.editingErrors.auditor_description = "";
	});

//- Изменение моделей --------------------------------------
	$scope.updateRequestTask = function() {
		var attr = {};
		attr.executor_id = $scope.editingExecutorId;
		attr.auditor_id = $scope.editingAuditorId;
		attr.description = $scope.editingDescription;
		attr.registrar_description = $scope.editingRegistrarDescription;
		attr.assigner_description = $scope.editingAssignerDescription;
		attr.executor_description = $scope.editingExecutorDescription;
		attr.auditor_description = $scope.editingAuditorDescription;
		attr.deadline_date = strDateToUTC($scope.editingDeadlineDate);
		attr.execution_date = strDateToUTC($scope.editingExecutionDate);
		attr.audition_date = strDateToUTC($scope.editingAuditionDate);

		// Обновляем поручение
		var updatedRequestTask = RequestTask.update($scope.editingId, attr);

		// Производим действия, которые нужно выполнить после обновления
		updatedRequestTask.$promise.then(function() {
			$scope.requestTasks[$scope.editingIdx] = updatedRequestTask;

			$scope.closeEditing();

			$scope.setIndicatorsCounts();
			$scope.setReadIndicatorsCounts();
			$scope.setReadByIndicatorsCounts();
		}, function(d) {
			showErrors(d.data, $scope.editingErrors);
		});
	};

	$scope.clickRequestTask = function(idx) {
		var r = RequestTask.get($scope.requestTasks[idx].id);
		// После получения информации о поручении
		r.$promise.then(function() {
			// Сохраняем информацию в редактируемые поля
			$scope.editingRequestTask = r;
			$scope.editingRequest = r.request;
			$scope.editingAttributes = r.attributes;
			$scope.editingId = r.id;
			$scope.editingIdx = idx;

			$scope.editingExecutorId = r.executor_id;
			$scope.editingAuditorId = r.auditor_id;
			$scope.editingDescription = r.description;
			$scope.editingRegistrarDescription = r.registrar_description;
			$scope.editingAssignerDescription = r.assigner_description;
			$scope.editingExecutorDescription = r.executor_description;
			$scope.editingAuditorDescription = r.auditor_description;
			$scope.editingDeadlineDate = $scope.dateForInput(r.deadline_date);
			$scope.editingExecutionDate = $scope.dateForInput(r.execution_date);
			$scope.editingAuditionDate = $scope.dateForInput(r.audition_date);

			// Запоминаем позицию страницы
			$scope.rememberScroll();

			// Показываем окно редактирования
			$scope.editing = true;
		});

		// Если у пользователя настроен сотрудник,
		// посылаем на сервер сигнал, что поручение прочитано
		if($scope.currentEmployee) {
			RequestTask.read($scope.requestTasks[idx].id,
							$scope.currentEmployee.id).then(function(d) {
				// Потом обновляем данные этого поручения
				$scope.requestTasks[idx].is_read_by_assigner = d.is_read_by_assigner;
				$scope.requestTasks[idx].is_read_by_executor = d.is_read_by_executor;
				$scope.requestTasks[idx].is_read_by_auditor = d.is_read_by_auditor;
				// И после этого обновляем число непрочитанных поручений
				$scope.setReadIndicatorsCounts();
				$scope.setReadByIndicatorsCounts();
			});
		}
	};

	// Закрываем окно реадктирования
	$scope.closeEditing = function() {
		$scope.editing = false;
		$scope.changeScroll();

		$scope.editingExecutorId = "";
		$scope.editingAuditorId = "";
		$scope.editingDescription = "";
		$scope.editingDeadlineDate = "";
		$scope.editingExecutionDate = "";
		$scope.editingAuditionDate = "";
		$scope.editingRegistrarDescription = "";
		$scope.editingAssignerDescription = "";
		$scope.editingExecutorDescription = "";
		$scope.editingAuditorDescription = "";
		$scope.editingIdx = null;

		$scope.editingErrors.description = "";
		$scope.editingErrors.assigner_description = "";
		$scope.editingErrors.executor_description = "";
		$scope.editingErrors.auditor_description = "";
		$scope.editingErrors.registrar_description = "";
	};

	$scope.canEditDeadlineDate = function(employee_id) {
		return ($scope.editingIdx != null) ? 
			(employee_id == $scope.requestTasks[$scope.editingIdx].auditor_id) :
			false;
	};

	// Обновляет массив поручений в зависимости от настроенных фильтров
	function requestTasksFilter() {
		
		$scope.requestTasks = $scope.getFilteredTasks();
		// После фильтра подгоняем ширину шапки таблицы
		$scope.changeWidth();

		$scope.setReadIndicatorsCounts();
		$scope.setReadByIndicatorsCounts();
	}

	$scope.getFilteredTasks = function() {
		// Массив атрибутов фильтра
		var attr = {
			'who_am_i[]': [],
			'overdued[]': [],
			'indicators[]': [],
			'to_read[]' : [],
			'page': $scope.pager.currentPage,
			'request_id': $scope.requestId
		};

		// Запоминаем отмеченные пункты просроченности
		for(var key in $scope.overdued) {
			if($scope.overdued[key]) {
				attr['overdued[]'].push(key);
			}
		}

		// Запоминаем отмеченные пункты принадлежности
		for(var key in $scope.whoAmI) {
			if($scope.whoAmI[key]) {
				attr['who_am_i[]'].push(key);
			}
		}

		// Запоминаем отмеченные пункты индикаторов
		for(var key in $scope.indicators) {
			if($scope.indicators[key]) {
				attr['indicators[]'].push(key);
			}
		}

		// Запоминаем отмеченные пункты прочитанности
		for(var key in $scope.to_read) {
			if($scope.to_read[key]) {
				attr['to_read[]'].push(key);
			}
		}

		RequestTask.count(attr).then(function(d) {
			$scope.pager.calcPageCount(d);
		});

		return RequestTask.all(attr);
	};

	/*
	 * $scope.whoAmIFilter(str)
	 * Изменяет фильтр принадлежности
	 */
	$scope.whoAmIFilter = function(str) {
		$scope.whoAmI[str] = !$scope.whoAmI[str];

		if(!$scope.whoAmI[str]) {
			switch(str) {
				case 'assigner':
					$scope.indicators.assign = false;
					$scope.to_read.assigner = false;
					break;

				case 'executor':
					$scope.indicators.execute = false;
					$scope.to_read.executor = false;
					break;

				case 'auditor':
					$scope.indicators.audit = false;
					break;
			}
		}

		requestTasksFilter();
	};

	/*
	 * $scope.overduedFilter(str)
	 * Изменяет фильтр просроченности
	 */
	$scope.overduedFilter = function(str) {
		$scope.overdued[str] = !$scope.overdued[str];
		requestTasksFilter();
	};

	/*
	 * $scope.indicatorsFilter(str)
	 * Изменяет фильтр индикаторов
	 */
	$scope.indicatorsFilter = function(str) {
		$scope.indicators[str] = !$scope.indicators[str];

		if($scope.indicators[str]) {
			switch(str) {
				case 'assign':
					$scope.whoAmI.assigner = true;
					break;

				case 'execute':
					$scope.whoAmI.executor = true;
					break;

				case 'audit':
					$scope.whoAmI.auditor = true;
					break;
			}
		}

		requestTasksFilter();
	};

	/*
	 * $scope.toReadFilter(str)
	 * Изменяет фильтр прочитанности
	 */
	$scope.toReadFilter = function(str) {
		$scope.to_read[str] = !$scope.to_read[str];

		if($scope.to_read[str]) {
			switch(str) {
				case 'assigner':
					$scope.whoAmI.assigner = true;
					break;

				case 'executor':
					$scope.whoAmI.executor = true;
					break;
			}
		}

		requestTasksFilter();
	};

	/*
	 * $scope.needsToRead(requestTask)
	 * Определяет, нужно ли прочитать данное поручение
	 */
	$scope.needsToRead = function(requestTask) {
		if($scope.currentEmployee) {
			return (($scope.currentEmployee.id == requestTask.assigner_id && 
			!requestTask.is_read_by_assigner &&
			requestTask.email_to_assigner_date) ||

			($scope.currentEmployee.id == requestTask.executor_id &&  
			!requestTask.is_read_by_executor &&
			requestTask.email_to_executor_date) ||

			($scope.currentEmployee.id == requestTask.auditor_id &&
			!requestTask.is_read_by_auditor &&
			requestTask.email_to_auditor_date));
		}
		else {
			return false;
		}
	};

	$scope.setPage = function(page) {
		$scope.pager.currentPage = page;
		var newPageTasks = $scope.getFilteredTasks();
		newPageTasks.$promise.then(function() {
			$scope.requestTasks = newPageTasks;
		});
	};

	$scope.nextPage = function() {
		if($scope.pager.currentPage < $scope.pager.pageCount) {
			$scope.setPage($scope.pager.currentPage + 1);
		}
	};

	$scope.prevPage = function() {
		if($scope.pager.currentPage > 1) {
			$scope.setPage($scope.pager.currentPage - 1);
		}
	};
}

newVending.controller("RequestTasksCtrl",['$scope', '$timeout', 'RequestTask', 'Employee', RequestTasksCtrl]);