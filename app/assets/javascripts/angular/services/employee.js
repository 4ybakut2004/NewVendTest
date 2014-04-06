newVending.factory('Employee', ['$resource', function($resource) {
  function Employee() {
    this.service = $resource('/employees/:employeeId.json', {employeeId: '@id'});
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

  return new Employee();
}]);