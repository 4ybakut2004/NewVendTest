function UsersCtrl($scope, User, Employee) {
	$scope.users = User.all();
	$scope.editing = false;

	$scope.editingInputs = {
		employee_id: false
	};

	$scope.$watch('editingEmployeeId', function() {
		$scope.editingInputs.employee_id = ($scope.editingEmployeeId != "" && $scope.editingEmployeeId != null);
	});

	$scope.updateUser = function() {
		var attr = {};
		attr.employee_id = $scope.editingEmployeeId;
		var updatedUser = User.update($scope.editingId, attr);
		$scope.users[$scope.editingIdx] = updatedUser;

		$scope.editingEmployeeId = "";
		$scope.editing = false;
	};

	$scope.clickUser = function(idx) {
		$scope.editingId = $scope.users[idx].id;
		$scope.editingIdx = idx;
		$scope.editingEmployeeId = ($scope.users[idx].employee != null) ? $scope.users[idx].employee.id : "";
		$scope.editing = true;
	};
}

newVending.controller("UsersCtrl",['$scope', 'User', 'Employee', UsersCtrl]);