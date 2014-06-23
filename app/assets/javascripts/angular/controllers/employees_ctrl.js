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
		email: false,
		phone: false
	};

	$scope.inputsErrors = {
		name: "",
		email: ""
	};

	$scope.editingInputs = {
		name: false,
		email: false,
		phone: false
	};

	$scope.editingErrors = {
		name: "",
		email: ""
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
		$scope.inputsErrors.name = "";
	});

	$scope.$watch('newEmail', function() {
		$scope.inputs.email = ($scope.newEmail != "" && $scope.newEmail != null);
		$scope.inputsErrors.email = "";
	});

	$scope.$watch('newPhone', function() {
		$scope.inputs.phone = ($scope.newPhone != "" && $scope.newPhone != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
		$scope.editingErrors.name = "";
	});

	$scope.$watch('editingEmail', function() {
		$scope.editingInputs.email = ($scope.editingEmail != "" && $scope.editingEmail != null);
		$scope.editingErrors.email = "";
	});

	$scope.$watch('editingPhone', function() {
		$scope.editingInputs.phone = ($scope.editingPhone != "" && $scope.editingPhone != null);
	});

//- Изменение моделей --------------------------------------
	$scope.createEmployee = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.email = $scope.newEmail;
		attr.phone = $scope.newPhone;

		var newEmployee = Employee.create(attr);
		newEmployee.$promise.then(function() {
			$scope.employees.unshift(newEmployee);
			$scope.closeNew();
		}, function(d) {
			showErrors(d.data, $scope.inputsErrors);
		});
	};

	$scope.updateEmployee = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.email = $scope.editingEmail;
		attr.phone = $scope.editingPhone;
		var updatedEmployee = Employee.update($scope.editingId, attr);

		updatedEmployee.$promise.then(function(employee) {
			$scope.employees[$scope.editingIdx] = updatedEmployee;
			$scope.closeEditing();
		}, function(d) {
			showErrors(d.data, $scope.editingErrors);
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
		$scope.editingPhone = $scope.employees[idx].phone;

		$scope.editing = true;
	};

	$scope.closeEditing = function() {
		$scope.editing = false;

		$scope.editingName = "";
		$scope.editingEmail = "";
		$scope.editingPhone = "";

		$scope.editingErrors.name = "";
		$scope.editingErrors.email = "";
	};

	$scope.closeNew = function() {
		$('#newEmployee').modal('hide');
		$scope.resetNewEmployee();
	};

	$scope.resetNewEmployee = function() {
		$scope.newName = "";
		$scope.newEmail = "";
		$scope.newPhone = "";
	};
}

newVending.controller("EmployeesCtrl",['$scope', '$timeout', 'Employee', EmployeesCtrl]);