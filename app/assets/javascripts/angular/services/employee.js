/***********************************************************
 ** employee.js ********************************************
 ***********************************************************
 * Сервис для работы с моделью Employee.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('Employee', ['$resource', '$http', function($resource, $http) {
  function Employee() {
    this.service = $resource('/employees/:employeeId.json', 
                             {employeeId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Employee.prototype.all = function() {
    return this.service.query();
  };

  Employee.prototype.delete = function(id) {
    this.service.remove({employeeId: id});
  };

  Employee.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  Employee.prototype.update = function(id, attr) {
    return this.service.update({employeeId: id}, attr);
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

  Employee.prototype.current_employee = function() {
      return getSimpleResponse('/current_employee.json');
  };

  return new Employee();
}]);