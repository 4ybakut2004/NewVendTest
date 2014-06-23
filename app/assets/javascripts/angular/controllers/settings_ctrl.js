/***********************************************************
 ** settings_ctrl.js ***************************************
 ***********************************************************
 * Контроллер страницы Настройки.
 **********************************************************/

function SettingsCtrl($scope, Settings) {
//- Инициализация моделей ----------------------------------
	allSettings = Settings.all();

	allSettings.$promise.then(function() {
		$scope.editingReadConfirmTime = allSettings[0].read_confirm_time;
		$scope.editingHostName = allSettings[0].host_name;
		$scope.editingPhoneHostName = allSettings[0].phone_host_name;
		$scope.editingSettingsId = allSettings[0].id;
	});

	$scope.error = false;
	$scope.success = false;

//- Изменение моделей --------------------------------------
	$scope.updateSettings = function() {
		var attr = {};
		attr.read_confirm_time = $scope.editingReadConfirmTime;
		attr.host_name = $scope.editingHostName;
		attr.phone_host_name = $scope.editingPhoneHostName;

		var settings = Settings.update($scope.editingSettingsId, attr);

		settings.$promise.then(function() {
			$scope.editingReadConfirmTime = settings.read_confirm_time;
			$scope.editingHostName = settings.host_name;
			$scope.editingPhoneHostName = settings.phone_host_name;
			$scope.editingSettingsId = settings.id;
			$scope.success = true;
			$scope.error = false;
		}, function() {
			$scope.error = true;
			$scope.success = false;
		});
	};
}

newVending.controller("SettingsCtrl",['$scope', 'Settings', SettingsCtrl]);