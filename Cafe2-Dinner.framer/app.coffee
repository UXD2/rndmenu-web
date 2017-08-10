Framer.Extras.Hints.disable()

# getDate
getDate = ->
	today = new Date
	mm = today.getMonth() + 1 
	dd = today.getDate()
	if dd < 10  
		dd = '0' + dd  
	if mm < 10  
		mm = '0' + mm  
	yyyy = today.getFullYear() 
	return ""+yyyy+mm+dd

# Variables
gutter = 16
scrollStart = Header.maxY + 8

{Firebase} = require 'firebase'
menuDB = new Firebase
	projectID: "rndmenu"
	secret: "8aHinuTCIWkUQaRhztogGYq0BnzqrvIJDq6kKrkb" 
	
scroll = ScrollComponent.wrap(contents)
scroll.scrollHorizontal = false
scroll.sendToBack()
scroll.contentInset =
	top: scrollStart
	right: 0
	bottom: 8
	left: 0

scroll.onMove (event) ->
	range = -80
	Header.height = Utils.modulate(event.y, [scrollStart, range], [80, 40], true)
	HeaderNew.opacity = Utils.modulate(event.y, [scrollStart, range], [1, 0], true)
	HeaderDay.y = Utils.modulate(event.y, [scrollStart, range], [32, 15], true)
	HeaderDay.fontSize = Utils.modulate(event.y, [scrollStart, range], [36, 14], true)
		
menuDB.get "/menu/"+getDate()+"/2식당/저녁", (menus) ->
	menusArray = _.toArray(menus)

	ovalsGroup.visible = false
	
	if menus is null
		noMenu.opacity = 1.0
	
	lastItemMaxY = 0	
	for menuData, index in menusArray
		item = _item_image.copySingle()	
		item.parent = scroll.content
		item.visible = true
		#item.y = index * (item.height + gutter) + 64
		item.y = lastItemMaxY + gutter
		lastItemMaxY = item.maxY
			
		menu = _menu.copySingle()
		menu.parent = item
		menu.text = menuData.menu
		menu.width = item.width * 0.8

		sidemenu = _sidemenu.copySingle()
		sidemenu.parent = item
		sidemenu.text = menuData.description
		sidemenu.maxY = Align.bottom(-8)
		sidemenu.width = item.width * 0.8
	
		restaurant = _restaurant.copySingle()
		restaurant.parent = item
		restaurant.text = menuData.restaurant
					
		menuDB.get "/foods/"+menuData.menu, (foods) ->
			if foods.image
				image = _image.copySingle()
				image.parent = item
				image.image = foods.image
				sidemenu.width = item.width * 0.5
				
		item.animate
			y: index * (item.height + gutter) + 8
			time: 0.5
			options: 
				curve: Spring(damping: 0.3)
				delay: 0.2 * (index + 1)

#loading3
ovals = [oval31, oval32, oval33]
for oval in ovals
	oval.states =
		1:
			x: oval31.x
			y: oval31.y
		2: 
			x: oval31.x + 32
			y: oval31.y - 48
		3: 
			x: oval31.x + 32 + 32
			y: oval31.y
		animationOptions:
			time: 0.5
			curve: Bezier.easeInOut

oval31.stateSwitch("1")
oval32.stateSwitch("2")
oval33.stateSwitch("3")

for oval in ovals
	oval.on Events.AnimationEnd, ->
		this.stateCycle("1", "2", "3")
	
oval31.stateCycle("1", "2", "3")
oval32.stateCycle("1", "2", "3")
oval33.stateCycle("1", "2", "3")		

