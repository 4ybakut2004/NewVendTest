newVending.factory('RequestTask', ['$resource', function($resource) {
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

  return new RequestTask();
}]);