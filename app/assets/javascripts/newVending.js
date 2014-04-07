var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

/*newVending.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/employees', {
        controller: 'EmployeesCtrl',
        templateUrl: 'employees/'
      }).
      otherwise({
      	controller: 'ApplicationCtrl',
        redirectTo: '/'
      });
  }]);*/

$(document).on('page:load', function() {
  angular.bootstrap(document.getElementById('newVending'), ['newVending']);
});

newVending.run(function($compile, $rootScope, $document) {
  return $document.on('page:load', function() {
    var body, compiled;
    body = angular.element('body');
    compiled = $compile(body.html())($rootScope);
    return body.html(compiled);
  });
});