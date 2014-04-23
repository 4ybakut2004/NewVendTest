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

  RequestTask.prototype.to_assign_count = function() {
      var promise = $http.get('/to_assign_count.json').then(function (response) {
        return response.data;
      });

      return promise;
  };

  RequestTask.prototype.to_execute_count = function() {
      var promise = $http.get('/to_execute_count.json').then(function (response) {
        return response.data;
      });

      return promise;
  };

  RequestTask.prototype.to_audit_count = function() {
      var promise = $http.get('/to_audit_count.json').then(function (response) {
        return response.data;
      });

      return promise;
  };

  return new RequestTask();
}]);