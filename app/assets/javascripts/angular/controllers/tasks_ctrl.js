function TasksCtrl($scope, Task, Message) {
	$scope.tasks = Task.all();
	$scope.messages = Message.all();

	$scope.editing = false;

	$scope.inputs = {
		name: false,
		deadline: false
	};

	$scope.editingInputs = {
		name: false,
		deadline: false
	};

	$scope.$watch('newName', function() {
		$scope.inputs.name = ($scope.newName != "" && $scope.newName != null);
	});

	$scope.$watch('newDeadline', function() {
		$scope.inputs.deadline = ($scope.newDeadline != "" && $scope.newDeadline != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.$watch('editingDeadline', function() {
		$scope.editingInputs.deadline = ($scope.editingDeadline != "" && $scope.editingDeadline != null);
	});

	$scope.createTask = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.deadline = $scope.newDeadline;
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
		$('#newTask').modal('hide');
	};

	$scope.updateTask = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.deadline = $scope.editingDeadline;
		var updatedTask = Task.update($scope.editingId, attr);
		$scope.tasks[$scope.editingIdx] = updatedTask;

		$scope.editingName = "";
		$scope.editingDeadline = "";
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

		$scope.taskMessages = $scope.tasks[idx].messages;

		$scope.editing = true;
	};

	$scope.check = function(item) {
		item.checked = !item.checked;
	};
}

newVending.controller("TasksCtrl",['$scope', 'Task', 'Message', TasksCtrl]);