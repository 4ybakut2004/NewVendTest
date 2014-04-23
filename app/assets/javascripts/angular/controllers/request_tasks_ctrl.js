function RequestTasksCtrl($scope, $timeout, RequestTask, Employee) {
	$scope.requestTasks = RequestTask.all({ request_id: getURLParameter('request_id') });
	$scope.employees = Employee.all();

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

	$scope.setIndicatorsCounts();

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

	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$timeout(function(){$scope.setWidth();}, 300);
		}
	});

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
		attr.deadline_date = strDateToUTC($scope.editingDeadlineDate);
		attr.execution_date = strDateToUTC($scope.editingExecutionDate);
		attr.audition_date = strDateToUTC($scope.editingAuditionDate);

		var updatedRequestTask = RequestTask.update($scope.editingId, attr);
		$scope.requestTasks[$scope.editingIdx] = updatedRequestTask;

		$scope.setIndicatorsCounts();

		$scope.editingExecutorId = "";
		$scope.editingAuditorId = "";
		$scope.editingDescription = "";
		$scope.editingDeadlineDate = "";
		$scope.editingExecutionDate = "";
		$scope.editingAuditionDate = "";
		$scope.editingIdx = null;

		$scope.editing = false;
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

	$scope.formattedDate = formattedDate;
	$scope.dateForInput = dateForInput;

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

		$timeout(function(){$scope.setWidth();}, 300);
	}

	$scope.whoAmIFilter = function(str) {
		$scope.whoAmI[str] = !$scope.whoAmI[str];

		if(!$scope.whoAmI[str]) {
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
		}

		requestTasksFilter();
	};

	$scope.overduedFilter = function(str) {
		$scope.overdued[str] = !$scope.overdued[str];
		requestTasksFilter();
	};

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
}

newVending.controller("RequestTasksCtrl",['$scope', '$timeout', 'RequestTask', 'Employee', RequestTasksCtrl]);