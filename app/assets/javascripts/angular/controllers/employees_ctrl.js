function EmployeesCtrl($scope, $timeout, Employee) {
	$scope.employees = Employee.all();
	$scope.editing = false;

	$scope.inputs = {
		name: false
	};

	$scope.editingInputs = {
		name: false
	};

	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$timeout(function(){$scope.setWidth();}, 300);
		}
	});

	$scope.$watch('search', function() {
		$scope.setWidth();
	});

	$scope.$watch('newName', function() {
		$scope.inputs.name = ($scope.newName != "" && $scope.newName != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.createEmployee = function() {
		var attr = {};
		attr.name = $scope.newName;
		var newEmployee = Employee.create(attr);

		$scope.employees.unshift(newEmployee);
		$scope.newName = "";
		$('#newEmployee').modal('hide');
	};

	$scope.updateEmployee = function() {
		var attr = {};
		attr.name = $scope.editingName;
		var updatedEmployee = Employee.update($scope.editingId, attr);
		$scope.employees[$scope.editingIdx] = updatedEmployee;

		$scope.editingName = "";
		$scope.editing = false;
	};

	$scope.deleteEmployee = function(id, idx) {
		$scope.employees.splice(idx, 1);
		return Employee.delete(id);
	};

	$scope.deleteEmployees = function() {
		var oldEmployees = $scope.employees;
		$scope.employees = [];
		angular.forEach(oldEmployees, function(employee) {
			if (!employee.checked) { 
				$scope.employees.push(employee);
			}
			else {
				Employee.delete(employee.id);
			}
		});
		return true;
	};

	$scope.clickEmployee = function(idx) {
		$scope.editingId = $scope.employees[idx].id;
		$scope.editingIdx = idx;
		$scope.editingName = $scope.employees[idx].name;
		$scope.editing = true;
	};
}

newVending.controller("EmployeesCtrl",['$scope', '$timeout', 'Employee', EmployeesCtrl]);