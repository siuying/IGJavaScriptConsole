(function() {
  if (!this.require) {
    var modules = {}, cache = {};

    var require = function(name, root) {
      var path = expand(root, name), indexPath = expand(path, './index'), module, fn;
      module   = cache[path] || cache[indexPath];
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = indexPath]) {
        module = {id: path, exports: {}};
        cache[path] = module.exports;
        fn(module.exports, function(name) {
          return require(name, dirname(path));
        }, module);
        return cache[path] = module.exports;
      } else {
        throw 'module ' + name + ' not found';
      }
    };

    var expand = function(root, name) {
      var results = [], parts, part;
      // If path is relative
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    };

    var dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };

    this.require = function(name) {
      return require(name, '');
    };

    this.require.define = function(bundle) {
      for (var key in bundle) {
        modules[key] = bundle[key];
      }
    };

    this.require.modules = modules;
    this.require.cache   = cache;
  }

  return this.require;
}).call(this);this.require.define({"application":function(exports, require, module){(function() {
  var CoffeeScriptProcessor, ConsoleController, JavaScriptProcessor, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  JavaScriptProcessor = (function() {
    function JavaScriptProcessor() {}

    JavaScriptProcessor.prototype.evaulate = function(source, success, failure) {
      var e, result;
      try {
        result = eval(source);
        return success(result);
      } catch (_error) {
        e = _error;
        return failure(e);
      }
    };

    return JavaScriptProcessor;

  })();

  CoffeeScriptProcessor = (function(_super) {
    __extends(CoffeeScriptProcessor, _super);

    function CoffeeScriptProcessor() {
      _ref = CoffeeScriptProcessor.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    CoffeeScriptProcessor.prototype.evaulate = function(source, success, failure) {
      var e, result;
      try {
        result = CoffeeScript["eval"](source);
        return success(result);
      } catch (_error) {
        e = _error;
        return failure(e);
      }
    };

    return CoffeeScriptProcessor;

  })(JavaScriptProcessor);

  ConsoleController = (function() {
    function ConsoleController() {
      this.jsConsole = $('#console').jqconsole("Hi!\n", '> ');
      this.compiler = new CoffeeScriptProcessor;
    }

    ConsoleController.prototype.prompt = function() {
      var _this = this;
      return this.jsConsole.Prompt(true, function(input) {
        var failure, success;
        success = function(result) {
          _this.jsConsole.Write(result + '\n', 'jqconsole-output');
          return _this.prompt();
        };
        failure = function(error) {
          _this.jsConsole.Write(error + '\n', 'jqconsole-error');
          return _this.prompt();
        };
        return _this.compiler.evaulate(input, success, failure);
      });
    };

    return ConsoleController;

  })();

  module.exports = function() {
    var controller;
    controller = new ConsoleController;
    return controller.prompt();
  };

}).call(this);
;}});
