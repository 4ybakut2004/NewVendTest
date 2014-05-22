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
		$scope.editingSettingsId = allSettings[0].id;
	});

	$scope.error = false;
	$scope.success = false;

//- Изменение моделей --------------------------------------
	$scope.updateSettings = function() {
		var attr = {};
		attr.read_confirm_time = $scope.editingReadConfirmTime;

		var settings = Settings.update($scope.editingSettingsId, attr);

		settings.$promise.then(function() {
			$scope.editingReadConfirmTime = settings.read_confirm_time;
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