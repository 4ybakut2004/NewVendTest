/***********************************************************
 ** machine.js *********************************************
 ***********************************************************
 * Сервис для работы с моделью Machine.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('Machine', ['$resource', function($resource) {
  function Machine() {
    this.service = $resource('/machines/:machineId.json', 
                             {machineId: '@id'});
  }

  Machine.prototype.all = function() {
    return this.service.query();
  };

  return new Machine();
}]);