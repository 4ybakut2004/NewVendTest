var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

/*newVending.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/employees', {
        controller: 'EmployeesCtrl'
      }).
      otherwise({
      	controller: 'ApplicationCtrl',
        redirectTo: '/'
      });
  }]);*/

/*newVending.run(function($compile, $rootScope, $document) {
  return $document.on('page:load', function() {
    var body, compiled;
    body = angular.element('body');
    compiled = $compile(body.html())($rootScope);
    return body.html(compiled);
  });
});*/