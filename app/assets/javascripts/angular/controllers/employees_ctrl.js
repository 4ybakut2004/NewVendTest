function EmployeesCtrl($scope, Employee) {
	$scope.employees = Employee.all();
	$scope.requestError = false;
	$scope.fieldsError = false;

	$scope.createEmployee = function() {
		var attr = {};
		attr.name = $scope.newName;
		var newEmployee = Employee.create(attr);

		if(newEmployee.errors) {
			$scope.fieldsError = true;
		}
		else {
			$scope.employees.unshift(newEmployee);
			$scope.newName = "";
			$('#newEmployee').modal('hide');
		}
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
}

newVending.controller("EmployeesCtrl",['$scope', 'Employee', EmployeesCtrl]);