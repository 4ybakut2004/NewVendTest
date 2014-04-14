newVending.factory('RequestTask', ['$resource', function($resource) {
  function RequestTask() {
    this.service = $resource('/request_tasks/:requestTaskId.json', 
                             {requestTaskId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  RequestTask.prototype.all = function() {
    return this.service.query();
  };

  RequestTask.prototype.get = function(id) {
    this.service.get({requestTaskId: id});
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