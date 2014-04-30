/***********************************************************
 ** tasks_ctrl.js ******************************************
 ***********************************************************
 * Контроллер страницы Типы Поручений.
 **********************************************************/

function TasksCtrl($scope, $timeout, Task, Message, Employee) {
//- Инициализация моделей ----------------------------------
	$scope.tasks = Task.all();
	$scope.messages = Message.all();
	$scope.employees = Employee.all();

	/*$scope.employees.$promise.then(function() {
		$scope.employees.unshift({ name: "" });
	});*/

	$scope.editing = false;

	$scope.inputs = {
		name: false,
		deadline: false,
		solverId: false
	};

	$scope.editingInputs = {
		name: false,
		deadline: false,
		solverId: false
	};

//- Мониторинг изменения моделей ---------------------------
	$scope.changeWidth = function() {
		$timeout(function(){$scope.setWidth();}, 300);
	};
	
	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$scope.changeWidth();
		}
	});

	$scope.$watch('newName', function() {
		$scope.inputs.name = ($scope.newName != "" && $scope.newName != null);
	});

	$scope.$watch('newDeadline', function() {
		$scope.inputs.deadline = ($scope.newDeadline != "" && $scope.newDeadline != null);
	});

	$scope.$watch('newSolverId', function() {
		$scope.inputs.solverId = ($scope.newSolverId != "" && $scope.newSolverId != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.$watch('editingDeadline', function() {
		$scope.editingInputs.deadline = ($scope.editingDeadline != "" && $scope.editingDeadline != null);
	});

	$scope.$watch('editingSolverId', function() {
		$scope.editingInputs.solverId = ($scope.editingSolverId != "" && $scope.editingSolverId != null);
	});

//- Изменение моделей --------------------------------------
	$scope.createTask = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.deadline = $scope.newDeadline;
		attr.solver_id = $scope.newSolverId;
		attr.messages = [];
		angular.forEach($scope.messages, function(message){
			if(message.checked) {
				attr.messages.push(message.id);
			}
		});
		var newTask = Task.create(attr);

		$scope.tasks.unshift(newTask);
		$scope.newName = "";
		$scope.newDeadline = "";
		$scope.newSolverId = "";
		$('#newTask').modal('hide');
	};

	$scope.updateTask = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.deadline = $scope.editingDeadline;
		attr.solver_id = $scope.editingSolverId;
		var updatedTask = Task.update($scope.editingId, attr);
		$scope.tasks[$scope.editingIdx] = updatedTask;

		$scope.editingName = "";
		$scope.editingDeadline = "";
		$scope.editingSolverId = "";
		$scope.editing = false;
	};

	$scope.deleteTask = function(id, idx) {
		$scope.tasks.splice(idx, 1);
		return Task.delete(id);
	};

	$scope.deleteTasks = function() {
		var oldTasks = $scope.tasks;
		$scope.tasks = [];
		angular.forEach(oldTasks, function(task) {
			if (!task.checked) { 
				$scope.tasks.push(task);
			}
			else {
				Task.delete(task.id);
			}
		});
		return true;
	};

	$scope.clickTask = function(idx) {
		$scope.editingId = $scope.tasks[idx].id;
		$scope.editingIdx = idx;
		$scope.editingName = $scope.tasks[idx].name;
		$scope.editingDeadline = $scope.tasks[idx].deadline;
		$scope.editingSolverId = $scope.tasks[idx].solver_id;

		$scope.taskMessages = $scope.tasks[idx].messages;

		$scope.editing = true;
	};

	$scope.check = function(item) {
		item.checked = !item.checked;
	};
}

newVending.controller("TasksCtrl",['$scope', '$timeout', 'Task', 'Message', 'Employee', TasksCtrl]);