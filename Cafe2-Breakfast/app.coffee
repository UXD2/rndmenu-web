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
		
menuDB.get "/menu/"+getDate()+"/2식당/아침", (menus) ->
	menusArray = _.toArray(menus)

	if menus is null
		noMenu.opacity = 1.0
	
	barGroup.visible = false
	
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

bars = [bar1, bar2, bar3, bar4, bar5]
for item in bars
	item.states =
		small:
			scaleY: 0.8
			opacity: 0.5
		normal: 
			scaleY: 1.2
			opacity: 1.0
		animationOptions:
			time: 0.5
			curve: Bezier.easeInOut
			
	item.stateSwitch("small")
	
	item.on Events.AnimationEnd, ->
		this.stateCycle("small", "normal")

bars[0].stateCycle("small", "normal")
Utils.delay 0.2, ->
	bars[1].stateCycle("small", "normal")
Utils.delay 0.4, ->
	bars[2].stateCycle("small", "normal")
Utils.delay 0.6, ->
	bars[3].stateCycle("small", "normal")
Utils.delay 0.8, ->
	bars[4].stateCycle("small", "normal")		

