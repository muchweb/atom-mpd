MpdView = require './mpd-view'

module.exports =
  mpdView: null

  activate: (state) ->
    @mpdView = new MpdView(state.mpdViewState)

  deactivate: ->
    @mpdView.destroy()

  serialize: ->
    mpdViewState: @mpdView.serialize()
