module.exports = {
  commands1 : [
    {name: 'chart', title: 'Chart', img: 'chart', bg: 'Peru', cmd: 'onlyone', args: ['/usr/bin/opencpn', '-l=error']},
    {name: 'dash', title: 'Dashboard', img: 'dashboard', bg: 'Olive', cmd: '/opt/kip-dash/kip-dash', args: []},
    {name: 'weather', title: 'Weather', img: 'weather', bg: 'RoyalBlue', cmd: 'onlyone', args: ['XyGrib']},
    {name: 'winds', title: 'Winds', img: 'race', bg: 'DarkSeaGreen', cmd: 'gtk-launch', args: ['windy']},

    {name: 'signalk', title: 'SignalK', img: 'dashboard', bg: 'ForestGreen', cmd: 'gtk-launch', args: ['signalk']},
    {name: 'tasks', title: 'Tasks', img: 'tasks', bg: 'Olive',  cmd: 'onlyone', args: ['lxtask']},
    {name: 'commands', title: 'Commands', img: 'travel', bg: 'Tan',  cmd: '/usr/local/bin/bbn-commands', args: []},
    {name: 'web-weather', title: 'Forecast', img: 'weather', bg: 'SeaGreen',  cmd: 'onlyone', args: ['gnome-weather']},
    {name: 't-storms', title: 'T-Storms', img: 'weather', bg: 'Tan', cmd: 'gtk-launch', args: ['lightningmaps']},

    {name: 'power', title: 'Power', img: 'solar', bg: 'Tan', cmd: 'gtk-launch', args: ['victron']},
    {name: 'terminal', title: 'Terminal', img: 'terminal', bg: 'RoyalBlue',  cmd: 'onlyone', args: ['lxterminal']},
    {name: 'www', title: 'WWW', img: 'internet', bg: 'SteelBlue', cmd: 'onlyone', args: ['gnome-www-browser']},
    {name: 'files', title: 'Files', img: 'folder', bg: 'ForestGreen', cmd: 'onlyone', args: ['thunar']},
  ],

  commands2 : [
    {name: 'guide', title: 'Guide', img: 'ship', bg: 'RoyalBlue',  cmd: 'gtk-launch', args: ['os-guide']},
  ],

  commands3 : [
  ],

  sites : [
  ]
}