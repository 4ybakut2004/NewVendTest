/***********************************************************
 ** attribute.js *******************************************
 ***********************************************************
 * Сервис для работы с моделью Attribute.
 *
 * Позволяет взаимодействовать с RESTful источником данных
 * на стороне сервера.
 *
 * Функция конструктор создает ресурс, возвращаемый
 * фабрикой $resource:
 *
 *     $resource(url, [paramDefaults], [actions], options);
 *
 *     где
 *     url - Параметризированный шаблон ссылки, в котором 
 * параметры имеют префикс ':', например /user/:username.
 * При совершении действия, если задан пареметр :username,
 * действие совершится по адресу /user/valueOfUsername. 
 * Если параметр не задан, ссылка будет иметь вид /user/.
 *
 *     paramDefaults - Значения по умолчанию для параметров
 * ссылки url. Они могут быть перегружены в action методах.
 * Объявленные в шаблоне параметры становятся частью строки,
 * а остальные добавляются после знака '?'. Например, 
 * параметры {verb:'greet', salutation:'Hello'} для шаблона
 * /path/:verb создадут строку /path/greet?salutation=Hello.
 *
 *     actions - хэш с описанием собственных действий,
 * которые расширят стандартный список:
 *     { 'get':    {method:'GET'},
 *       'save':   {method:'POST'},
 *       'query':  {method:'GET', isArray:true},
 *       'remove': {method:'DELETE'},
 *       'delete': {method:'DELETE'} };
 *
 *
 **********************************************************/

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
    return this.service.get({attributeId: id});
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