module.exports = class MpdView
	constructor: (serializeState) ->
		@element = document.createElement('div')
		@element.classList.add('mpd')

		@title = document.createElement('span')
		@title.textContent = "The Mpd package is Alive! It's ALIVE!"
		@title.classList.add('title')
		@element.appendChild(@title)

		# Register command that toggles this view
		atom.commands.add 'atom-workspace', 'mpd:toggle': => @toggle()

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
			atom.workspaceView.statusBar.appendLeft @element
