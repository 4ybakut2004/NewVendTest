/***********************************************************
 ** request_task.js ****************************************
 ***********************************************************
 * Сервис для работы с моделью RequestTask.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('RequestTask', ['$resource', '$http', function($resource, $http) {
  function RequestTask() {
    this.service = $resource('/request_tasks/:requestTaskId.json', 
                             {requestTaskId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  RequestTask.prototype.all = function(attr) {
    return this.service.query(attr);
  };

  RequestTask.prototype.get = function(id) {
    return this.service.get({requestTaskId: id});
  };

  RequestTask.prototype.delete = function(id) {
    this.service.remove({requestTaskId: id});
  };

  RequestTask.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  RequestTask.prototype.update = function(id, attr) {
    return this.service.update({requestTaskId: id}, attr);
  };

  // В данном методе происходит прием ответа от сервера,
  // который содержит число.
  // Данный метод достает это число и возвращает его в качестве ответа
  function getSimpleResponse(url, params) {
    var promise = $http.get(url, {params: params}).then(function (response) {
      return response.data;
    });

    return promise;
  }

  RequestTask.prototype.to_assign_count = function() {
      return getSimpleResponse('/to_assign_count.json');
  };

  RequestTask.prototype.to_execute_count = function() {
      return getSimpleResponse('/to_execute_count.json');
  };

  RequestTask.prototype.to_audit_count = function() {
      return getSimpleResponse('/to_audit_count.json');
  };

  RequestTask.prototype.to_read_assign_count = function() {
      return getSimpleResponse('/to_read_assign_count.json');
  };

  RequestTask.prototype.to_read_execute_count = function() {
      return getSimpleResponse('/to_read_execute_count.json');
  };

  RequestTask.prototype.read = function(id, employee_id) {
      return getSimpleResponse('/read_request_task.json', {id: id, employee_id: employee_id});
  };

  return new RequestTask();
}]);