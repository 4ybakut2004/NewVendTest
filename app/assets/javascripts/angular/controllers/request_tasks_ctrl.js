function RequestTasksCtrl($scope, RequestTask, Employee) {
	$scope.requestTasks = RequestTask.all();
	$scope.employees = Employee.all();
	$scope.editing = false;

	$scope.editingInputs = {
		executorId: false,
		auditorId: false,
		description: false,
		deadlineDate: false,
		executionDate: false,
		auditionDate: false
	};

	$scope.$watch('editingExecutorId', function() {
		$scope.editingInputs.executorId = ($scope.editingExecutorId != "" && $scope.editingExecutorId != null);
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
	};

	$scope.clickRequestTask = function(idx) {
		$scope.editingId = $scope.requestTasks[idx].id;
		$scope.editingIdx = idx;

		$scope.editingExecutorId = $scope.requestTasks[idx].executor_id;
		$scope.editingAuditorId = $scope.requestTasks[idx].auditor_id;
		$scope.editingDescription = $scope.requestTasks[idx].description;
		$scope.editingDeadlineDate = $scope.dateForInput($scope.requestTasks[idx].deadline_date);
		$scope.editingExecutionDate = $scope.dateForInput($scope.requestTasks[idx].execution_date);
		$scope.editingAuditionDate = $scope.dateForInput($scope.requestTasks[idx].audition_date);

		$scope.editing = true;
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
}

newVending.controller("RequestTasksCtrl",['$scope', 'RequestTask', 'Employee', RequestTasksCtrl]);