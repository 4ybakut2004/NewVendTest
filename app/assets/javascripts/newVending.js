var newVending = angular.module('newVending', ['ngResource', 'ngRoute']);

/*newVending.run(function($compile, $rootScope, $document) {
  return $document.on('page:load', function() {
    var body, compiled;
    body = angular.element('body');
    compiled = $compile(body.html())($rootScope);
    return body.html(compiled);
  });
});*/