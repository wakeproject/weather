doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title 'Wahlque'
    link rel: 'stylesheet', href: '/styles/style.css'
    script 'data-main': '/javascripts/main', src: '/javascripts/require.js'
  body ->
    div id: 'main', ->
        h1 'Wahlque World'
        canvas id: 'world-global'
        canvas id: 'world-orbit'
        button id: 'world-btn', type: 'button', -> 'Connect!'
        div id: 'world-msg'


