module.exports = class MpdView
	emitter: null

	constructor: (serializeState) ->
		@element = document.createElement 'div'
		@element.classList.add 'mpd'

		@title = document.createElement 'marquee'
		@title.textContent = '...'
		@title.classList.add 'title'
		@element.appendChild @title

		@status = document.createElement 'button'
		@status.textContent = '...'
		@status.classList.add 'btn'
		@status.classList.add 'btn-sm'
		@status.classList.add 'status'
		@status.addEventListener 'click', => @emitter.emit 'trigger-status'
		@element.appendChild @status

		@volume = document.createElement 'button'
		@volume.textContent = '...'
		@volume.classList.add 'btn'
		@volume.classList.add 'btn-sm'
		@volume.classList.add 'volume'

		@volume.addEventListener 'mousewheel', (event) =>
			delta = Math.max -1, (Math.min 1, (event.wheelDelta || -event.detail))
			@emitter.emit 'volume-change', delta

		@volume.addEventListener 'click', =>
			@emitter.emit 'volume-mute'

		@element.appendChild @volume

		# Register command that toggles this view
		atom.commands.add 'atom-workspace',
			'mpd:toggle': => @toggle()

	# Returns an object that can be retrieved when package is activated
	serialize: ->

	# Tear down any state and detach
	destroy: ->
		@element.remove()

	# Toggle the visibility of this view
	toggle: ->
		if @element.parentElement?
			@element.remove()
		else
			atom.workspaceView.statusBar.appendRight @element
