/*jslint regexp: true, nomen: true */
/*global require */

require({
    paths: {
        cs: '/javascripts/cs',
        underscore: '/javascripts/underscore',
        domReady: '/javascripts/domReady',
        qwery: '/javascripts/qwery',
        bonzo: '/javascripts/bonzo',
        bean: '/javascripts/bean',
        'coffee-script': '/javascripts/coffee-script',
        socketio: '/socket.io/socket.io.js'
    },
    shim: {
        underscore: {
            exports: '_'
        },
        socketio: {
            exports: 'io'
        }
    }
}, ['cs!/coffeescripts/csmain']);
