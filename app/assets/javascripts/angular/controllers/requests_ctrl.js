/***********************************************************
 ** requests_ctrl.js ***************************************
 ***********************************************************
 * Контроллер страницы Заявки.
 **********************************************************/

function RequestsCtrl($scope, $timeout, Request, Message, Machine, RequestType) {
//- Инициализация моделей ----------------------------------
	function init() {
		$scope.requestTaskId = getURLParameter("request_task_id");

		$scope.perPage = 10;
		$scope.pager = new Pager({
			perPage: $scope.perPage,
			controllerScope: $scope,
			filterMethod: $scope.getFilterAttrs,
			service: Request,
			containerName: "requests"
		});

		// Присутствие id поручения в параметрах означает,
		// что пользователь нажал кнопку создания заявки из поручения.
		// При этом неободимо открыть окно создания заявки.
		if(!$scope.requestTaskId) {
			$scope.requests = Request.all();
		}
		else {
			$scope.requests = [];
			$('#newRequest').modal('show');
		}

		$scope.messages = Message.all();
		$scope.machines = Machine.all();

		// Настраиваем начальное значение селект бокса с автоматами
		$scope.machines.$promise.then(function() {
			$scope.newMachineId = $scope.machines[0].id;
		});

		$scope.pager.calcPageCount($scope.getFilterAttrs());

		$scope.requestTypes = RequestType.all();
		$scope.editing = false;
		$scope.newMessages = [];

		$scope.inputs = {
			machineId: false,
			requestTypeId: false,
			phone: false,
			description: false
		};

		$scope.inputsErrors = {
			machine_id: "",
			description: ""
		};

		$scope.editingInputs = {
			description: false,
			machineId: false
		};

		$scope.editingErrors = {
			machine_id: "",
			description: ""
		};

		$scope.whoAmI = {
			registrar: false
		};
	}

//- Мониторинг изменения моделей ---------------------------
	$scope.changeWidth = function() {
		$timeout(function(){$scope.setWidth();}, 300);
	};
	
	$scope.$watch('editing', function() {
		if($scope.editing == false) {
			$scope.changeWidth();
		}
	});

	$scope.$watch('newRequestTypeId', function() {
		// В создании новой заявки при изменении ее типа следует 
		// обнулить модели, в которые сохраняются данные о новой заявке
		$scope.inputs.requestTypeId = ($scope.newRequestTypeId != "" && $scope.newRequestTypeId != null);
		$scope.newPhone = "";
		$scope.newMessages = [];
		$scope.newDescription = "";
	});

	$scope.$watch('newMachineId', function() {
		$scope.inputs.machineId = ($scope.newMachineId != "" && $scope.newMachineId != null);
		$scope.inputsErrors.machine_id = "";
	});

	$scope.$watch('newPhone', function() {
		$scope.inputs.phone = ($scope.newPhone != "" && $scope.newPhone != null);
	});

	$scope.$watch('newDescription', function() {
		$scope.inputs.description = ($scope.newDescription != "" && $scope.newDescription != null);
		$scope.inputsErrors.description = "";
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
		$scope.editingErrors.description = "";
	});

	$scope.$watch('editingMachineId', function() {
		$scope.editingInputs.machineId = ($scope.editingMachineId != "" && $scope.editingMachineId != null);
		$scope.editingErrors.machine_id = "";
	});

//- Изменение моделей --------------------------------------
	$scope.resetNewRequest = function() {
		$scope.newRequestTypeId = "";
		$scope.newMachineId = $scope.machines[0].id;
		$scope.newPhone = "";
		$scope.newMessages = [];
		$scope.newDescription = "";
		$scope.requestTypeMessages = {};
	};

	$scope.closeNew = function() {
		$scope.resetNewRequest();
		$('#newRequest').modal('hide');
	};

	$scope.closeEditing = function() {
		$scope.editing = false;

		$scope.editingDescription = "";
		$scope.editingMachineId = "";

		$scope.editingErrors.machine_id = "";
		$scope.editingErrors.description = "";
	};

	$scope.createRequest = function() {
		var attr = {};
		attr.request_type_id = $scope.newRequestTypeId;
		attr.machine_id = $scope.newMachineId;
		attr.description = $scope.newDescription;
		attr.phone = $scope.newPhone;

		if($scope.requestTaskId) {
			attr.request_task_id = $scope.requestTaskId;
		}

		// Создаем массив сигналов, которые необходимо создать
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

			// При создании сигнала так же нужно создать атрибуты для него,
			// по-этому привязываем к сигналу массив атрибутов
			attr.messages.push({
				id: message.id,
				attributes: attributes
			});
		});

		var newRequest = Request.create(attr);
		newRequest.$promise.then(function() {
			if($scope.pager.currentPage == 1) {
				$scope.requests.unshift(newRequest);
				if($scope.requests.length > $scope.perPage) {
					$scope.requests.splice($scope.requests.length - 1, 1);
					$scope.pager.calcPageCount(attr);
				}
			}
			else {
				$scope.pager.setPage($scope.pager.currentPage);
			}

			$scope.closeNew();
		}, function(d) {
			showErrors(d.data, $scope.inputsErrors);
		});
	};

	$scope.updateRequest = function() {
		var attr = {};
		attr.description = $scope.editingDescription;
		attr.machine_id = $scope.editingMachineId;

		var updatedRequest = Request.update($scope.editingId, attr);
		updatedRequest.$promise.then(function() {
			$scope.requests[$scope.editingIdx] = updatedRequest;
			$scope.closeEditing();
		}, function(d) {
			showErrors(d.data, $scope.editingErrors);
		});
	};

	$scope.deleteRequests = function() {
		var deleted = 0;
		var toDelete = 0;

		angular.forEach($scope.requests, function(request) {
			if(request.checked) {
				toDelete++;
			}
		});

		angular.forEach($scope.requests, function(request) {
			if(request.checked) {
				Request.delete(request.id).$promise.then(function() {
					deleted++;
					if(deleted == toDelete) {
						$scope.pager.setPage($scope.pager.currentPage);
					}
				});
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
			$scope.editingRequestTypeId = r.request_type_id;
			$scope.editingPhone = r.phone;
			$scope.editingRequestTaskId = r.request_task_id;

			$scope.requestMessages = r.request_messages;
			$scope.editing = true;
		});

		console.log($scope.pager.pages);
	};

	$scope.setNewRequestTypeId = function(request_type_id) {
		$scope.newRequestTypeId = request_type_id;

		var rt = RequestType.get(request_type_id);
		rt.$promise.then(function() {
			$scope.requestTypeMessages = rt.messages;
		}); 
	};

	$scope.addMessage = function(message) {
		message.count ? message.count++ : message.count = 1;
		var newMessage = $.extend(true, {}, message);
		newMessage.message = message;
		$scope.newMessages.unshift(newMessage);
	};

	$scope.deleteMessage = function(idx) {
		$scope.newMessages[idx].message.count--;
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
		var attr = $scope.getFilterAttrs();
		$scope.pager.calcPageCount(attr);
		var newRequests = Request.all(attr);
		newRequests.$promise.then(function() {
			$scope.requests = newRequests;
		});
		$scope.changeWidth();
	}

	$scope.getFilterAttrs = function() {
		var attr = {
			'who_am_i[]': [],
			'page': $scope.pager.currentPage
		};

		for(var key in $scope.whoAmI) {
			if($scope.whoAmI[key]) {
				attr['who_am_i[]'].push(key);
			}
		}

		return attr;
	};

	$scope.whoAmIFilter = function(str) {
		$scope.whoAmI[str] = !$scope.whoAmI[str];
		requestsFilter();
	};

	$scope.formattedDate = formattedDate;
	$scope.dateForInput = dateForInput;

	init();
}

newVending.controller("RequestsCtrl",['$scope', '$timeout', 'Request', 'Message', 'Machine', 'RequestType', RequestsCtrl]);