doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title 'Wahlque'
    link rel: 'stylesheet', href: '/styles/style.css'
    script 'data-main': 'main', src: '/javascripts/require.js'
    script src: '/main.js'
  body ->
    div id: 'main', ->
        h1 'Wahlque World'
        canvas id: 'world-global'
        canvas id: 'world-orbit'
        button type: 'button', id: 'world-btn', -> 'Connect!'
        div id: 'world-msg'


