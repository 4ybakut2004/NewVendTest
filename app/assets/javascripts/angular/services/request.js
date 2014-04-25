/***********************************************************
 ** request.js *********************************************
 ***********************************************************
 * Сервис для работы с моделью Request.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('Request', ['$resource', function($resource) {
  function Request() {
    this.service = $resource('/requests/:requestId.json', 
                             {requestId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Request.prototype.all = function(attr) {
    return this.service.query(attr);
  };

  Request.prototype.get = function(id) {
    return this.service.get({requestId: id});
  };

  Request.prototype.delete = function(id) {
    this.service.remove({requestId: id});
  };

  Request.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  Request.prototype.update = function(id, attr) {
    return this.service.update({requestId: id}, attr);
  };

  return new Request();
}]);