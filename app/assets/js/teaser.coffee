window.onYouTubePlayerReady = (playerId) ->
  window.ytplayer = document.getElementById('gladys')
  window.ytplayer.addEventListener('onStateChange', 'onYouTubePlayerStateChange')

window.onYouTubePlayerStateChange = (newState) ->
  if newState == 2
    $('#end').show()

Gladys = {

  repositionVideo: ->
    ww = $(window).width()
    wh = $(window).height()
    videoRatio = 16/9
    windowRatio = ww/wh
    
    if (windowRatio < videoRatio)
      ih = Math.floor(ww/videoRatio)
      diff = wh - ih
      $('#video').width(ww).height(ih).css {
        marginTop: diff/2
        marginLeft: 0
        display: 'block'
      }
    else
      iw = Math.floor(wh*videoRatio)
      diff = ww - iw
      $('#video').width(iw).height(wh).css {
        marginTop: 0
        marginLeft: diff/2
        display: 'block'
      }

  replayVideo: (e) ->
    e.preventDefault()
    $('#end').hide()
    window.ytplayer.playVideo()

}

$ ->
  if swfobject.getFlashPlayerVersion().major == 0
    window.location = 'http://www.youtube.com/watch?v=v4YJgrMYAOs'

  params = { allowScriptAccess: 'always', wmode: 'transparent' }
  atts = { id: 'gladys' }
  swfobject.embedSWF 'http://www.youtube.com/v/v4YJgrMYAOs?version=3&autoplay=1&controls=0&showinfo=0&rel=0&enablejsapi=1&playerapiid=gladys', 'player', '100%', '100%', '8', null, null, params, atts

  Gladys.repositionVideo()
  $(window).resize Gladys.repositionVideo

  $('#replay').click Gladys.replayVideo