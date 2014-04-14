newVending.factory('Request', ['$resource', function($resource) {
  function Request() {
    this.service = $resource('/requests/:requestId.json', 
                             {requestId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Request.prototype.all = function() {
    return this.service.query();
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