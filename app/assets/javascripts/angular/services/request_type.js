/***********************************************************
 ** request_type.js ****************************************
 ***********************************************************
 * Сервис для работы с моделью RequestType.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('RequestType', ['$resource', '$http', function($resource, $http) {
  function RequestType() {
    this.service = $resource('/request_types/:requestTypeId.json', 
                             {requestTypeId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  RequestType.prototype.all = function(attr) {
    return this.service.query(attr);
  };

  RequestType.prototype.get = function(id) {
    return this.service.get({requestTypeId: id});
  };

  RequestType.prototype.delete = function(id) {
    this.service.remove({requestTypeId: id});
  };

  RequestType.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  RequestType.prototype.update = function(id, attr) {
    return this.service.update({requestTypeId: id}, attr);
  };

  return new RequestType();
}]);