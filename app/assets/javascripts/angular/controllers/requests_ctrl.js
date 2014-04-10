function RequestsCtrl($scope, Request, Message) {
	$scope.requests = Request.all();
	$scope.messages = Message.all();
	$scope.editing = false;

	$scope.inputs = {
		machine_id: false,
		requestType: false,
		phone: false
	};

	$scope.editingInputs = {
		description: false,
		machineId: false
	};

	$scope.$watch('newRequestType', function() {
		$scope.inputs.requestType = ($scope.newRequestType != "" && $scope.newRequestType != null);
		$scope.newPhone = "";
	});

	$scope.$watch('newMachineId', function() {
		$scope.inputs.machineId = ($scope.newMachineId != "" && $scope.newMachineId != null);
	});

	$scope.$watch('newPhone', function() {
		$scope.inputs.phone = ($scope.newPhone != "" && $scope.newPhone != null);
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
	});

	$scope.$watch('editingMachineId', function() {
		$scope.editingInputs.machineId = ($scope.editingMachineId != "" && $scope.editingMachineId != null);
	});

	$scope.updateRequest = function() {
		var attr = {};
		attr.description = $scope.editingDescription;
		attr.machine_id = $scope.editingMachineId;
		var updatedRequest = Request.update($scope.editingId, attr);
		$scope.requests[$scope.editingIdx] = updatedRequest;

		$scope.editingDescription = "";
		$scope.editingMachineId = "";
		$scope.editing = false;
	};

	$scope.deleteRequest = function(id, idx) {
		$scope.requests.splice(idx, 1);
		return Request.delete(id);
	};

	$scope.deleteRequests = function() {
		var oldRequests = $scope.requests;
		$scope.requests = [];
		angular.forEach(oldRequests, function(request) {
			if (!request.checked) { 
				$scope.requests.push(request);
			}
			else {
				Request.delete(request.id);
			}
		});
		return true;
	};

	$scope.clickRequest = function(idx) {
		$scope.editingId = $scope.requests[idx].id;
		$scope.editingIdx = idx;

		$scope.editingDescription = $scope.requests[idx].description;
		$scope.editingMachineId = $scope.requests[idx].machine_id;
		$scope.editingRegistrarName = $scope.requests[idx].registrar_name;
		$scope.editingRequestTypeName = $scope.requests[idx].request_type_name;
		$scope.editingRequestType = $scope.requests[idx].request_type;
		$scope.editingPhone = $scope.requests[idx].phone;

		$scope.requestMessages = $scope.requests[idx].request_messages;
		$scope.requestTasks = $scope.requests[idx].request_tasks;
		$scope.editing = true;
	};

	$scope.setNewRequestType = function(request_type) {
		$scope.newRequestType = request_type;
	};
}

newVending.controller("RequestsCtrl",['$scope', 'Request', 'Message', RequestsCtrl]);