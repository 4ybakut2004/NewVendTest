/***********************************************************
 ** attributes_ctrl.js *************************************
 ***********************************************************
 * Контроллер страницы Типы Атрибутов.
 **********************************************************/

function AttributesCtrl($scope, $timeout, Attribute, Message) {
//- Инициализация моделей ----------------------------------
	$scope.attributes = Attribute.all(); // Получаем все типы атрибутов
	$scope.messages = Message.all();     // Получаем все типы сигналов
	$scope.newAttributeType = "number";  // Тип создаваемого атрибута по умолчанию
	// TODO получать возможные типы атрибутов от сервера

	$scope.editing = false;

	$scope.inputs = {
		name: false,
		attributeType: false
	};

	$scope.inputsErrors = {
		name: "",
		attribute_type: ""
	};

	$scope.editingInputs = {
		name: false,
		attributeType: false
	};

	$scope.editingErrors = {
		name: "",
		attribute_type: ""
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

	$scope.$watch('newAttributeType', function() {
		$scope.inputs.attributeType = ($scope.newAttributeType != "" && $scope.newAttributeType != null);
		$scope.inputsErrors.attribute_type = "";
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
		$scope.editingErrors.name = "";
	});

	$scope.$watch('editingAttributeType', function() {
		$scope.editingInputs.attributeType = ($scope.editingAttributeType != "" && $scope.editingAttributeType != null);
		$scope.editingErrors.attribute_type = "";
	});

//- Изменение моделей --------------------------------------
	$scope.createAttribute = function() {
		var attr = {};
		attr.name = $scope.newName;
		attr.attribute_type = $scope.newAttributeType;
		attr.messages = [];

		// Заполняем массив типов сигналов, которые нужно связать с созданным типом атрибута
		angular.forEach($scope.messages, function(message){
			if(message.checked) {
				attr.messages.push(message.id);
			}
		});

		var newAttribute = Attribute.create(attr);
		newAttribute.$promise.then(function() {
			// Если удалось создать тип атрибута
			$scope.attributes.unshift(newAttribute);
			$scope.newName = "";
			$scope.newAttributeType = "number";
			$('#newAttribute').modal('hide');
		}, function(d) {
			// Если во время создания были ошибки
			showErrors(d.data, $scope.inputsErrors);
		});
	};

	$scope.updateAttribute = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.attribute_type = $scope.editingAttributeType;
		var updatedAttribute = Attribute.update($scope.editingId, attr);

		updatedAttribute.$promise.then(function() {
			// Если удалось обновить запись
			$scope.attributes[$scope.editingIdx] = updatedAttribute;
			$scope.closeEditing();
		}, function(d) {
			// Если не удалось обновить запись
			showErrors(d.data, $scope.editingErrors);
		});
		
	};

	$scope.deleteAttribute = function(id, idx) {
		$scope.attributes.splice(idx, 1);
		return Attribute.delete(id);
	};

	$scope.deleteAttributes = function() {
		var oldAttributes = $scope.attributes;
		$scope.attributes = [];
		angular.forEach(oldAttributes, function(attribute) {
			if (!attribute.checked) { 
				$scope.attributes.push(attribute);
			}
			else {
				Attribute.delete(attribute.id);
			}
		});
		return true;
	};

	$scope.clickAttribute = function(idx) {
		$scope.editingId = $scope.attributes[idx].id;
		$scope.editingIdx = idx;
		$scope.editingName = $scope.attributes[idx].name;
		$scope.editingAttributeType = $scope.attributes[idx].attribute_type;

		$scope.attributeMessages = $scope.attributes[idx].messages;

		$scope.editing = true;
	};

	$scope.check = function(item) {
		item.checked = !item.checked;
	};

	$scope.closeEditing = function() {
		$scope.editing = false;

		$scope.editingName = "";
		$scope.editingAttributeType = "";

		$scope.editingErrors.name = "";
		$scope.editingErrors.attribute_type = "";
	};
}

newVending.controller("AttributesCtrl",['$scope', '$timeout', 'Attribute', 'Message', AttributesCtrl]);