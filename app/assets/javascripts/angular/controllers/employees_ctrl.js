/***********************************************************
 ** employees_ctrl.js **************************************
 ***********************************************************
 * Контроллер страницы Сотрудники.
 **********************************************************/

function EmployeesCtrl($scope, $timeout, Employee) {
//- Инициализация моделей ----------------------------------
	$scope.employees = Employee.all();
	$scope.editing = false;

	$scope.inputs = {
		name: false,
		email: false
	};

	$scope.inputsErrors = {
		email: false
	};

	$scope.editingInputs = {
		name: false,
		email: false
	};

	$scope.editingErrors = {
		email: false
	};

//- Мониторинг изменения моделей ---------------------------
	$scope.changeWidth = function() {
		$timeout(function(){$scope.setWidth();}, 300);
	};
	
	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$timeout(function(){$scope.setWidth();}, 300);
		}
	});

	$scope.$watch('newName', function() {
		$scope.inputs.name = ($scope.newName != "" && $scope.newName != null);
	});

	$scope.$watch('newEmail', function() {
		$scope.inputs.email = ($scope.newEmail != "" && $scope.newEmail != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.$watch('editingEmail', function() {
		$scope.editingInputs.email = ($scope.editingEmail != "" && $scope.editingEmail != null);
	});

//- Изменение моделей --------------------------------------
	$scope.createEmployee = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.email = $scope.newEmail;
		var newEmployee = Employee.create(attr);

		$scope.employees.unshift(newEmployee);
		$scope.newName = "";
		$scope.newEmail = "";

		$scope.inputsErrors.email = false;

		$('#newEmployee').modal('hide');
	};

	$scope.updateEmployee = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.email = $scope.editingEmail;
		var updatedEmployee = Employee.update($scope.editingId, attr);

		updatedEmployee.$promise.then(function(employee) {
			$scope.employees[$scope.editingIdx] = updatedEmployee;
			$scope.editingName = "";
			$scope.editingEmail = "";
			$scope.editing = false;
		}, function(error) {
			$scope.editingErrors.email = true;
		});
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
		$scope.editingEmail = $scope.employees[idx].email;

		$scope.editingErrors.email = false;

		$scope.editing = true;
	};
}

newVending.controller("EmployeesCtrl",['$scope', '$timeout', 'Employee', EmployeesCtrl]);