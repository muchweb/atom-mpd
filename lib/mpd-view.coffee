module.exports = class MpdView
	constructor: (serializeState) ->
		@element = document.createElement 'div'
		@element.classList.add 'mpd'

		@title = document.createElement 'marquee'
		@title.textContent = '...'
		@title.classList.add 'title'
		@element.appendChild(@title)

		@status = document.createElement 'span'
		@status.textContent = '...'
		@status.classList.add 'status'
		@element.appendChild(@status)

		@volume = document.createElement 'span'
		@volume.textContent = '...'
		@volume.classList.add 'volume'
		@element.appendChild(@volume)

		# Register command that toggles this view
		atom.commands.add 'atom-workspace',
			'mpd:toggle': => @toggle()

		@toggle()

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
