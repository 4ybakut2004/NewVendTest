newVending.factory('Attribute', ['$resource', function($resource) {
  function Attribute() {
    this.service = $resource('/attributes/:attributeId.json', 
                             {attributeId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  Attribute.prototype.all = function() {
    return this.service.query();
  };

  Attribute.prototype.get = function(id) {
    this.service.get({attributeId: id});
  };

  Attribute.prototype.delete = function(id) {
    this.service.remove({attributeId: id});
  };

  Attribute.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  Attribute.prototype.update = function(id, attr) {
    return this.service.update({attributeId: id}, attr);
  };

  return new Attribute();
}]);