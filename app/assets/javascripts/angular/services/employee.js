newVending.factory('Employee', ['$resource', function($resource) {
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

  return new Employee();
}]);