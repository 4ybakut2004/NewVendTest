function RequestsCtrl($scope, Request, Message, Machine) {
	$scope.requests = Request.all();
	$scope.messages = Message.all();
	$scope.machines = Machine.all();
	$scope.editing = false;
	$scope.newMessages = [];

	$scope.inputs = {
		machine_id: false,
		requestType: false,
		phone: false,
		description: false
	};

	$scope.editingInputs = {
		description: false,
		machineId: false
	};

	$scope.whoAmI = {
		registrar: false
	};

	$scope.$watch('newRequestType', function() {
		$scope.inputs.requestType = ($scope.newRequestType != "" && $scope.newRequestType != null);
		$scope.newPhone = "";
		$scope.newMessages = [];
		$scope.newDescription = "";
	});

	$scope.$watch('newMachineId', function() {
		$scope.inputs.machineId = ($scope.newMachineId != "" && $scope.newMachineId != null);
	});

	$scope.$watch('newPhone', function() {
		$scope.inputs.phone = ($scope.newPhone != "" && $scope.newPhone != null);
	});

	$scope.$watch('newDescription', function() {
		$scope.inputs.description = ($scope.newDescription != "" && $scope.newDescription != null);
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
	});

	$scope.$watch('editingMachineId', function() {
		$scope.editingInputs.machineId = ($scope.editingMachineId != "" && $scope.editingMachineId != null);
	});

	$scope.resetNewRequest = function() {
		$scope.newRequestType = "";
		$scope.newMachineId = $scope.machines[0].id;
		$scope.newPhone = "";
		$scope.newMessages = [];
		$scope.newDescription = "";
	};

	$scope.createRequest = function() {
		var attr = {};
		attr.request_type = $scope.newRequestType;
		attr.machine_id = $scope.newMachineId;
		attr.description = $scope.newDescription;
		if(attr.request_type == "phone") {
			attr.phone = $scope.newPhone;
		}
		attr.messages = [];

		angular.forEach($scope.newMessages, function(message){
			var attributes = [];
			angular.forEach(message.attributes, function(attribute){
				if(attribute.value){
					attributes.push({
						id: attribute.id,
						value: attribute.value
					});
				}
			});

			attr.messages.push({
				id: message.id,
				attributes: attributes
			});
		});

		var newRequest = Request.create(attr);

		$scope.requests.unshift(newRequest);
		$scope.resetNewRequest();
		$('#newRequest').modal('hide');
	};

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
		var r = Request.get($scope.requests[idx].id);
		r.$promise.then(function() {
			$scope.editingRequest = r;
			$scope.editingId = r.id;
			$scope.editingIdx = idx;

			$scope.editingDescription = r.description;
			$scope.editingMachineId = r.machine_id;
			$scope.editingRegistrarName = r.registrar_name;
			$scope.editingRequestTypeName = r.request_type_name;
			$scope.editingRequestType = r.request_type;
			$scope.editingPhone = r.phone;

			$scope.requestMessages = r.request_messages;
			$scope.editing = true;
		});
	};

	$scope.setNewRequestType = function(request_type) {
		$scope.newRequestType = request_type;
	};

	$scope.addMessage = function(message) {
		$scope.newMessages.unshift($.extend(true, {}, message));
	};

	$scope.deleteMessage = function(idx) {
		$scope.newMessages.splice(idx, 1);
	};

	$scope.inputType = function(type) {
		switch(type) {
			case "number":
				return "number";
			case "string":
				return "text";
		}
	};

	function requestsFilter() {
		var attr = {
			'who_am_i[]': []
		};

		for(var key in $scope.whoAmI) {
			if($scope.whoAmI[key]) {
				attr['who_am_i[]'].push(key);
			}
		}

		$scope.requests = Request.all(attr);
	}

	$scope.whoAmIFilter = function(str) {
		$scope.whoAmI[str] = !$scope.whoAmI[str];
		requestsFilter();
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
}

newVending.controller("RequestsCtrl",['$scope', 'Request', 'Message', 'Machine', RequestsCtrl]);