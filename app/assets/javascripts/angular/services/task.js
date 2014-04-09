newVending.factory('Task', ['$resource', function($resource) {
  function Task() {
    this.service = $resource('/tasks/:taskId.json', 
                             {taskId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Task.prototype.all = function() {
    return this.service.query();
  };

  Task.prototype.get = function(id) {
    this.service.get({taskId: id});
  };

  Task.prototype.delete = function(id) {
    this.service.remove({taskId: id});
  };

  Task.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  Task.prototype.update = function(id, attr) {
    return this.service.update({taskId: id}, attr);
  };

  return new Task();
}]);