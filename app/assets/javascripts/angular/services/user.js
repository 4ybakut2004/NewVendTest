/***********************************************************
 ** user.js *******************************************
 ***********************************************************
 * Сервис для работы с моделью User.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Подробное описание находтся в файле attribute.js
 **********************************************************/

newVending.factory('User', ['$resource', function($resource) {
  function User() {
    this.service = $resource('/users/:userId.json', 
                             {userId: '@id'}, 
                             {update: { method: 'PUT' }});
  }

  User.prototype.all = function() {
    return this.service.query();
  };

  User.prototype.get = function(id) {
    this.service.get({userId: id});
  };

  User.prototype.delete = function(id) {
    this.service.remove({userId: id});
  };

  User.prototype.create = function(attr) {
    return this.service.save(attr);
  };

  User.prototype.update = function(id, attr) {
    return this.service.update({userId: id}, attr);
  };

  return new User();
}]);