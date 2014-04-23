function RequestTypesCtrl($scope, $timeout, RequestType, Message) {
	$scope.requestTypes = RequestType.all();
	$scope.messages = Message.all();
	$scope.editing = false;

	$scope.existsFilter = {
		exists: true
	};

	$scope.notExistsFilter = {
		exists: false
	};

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

	$scope.$watch('search', function(){
		$scope.setWidth();
	});

	$scope.$watch('newName', function() {
		$scope.inputs.name = ($scope.newName != "" && $scope.newName != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.createRequestType = function() {
		var attr = {};
		attr.name = $scope.newName;

		attr.messages = [];
		angular.forEach($scope.messages, function(message){
			if(message.checked) {
				attr.messages.push(message.id);
				message.checked = false;
			}
		});

		var newRequestType = RequestType.create(attr);

		$scope.requestTypes.unshift(newRequestType);
		$scope.newName = "";
		$('#newRequestType').modal('hide');
	};

	$scope.updateRequestType = function() {
		var attr = {};
		attr.name = $scope.editingName;

		if($scope.requestTypeMessagesChanged) {
			attr.messages = [];
			angular.forEach($scope.requestTypeMessages, function(message) {
				if(message.exists) {
					attr.messages.push(message.id);
				}
			});
			attr.requestTypeMessagesChanged = true;
		}

		var updatedRequestType = RequestType.update($scope.editingId, attr);
		$scope.requestTypes[$scope.editingIdx] = updatedRequestType;

		$scope.editingName = "";
		$scope.requestTypeMessagesChanged = false;
		$scope.editing = false;
	};

	$scope.deleteRequestType = function(id, idx) {
		$scope.requestTypes.splice(idx, 1);
		return RequestType.delete(id);
	};

	$scope.deleteRequestTypes = function() {
		var oldRequestTypes = $scope.requestTypes;
		$scope.requestTypes = [];
		angular.forEach(oldRequestTypes, function(requestType) {
			if (!requestType.checked) { 
				$scope.requestTypes.push(requestType);
			}
			else {
				RequestType.delete(requestType.id);
			}
		});
		return true;
	};

	$scope.clickRequestType = function(idx) {
		var rt = RequestType.get($scope.requestTypes[idx].id);
		rt.$promise.then(function() {
			$scope.editingRequestType = rt;
			$scope.editingId = rt.id;
			$scope.editingIdx = idx;

			$scope.editingName = rt.name;

			$scope.requestTypeMessages = [];
			var requestTypeMessagesIndexes = [];
			angular.forEach(rt.messages, function(message) {
				requestTypeMessagesIndexes.push(message.id);
			});
			angular.copy($scope.messages, $scope.requestTypeMessages);
			angular.forEach($scope.requestTypeMessages, function(requestTypeMessage) {
				if(requestTypeMessagesIndexes.indexOf(requestTypeMessage.id) != -1) {
					requestTypeMessage.exists = true;
				}
				else {
					requestTypeMessage.exists = false;
				}
			});

			$scope.editing = true;
		});
	};

	$scope.check = function(item) {
		item.checked = !item.checked;
	};

	$scope.changeRequestTypeMessage = function(item) {
		item.exists = !item.exists;
		$scope.requestTypeMessagesChanged = true;
	};
}

newVending.controller("RequestTypesCtrl",['$scope', '$timeout', 'RequestType', 'Message', RequestTypesCtrl]);