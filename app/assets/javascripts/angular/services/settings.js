/***********************************************************
 ** settings.js ********************************************
 ***********************************************************
 * Сервис для работы с моделью NewVendSettings.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('Settings', ['$resource', function($resource) {
  function Settings() {
    this.service = $resource('/new_vend_settings/:newVendSettingsId.json', 
                             {newVendSettingsId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Settings.prototype.all = function() {
    return this.service.query();
  };

  Settings.prototype.get = function(id) {
    return this.service.get({newVendSettingsId: id});
  };

  Settings.prototype.update = function(id, attr) {
    return this.service.update({newVendSettingsId: id}, attr);
  };

  return new Settings();
}]);