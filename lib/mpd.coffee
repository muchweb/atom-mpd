MpdView = require './mpd-view'
mpd	    = require 'mpd'
{cmd}   = mpd

module.exports =
	mpdView: null

	status:    ''
	songid:    0
	songtitle: ''
	volume:    0

	requestStatus: () ->
		@client.sendCommand (cmd 'status', []), (err, msg) =>
			throw err if err?

			items = msg.split '\n'
			for item in items
				broken = item.split ':'
				if broken[0]?
					switch broken[0]
						when 'songid'
							@songid = parseInt broken[1], 10
						when 'state'
							switch broken[1].trim()
								when 'play'
									@status = '▶'
								when 'stop'
									@status = '■'
								when 'pause'
									@status = '▐▐'
								else
									@status = '?'
						when 'volume'
							@volume = parseInt broken[1], 10

			@client.sendCommand (cmd 'playlist', []), (err, msg2) =>
				throw err if err?

				items = msg2
					.split '\n'
					.filter (item) =>
						items = item.split ':'
						return items[0]? and "#{items[0]}" is "#{@songid - 1}"
					.map (item) ->
						items = item.split ':'
						return if items[2]? then items[2] else '?'

				@songtitle = items.pop() if items.length >= 1
				@statusChanged()

	statusChanged: () ->
		@mpdView.status.textContent = "#{@status}"
		@mpdView.title.textContent  = "#{@songtitle}"
		@mpdView.volume.textContent = "#{@volume}"

	activate: (state) ->
		@mpdView = new MpdView(state.mpdViewState)
		@client = mpd.connect
			port: 6600
			host: 'localhost'

		@client.on 'ready', (name) => @requestStatus()
		@client.on 'system', (name) => @requestStatus()
		#@client.on 'system', (name) => @mpdView.title.textContent = "update #{name}"
		#@client.on 'system-player', => @requestStatus()
		#@client.on 'system-mixer', => @requestStatus()

	deactivate: ->
		@mpdView.destroy()

	serialize: ->
		mpdViewState: @mpdView.serialize()
