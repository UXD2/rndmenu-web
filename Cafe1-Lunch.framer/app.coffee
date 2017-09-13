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
		
menuDB.get "/menu/"+getDate()+"/1식당/점심", (menus) ->
	menusArray = _.toArray(menus)

	if menus is null
		noMenu.opacity = 1.0
	
	dotGroup.visible = false
		
	lastItemMaxY = 0	
	for menuData, index in menusArray
		item = _item_image.copySingle()	
		item.parent = scroll.content
		item.visible = true
		#item.y = index * (item.height + gutter) + 64
		item.y = lastItemMaxY + gutter
		lastItemMaxY = item.maxY
		
		item.onTap ->
			heart.scale = 0.5
							
			changeHeartColor(heart)
		
			animation_cirlces()
			
			Utils.delay 1.0, ->
				heart.animate
					scale: 0.1
					opacity: 0.0
					options:
						time: 0.5
						curve: Bezier.easeInOut
		
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

#loading1
dots = [dot1, dot2, dot3]

for dot in dots
	dot.states =
		small:
			scale: 0.8
			opacity: 0.3
		normal: 
			scale: 1.2
			opacity: 1.0
		animationOptions:
			time: 0.5
			curve: Bezier.easeInOut
			
	dot.stateSwitch("small")
	
	dot.on Events.AnimationEnd, ->
		this.stateCycle("small", "normal")

dot1.stateCycle("small", "normal")
Utils.delay 0.3, ->
	dot2.stateCycle("small", "normal")
Utils.delay 0.6, ->
	dot3.stateCycle("small", "normal")		

heart.scale = 0.5


# This is a function which would generate random x & y positions and opacity value. The random x & y value would make the confetti or circles travel in random direction when they would come out from behind the heart. randomColorAlfa would control their opacity so as to give a feel of randomness in the whole thing.
randomXY = -> return Utils.randomNumber(-300,300)
randomColorAlfa = -> return Utils.randomNumber(0,1)


#funtion to change layer color to red

changeHeartColor = (layer) ->
	layer.animate
		opacity: 1.0
		color: "#FB0271"
		options: 
			time: 1	 

# function to create the colored circles and then animate them
animation_cirlces = ->
	for i in [0..10]
		circles = new Layer
			width: 19
			height: 19
			parent: wrapper
			x: Align.center
			y: Align.center
			borderRadius: 20
			backgroundColor: "#FB0271"
			opacity: randomColorAlfa()
# 		we have used a function here randomXY() which generates random coordinates between 2 limits that we have specified in the begining. This would make the circles fly away in random directions	
		circles.animate
			properties: 
				x: randomXY()
				y: randomXY()
				scale: 0
				options:
					time: 1
					delay: 0.2

# 		we need to clear the circles created to give an effect of fireworks exploding. we can either reducde the opacity to zero or destroy the circles. If we reduce the opacity than the circles would start accumulating after few uses and the prototype would become sluggish
		circles.onAnimationEnd ->
			@destroy()
		
		circles2 = new Layer
			width: 19
			height: 19
			parent: wrapper
			x: Align.center
			y: Align.center
			borderRadius: 20
			backgroundColor: "#50E3C2"
			opacity: randomColorAlfa()
		circles2.animate
			properties: 
				x: randomXY()
				y: randomXY()
				scale: 0
				options:
					time: 1
					delay: 0.2

		circles2.onAnimationEnd ->
			@destroy()
			

	