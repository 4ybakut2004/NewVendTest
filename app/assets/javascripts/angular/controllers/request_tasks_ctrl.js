function RequestTasksCtrl($scope, $timeout, RequestTask, Employee) {
	function getURLParameter(name) {
		return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
	}

	$scope.requestTasks = RequestTask.all({ request_id: getURLParameter('request_id') });
	$scope.employees = Employee.all();
	$scope.editing = false;
	$scope.search = { checked: false };

	$scope.editingInputs = {
		executorId: false,
		auditorId: false,
		description: false,
		deadlineDate: false,
		executionDate: false,
		auditionDate: false
	};

	$scope.whoAmI = {
		assigner: false,
		executor: false,
		auditor: false
	};

	$scope.indicators = {
		assign: false,
		execute: false,
		audit: false
	};

	$scope.overdued = {
		done: false,
		not_done: false
	};

	$scope.$watch('editingExecutorId', function() {
		$scope.editingInputs.executorId = ($scope.editingExecutorId != "" && $scope.editingExecutorId != null);
	});

	$scope.$watch('search', function(){
		$scope.setWidth();
	});

	$scope.$watch('deadlineDateFilter', function() {
		var date;
		if($scope.deadlineDateFilter) {
			date = $scope.deadlineDateFilter.match(/([<>=])\s*(0[1-9]|[12][0-9]|3[01])[- //.](0[1-9]|1[012])[- //.](19|20\d\d)/);
			if(date) {
				var filterDate = new Date(date[4], date[3] - 1, date[2]);
				angular.forEach($scope.requestTasks, function(requestTask) {
					var deadlineDate = new Date(requestTask.deadline_date);
					console.log(deadlineDate);
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

	$scope.$watch('editingAuditorId', function() {
		$scope.editingInputs.auditorId = ($scope.editingAuditorId != "" && $scope.editingAuditorId != null);
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
	});

	$scope.$watch('editingDeadlineDate', function() {
		$scope.editingInputs.deadlineDate = ($scope.editingDeadlineDate != "" && $scope.editingDeadlineDate != null);
	});

	$scope.$watch('editingExecutionDate', function() {
		$scope.editingInputs.executionDate = ($scope.editingExecutionDate != "" && $scope.editingExecutionDate != null);
	});

	$scope.$watch('editingAuditionDate', function() {
		$scope.editingInputs.auditionDate = ($scope.editingAuditionDate != "" && $scope.editingAuditionDate != null);
	});

	$scope.updateRequestTask = function() {
		var attr = {};
		attr.executor_id = $scope.editingExecutorId;
		attr.auditor_id = $scope.editingAuditorId;
		attr.description = $scope.editingDescription;
		attr.deadline_date = $scope.editingDeadlineDate;
		attr.execution_date = $scope.editingExecutionDate;
		attr.audition_date = $scope.editingAuditionDate;

		var updatedRequestTask = RequestTask.update($scope.editingId, attr);
		$scope.requestTasks[$scope.editingIdx] = updatedRequestTask;

		$scope.editingExecutorId = "";
		$scope.editingAuditorId = "";
		$scope.editingDescription = "";
		$scope.editingDeadlineDate = "";
		$scope.editingExecutionDate = "";
		$scope.editingAuditionDate = "";

		$scope.editing = false;

		$timeout(function(){$scope.setWidth();}, 300);
	};

	$scope.clickRequestTask = function(idx) {
		var r = RequestTask.get($scope.requestTasks[idx].id);
		r.$promise.then(function() {
			$scope.editingRequestTask = r;
			$scope.editingRequest = r.request;
			$scope.editingId = r.id;
			$scope.editingIdx = idx;

			$scope.editingExecutorId = r.executor_id;
			$scope.editingAuditorId = r.auditor_id;
			$scope.editingDescription = r.description;
			$scope.editingDeadlineDate = $scope.dateForInput(r.deadline_date);
			$scope.editingExecutionDate = $scope.dateForInput(r.execution_date);
			$scope.editingAuditionDate = $scope.dateForInput(r.audition_date);

			$scope.editing = true;
		});
	};

	function addZero(str) {
		return (str.toString().length == 1) ? ('0' + str) : str;
	}

	$scope.formattedDate = function(dateStr) {
		if(dateStr == '' || dateStr == null) return '';
		var d = new Date(dateStr);
		return addZero(d.getDate()) + '.' + addZero(d.getMonth() + 1) + '.' + d.getFullYear() + ' ' + 
		addZero(d.getHours()) + ':' + addZero(d.getMinutes()) + ':' + addZero(d.getSeconds());
	};

	$scope.dateForInput = function(dateStr) {
		if(dateStr == '' || dateStr == null) return '';
		var d = new Date(dateStr);
		return d.getFullYear() + "-" + 
			addZero((d.getMonth() + 1)) + "-" +
			addZero(d.getDate()) + "T" +
			addZero(d.getHours()) + ":" +
			addZero(d.getMinutes()) + ":" +
			addZero(d.getSeconds());
	};

	$scope.setMinDate = function($event) {
		if(!$scope.clicked) {
			var str = $scope.dateForInput(new Date());
			$($event.target).attr('min', str);
			$scope.clicked = true;
		}
	};

	$scope.canEditDeadlineDate = function(employee_id) {
		return ($scope.editingIdx != null) ? 
			(employee_id == $scope.requestTasks[$scope.editingIdx].auditor_id) :
			false;
	};

	function requestTasksFilter() {
		var attr = {
			'who_am_i[]': [],
			'overdued[]': [],
			'indicators[]': []
		};

		for(var key in $scope.overdued) {
			if($scope.overdued[key]) {
				attr['overdued[]'].push(key);
			}
		}

		for(var key in $scope.whoAmI) {
			if($scope.whoAmI[key]) {
				attr['who_am_i[]'].push(key);
			}
		}

		for(var key in $scope.indicators) {
			if($scope.indicators[key]) {
				attr['indicators[]'].push(key);
			}
		}

		$scope.requestTasks = RequestTask.all(attr);
	}

	$scope.whoAmIFilter = function(str) {
		$scope.whoAmI[str] = !$scope.whoAmI[str];

		switch(str) {
			case 'assigner':
				$scope.indicators.assign = false;
				break;

			case 'executor':
				$scope.indicators.execute = false;
				break;

			case 'auditor':
				$scope.indicators.audit = false;
				break;
		}

		requestTasksFilter();
	};

	$scope.overduedFilter = function(str) {
		$scope.overdued[str] = !$scope.overdued[str];
		requestTasksFilter();
	};

	$scope.indicatorsFilter = function(str) {
		$scope.indicators[str] = !$scope.indicators[str];
		requestTasksFilter();
	};
}

newVending.controller("RequestTasksCtrl",['$scope', '$timeout', 'RequestTask', 'Employee', RequestTasksCtrl]);