newVending.factory('Message', ['$resource', function($resource) {
  function Message() {
    this.service = $resource('/messages/:messageId.json', 
                             {messageId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Message.prototype.all = function() {
    return this.service.query();
  };

  Message.prototype.get = function(id) {
    this.service.get({messageId: id});
  };

  Message.prototype.delete = function(id) {
    this.service.remove({messageId: id});
  };

  Message.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  Message.prototype.update = function(id, attr) {
    return this.service.update({messageId: id}, attr);
  };

  return new Message();
}]);