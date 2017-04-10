/*jshint node:true*/
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
      ace: {
          themes: ['chrome'],
          modes: ['pgsql', 'mysql', 'sql'],
          workers: ['pgsql', 'mysql', 'sql'],
          basePath: "/ace/"
            
      }
    // Add options here
  });
  app.import('./bower_components/lodash/dist/lodash.min.js')
  app.import('./bower_components/ace-builds/src-noconflict/theme-chrome.js')
  app.import('./bower_components/ace-builds/src-noconflict/mode-sql.js')
  app.import('./bower_components/ace-builds/src-noconflict/ext-beautify.js')
  app.import('./bower_components/ace-builds/src-noconflict/ext-language_tools.js')
  app.import('./bower_components/ace-builds/src-noconflict/snippets/text.js')
  app.import('./bower_components/ace-builds/src-noconflict/snippets/sql.js')
  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.

  return app.toTree();
};
