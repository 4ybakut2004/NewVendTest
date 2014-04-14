newVending.factory('Machine', ['$resource', function($resource) {
  function Machine() {
    this.service = $resource('/machines/:machineId.json', 
                             {machineId: '@id'});
  }

  Machine.prototype.all = function() {
    return this.service.query();
  };

  return new Machine();
}]);