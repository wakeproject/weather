/*jslint regexp: true, nomen: true */
/*global importScripts, require */

importScripts('/javascripts/require.js');

require({
    paths: {
        underscore: '/javascripts/underscore',
        cs: '/javascripts/cs',
        'coffee-script': '/javascripts/coffee-script',
        baseUrl: '/coffeescripts/'
    },
    shim: {
        underscore: {
            exports: '_'
        }
    }
}, ['cs!/coffeescripts/generator']);
