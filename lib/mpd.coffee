MpdView = require './mpd-view'
mpd	 = require 'mpd'
{cmd}   = mpd

module.exports =
	mpdView: null

	activate: (state) ->
		@mpdView = new MpdView(state.mpdViewState)
		@client = mpd.connect
			port: 6600
			host: 'localhost'

		@client.on 'ready', (name) ->
			console.log "ready"

		@client.on 'system', (name) ->
			console.log 'update', name

		@client.on 'system-player', =>
			@client.sendCommand (cmd 'status', []), (err, msg) ->
				throw err if err?
				console.log msg

	deactivate: ->
		@mpdView.destroy()

	serialize: ->
		mpdViewState: @mpdView.serialize()
