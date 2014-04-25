/***********************************************************
 ** attributes_ctrl.js *************************************
 ***********************************************************
 * Контроллер страницы Типы Атрибутов.
 **********************************************************/

function AttributesCtrl($scope, $timeout, Attribute, Message) {
//- Инициализация моделей ----------------------------------
	$scope.attributes = Attribute.all();
	$scope.messages = Message.all();
	$scope.newAttributeType = "number";

	$scope.editing = false;

	$scope.inputs = {
		name: false,
		attributeType: false
	};

	$scope.editingInputs = {
		name: false,
		attributeType: false
	};

//- Мониторинг изменения моделей ---------------------------
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

	$scope.$watch('newAttributeType', function() {
		$scope.inputs.attributeType = ($scope.newAttributeType != "" && $scope.newAttributeType != null);
	});

	$scope.$watch('editingName', function() {
		$scope.editingInputs.name = ($scope.editingName != "" && $scope.editingName != null);
	});

	$scope.$watch('editingAttributeType', function() {
		$scope.editingInputs.attributeType = ($scope.editingAttributeType != "" && $scope.editingAttributeType != null);
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

		$scope.attributes.unshift(newAttribute);
		$scope.newName = "";
		$scope.newAttributeType = "";
		$('#newAttribute').modal('hide');
	};

	$scope.updateAttribute = function() {
		var attr = {};
		attr.name = $scope.editingName;
		attr.attribute_type = $scope.editingAttributeType;
		var updatedAttribute = Attribute.update($scope.editingId, attr);
		$scope.attributes[$scope.editingIdx] = updatedAttribute;

		$scope.editingName = "";
		$scope.editingAttributeType = "";
		$scope.editing = false;
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
}

newVending.controller("AttributesCtrl",['$scope', '$timeout', 'Attribute', 'Message', AttributesCtrl]);