# Save scroll start position for calculations 
scrollStart = Header.maxY - 20

# Set up ScrollComponent
scroll = new ScrollComponent
	parent: Home
	scrollHorizontal: false
	size: Screen.size
	contentInset:
		top: scrollStart
	
scroll.sendToBack()
#Feed.parent = scroll.content

# Collapse header based on scroll position
scroll.onMove (event) ->
	range = [scrollStart, 50]
	Header.y = Utils.modulate(event.y, range, [40, 20], true)
	Header.height = Utils.modulate(event.y, range, [94, 60], true)
	HeaderNew.opacity = Utils.modulate(event.y, range, [1, 0], true)
	HeaderDay.fontSize = Utils.modulate(event.y, range, [36, 18], true)
	HeaderBackground.opacity = Utils.modulate(event.y, range, [0, 1], true)

# Hide Tab Bar
TabBar.states = 
	default:
		y: Screen.height - TabBar.height
	hide:
		y: 668
	animationOptions:
		time: .2
TabBar.stateSwitch "default"

scroll.onScroll ->
	if scroll.direction is "down"
		TabBar.animate "hide"
	
	if scroll.direction is "up"
		TabBar.animate "default"

# Variables
rows = 16
gutter = 12
rowHeight = 200

{Firebase} = require 'firebase'
menuDB = new Firebase
	projectID: "rndmenu"
	secret: "8aHinuTCIWkUQaRhztogGYq0BnzqrvIJDq6kKrkb" 

menuDB.get "/menu/20170805/2식당/점심", (menus) ->
	menusArray = _.toArray(menus)
	for _menu, index in menusArray
		menu.text = _menu.menu
		menu.opacity = 1.0
		restaurant.text = _menu.restaurant
		restaurant.opacity = 1.0
		sidemenu.text = _menu.description
		sidemenu.opacity = 1.0
		_item = item.copy()
		_item.y = index * (item.height + gutter) + 8
		_item.parent = scroll.content
		_item.centerX()
		
	###
	cell = new Layer
		x: Align.center
		width:  Screen.width * 0.9
		height: rowHeight
		y: index * (rowHeight + gutter) + 8
		parent: scroll.content
		backgroundColor: "#00AAFF"
		hueRotate: index * 10
		borderRadius: 5
	###
