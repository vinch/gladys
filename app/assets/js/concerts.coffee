window.App = {}

App.Concerts = {
  get: (callback) ->
    $.ajax {
      url: '/api/concerts'
      success: callback.success
      error: callback.error
    }
}

App.View = {
  render: (name, data) ->
    source = $('#' + name + '-template').html()
    template = Handlebars.compile source
    html = template data
    $('#' + name).append html
}

$ ->
  App.Concerts.get {
    success: (res) ->
      App.View.render 'concerts', {
        concerts: res
      }
    error: (err) ->
      console.log err
  }

  $(document).on 'click', 'tr', (e) ->
    url = $(e.currentTarget).find('td a').attr('href')
    window.open url

  $(document).on 'click', 'tr a', (e) ->
    e.preventDefault()