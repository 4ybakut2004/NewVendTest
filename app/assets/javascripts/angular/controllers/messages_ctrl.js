/***********************************************************
 ** messages_ctrl.js ***************************************
 ***********************************************************
 * Контроллер страницы Типы Сигналов.
 **********************************************************/

function MessagesCtrl($scope, $timeout, Message, Task, Attribute, RequestType) {
//- Инициализация моделей ----------------------------------
	$scope.messages = Message.all();
	$scope.tasks = Task.all();
	$scope.attributes = Attribute.all();
	$scope.requestTypes = RequestType.all();
	$scope.newAttributes = []; // Массив для новых типов атрибутов при создании нового типа сигнала
	$scope.newTasks = [];      // Массив для новых типов поручений при создании нового типа сигнала
	$scope.editing = false;

	$scope.inputs = {
		name: false,
		description: false
	};

	$scope.inputsErrors = {
		name: ""
	};

	$scope.editingInputs = {
		name: false,
		description: false
	};

	$scope.editingErrors = {
		name: ""
	};

	// Фильтры для элементов, которые связаны с типом сигнала и не связаны соответственно
	$scope.existsFilter = {
		exists: true
	};

	$scope.notExistsFilter = {
		exists: false
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

	$scope.$watch('newDescription', function() {
		$scope.inputs.description = ($scope.newDescription != "" && $scope.newDescription != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
		$scope.editingErrors.name = "";
	});

	$scope.$watch('editingDescription', function() {
		$scope.editingInputs.description = ($scope.editingDescription != "" && $scope.editingDescription != null);
	});

//- Изменение моделей --------------------------------------
	$scope.resetNewMessage = function() {
		$scope.newName = "";
		$scope.newDescription = "";
	};

	$scope.createMessage = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.description = $scope.newDescription;
		attr.new_tasks = $scope.newTasks;
		attr.new_attributes = $scope.newAttributes;

		attr.tasks = [];
		angular.forEach($scope.tasks, function(task){
			if(task.checked) {
				attr.tasks.push(task.id);
				task.checked = false;
			}
		});

		attr.attributes = [];
		angular.forEach($scope.attributes, function(attribute){
			if(attribute.checked) {
				attr.attributes.push(attribute.id);
				attribute.checked = false;
			}
		});

		attr.requestTypes = [];
		angular.forEach($scope.requestTypes, function(requestType){
			if(requestType.checked) {
				attr.requestTypes.push(requestType.id);
				requestType.checked = false;
			}
		});

		var newMessage = Message.create(attr);

		newMessage.$promise.then(function(){
			// Если удалось создать тип сигнала
			$scope.messages.unshift(newMessage);
			$scope.resetNewMessage();
			$('#newMessage').modal('hide');
		}, function(d) {
			// Если не удалось, то показываем ошибки
			showErrors(d.data, $scope.inputsErrors);
		});

		
	};

	$scope.updateMessage = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.description = $scope.editingDescription;

		// Если были изменения типов поручений, говорим серверу сменить их
		if($scope.messageTaskChanged) {
			attr.tasks = [];
			angular.forEach($scope.messageTasks, function(messageTask) {
				if(messageTask.exists) {
					attr.tasks.push(messageTask.id);
				}
			});
			attr.messageTasksChanged = true;
		}

		// Если были изменения типов атрибутов, говорим серверу сменить их
		if($scope.messageAttributeChanged) {
			attr.attributes = [];
			angular.forEach($scope.messageAttributes, function(messageAttribute) {
				if(messageAttribute.exists) {
					attr.attributes.push(messageAttribute.id);
				}
			});
			attr.messageAttributeChanged = true;
		}

		// Если были изменения типов заявок, говорим серверу сменить их
		if($scope.messageRequestTypesChanged) {
			attr.requestTypes = [];
			angular.forEach($scope.messageRequestTypes, function(messageRequestType) {
				if(messageRequestType.exists) {
					attr.requestTypes.push(messageRequestType.id);
				}
			});
			attr.messageRequestTypesChanged = true;
		}

		var updatedMessage = Message.update($scope.editingId, attr);

		updatedMessage.$promise.then(function() {
			// Если удалось обновить тип сигнала
			$scope.messages[$scope.editingIdx] = updatedMessage;
			$scope.closeEditing();
		}, function(d) {
			// Если не удалось обновить тип сигнала
			showErrors(d.data, $scope.editingErrors);
		});
	};

	$scope.clickMessage = function(idx) {
		$scope.editingId = $scope.messages[idx].id;
		$scope.editingIdx = idx;
		$scope.editingName = $scope.messages[idx].name;
		$scope.editingDescription = $scope.messages[idx].description;

		// Отмечаем поручения, которые связаны с сигналом
		$scope.messageTasks = [];
		var messageTasksIndexes = [];
		angular.forEach($scope.messages[idx].tasks, function(messageTask) {
			messageTasksIndexes.push(messageTask.id);
		});
		angular.copy($scope.tasks, $scope.messageTasks);
		angular.forEach($scope.messageTasks, function(messageTask) {
			if(messageTasksIndexes.indexOf(messageTask.id) != -1) {
				messageTask.exists = true;
			}
			else {
				messageTask.exists = false;
			}
		});

		// Отмечаем атрибуты, которые связаны с сигналом
		$scope.messageAttributes = [];
		var messageAttributesIndexes = [];
		angular.forEach($scope.messages[idx].attributes, function(messageAttribute) {
			messageAttributesIndexes.push(messageAttribute.id);
		});
		angular.copy($scope.attributes, $scope.messageAttributes);
		angular.forEach($scope.messageAttributes, function(messageAttribute) {
			if(messageAttributesIndexes.indexOf(messageAttribute.id) != -1) {
				messageAttribute.exists = true;
			}
			else {
				messageAttribute.exists = false;
			}
		});

		// Отмечаем типы заявок, которые связаны с сигналом
		$scope.messageRequestTypes = [];
		var messageRequestTypesIndexes = [];
		angular.forEach($scope.messages[idx].request_types, function(messageRequestType) {
			messageRequestTypesIndexes.push(messageRequestType.id);
		});
		angular.copy($scope.requestTypes, $scope.messageRequestTypes);
		angular.forEach($scope.messageRequestTypes, function(messageRequestType) {
			if(messageRequestTypesIndexes.indexOf(messageRequestType.id) != -1) {
				messageRequestType.exists = true;
			}
			else {
				messageRequestType.exists = false;
			}
		});

		$scope.editing = true;
	};

	$scope.createTask = function($event) {
		if($scope.newTask != "" && $scope.newTask != null) {
			$scope.newTasks.push($scope.newTask);
			$scope.showNewTask = false;
		}
		$scope.newTask = "";
	};

	$scope.createAttribute = function($event) {
		if($scope.newAttribute != "" && $scope.newAttribute != null) {
			$scope.newAttributes.push($scope.newAttribute);
			$scope.showNewAttribute = false;
		}
		$scope.newAttribute = "";
	};

	$scope.deleteNewTask = function(idx) {
		$scope.newTasks.splice(idx, 1);
	};

	$scope.deleteNewAttribute = function(idx) {
		$scope.newAttributes.splice(idx, 1);
	};

	$scope.deleteMessage = function(id, idx) {
		$scope.messages.splice(idx, 1);
		return Message.delete(id);
	};

	$scope.deleteMessages = function() {
		var oldMessages = $scope.messages;
		$scope.messages = [];
		angular.forEach(oldMessages, function(message) {
			if (!message.checked) { 
				$scope.messages.push(message);
			}
			else {
				Message.delete(message.id);
			}
		});
		return true;
	};

	$scope.check = function(item) {
		item.checked = !item.checked;
	};

	$scope.changeMessageTask = function(item) {
		item.exists = !item.exists;
		$scope.messageTaskChanged = true;
	};

	$scope.changeMessageAttribute = function(item) {
		item.exists = !item.exists;
		$scope.messageAttributeChanged = true;
	};

	$scope.changeMessageRequestType = function(item) {
		item.exists = !item.exists;
		$scope.messageRequestTypesChanged = true;
	};

	$scope.closeEditing = function() {
		$scope.editingName = "";
		$scope.editingDescription = "";

		$scope.editingErrors.name = "";

		$scope.editing = false;
		$scope.messageTaskChanged = false;
		$scope.messageAttributeChanged = false;
	};
}

newVending.controller("MessagesCtrl",['$scope', '$timeout', 'Message', 'Task', 'Attribute', 'RequestType', MessagesCtrl]);