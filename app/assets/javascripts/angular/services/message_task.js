newVending.factory('MessageTask', ['$resource', function($resource) {
  function MessageTask() {
    this.service = $resource('/message_tasks/:messageTaskId.json', 
                             {messageTaskId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  MessageTask.prototype.all = function() {
    return this.service.query();
  };

  MessageTask.prototype.get = function(id) {
    this.service.get({messageTaskId: id});
  };

  MessageTask.prototype.delete = function(id) {
    this.service.remove({messageTaskId: id});
  };

  MessageTask.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  MessageTask.prototype.update = function(id, attr) {
    return this.service.update({messageTaskId: id}, attr);
  };

  return new MessageTask();
}]);