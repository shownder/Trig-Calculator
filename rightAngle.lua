--
-- Project: Trades Math Calculator
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
--"WCManoNegraBta"
--Require
local widget = require ( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local stepperDataFile = require("Images.customStep_customStep")
local tapAniDataFile = require("Images.tapSheetv2_tapSheetv2")

display.setStatusBar(display.HiddenStatusBar)

--Local forward references


local back
local angleAtext, angleBtext, sideAtext, sideBtext, sideCtext
local whatTap
local tapTable, aniTable

local backEdgeX, backEdgeY
local tapCount

local area, areaAnswer
local continue

local angleAtap, angleBtap, sideAtap, sideBtap, sideCtap
local stepSheet, buttSheet, tapSheet

local decPlaces, measureLabel, optionsGroup, optionsButt
local decStep, decLabel, places, menuBack
local menu, reset, helpButt
local measure, toMill, toInch

local options, angAcalc, angBcalc, sideAcalc, sideBcalc, sideCcalc
local addListeners, removeListeners, toMill, toInch, goBack2


--Listeners
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   
   if ( "back" == keyName and phase == "up" ) then
       
       timer.performWithDelay(100,goBack2,1)
   end
   return true
end

local function onScreenTouch( event )
	if event.phase == "ended" then
		
		if event.xStart < event.x and (event.x - event.xStart) >= 30 then
			transition.to ( optionsGroup, { time = 500, x=(backEdgeX + 118) } )
			transition.to ( optionsGroup, { time = 500, alpha = 1, delay = 200} )
			options = true
			return true

		elseif event.xStart > event.x and (event.xStart - event.x) >= 30 then 
	    transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
			transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
			options = false
	    return true
    end
	end 
end

local function helpScreen(event)
	local phase = event.phase
  
  if "ended" == phase then	

    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
    end
    
    Runtime:removeEventListener( "touch", onScreenTouch  )
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "rightAngle" }, isModal = true}  )
    
  end
      
end

local function resetCalc(event)
	local phase = event.phase
		
    sideAtext.text = "Tap Me"
    sideBtext.text = "Tap Me"
    sideCtext.text = "Tap Me"
    angleAtext.text = "Tap Me"
    angleBtext.text = "Tap Me"
    
		transition.to(angleAtext, {time = 300, alpha = 0})
		transition.to(angleAtap, {time = 300, alpha = 1})
		transition.to(angleBtext, {time = 300, alpha = 0})
		transition.to(angleBtap, {time = 300, alpha = 1})
		transition.to(sideAtext, {time = 300, alpha = 0})
		transition.to(sideAtap, {time = 300, alpha = 1})
		transition.to(sideBtext, {time = 300, alpha = 0})
		transition.to(sideBtap, {time = 300, alpha = 1})
		transition.to(sideCtext, {time = 300, alpha = 0})
		transition.to(sideCtap, {time = 300, alpha = 1})
    
    areaAnswer.text = ""
    
    tapCount = 0
		continue = false
    storyboard.number = nil
    
    for i = 1, 5, 1 do
      tapTable[i]:setTextColor(0, 0, 0)
    end
    
    timer.performWithDelay( 1, addListeners )
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end		
end

local function goBack(event)
	
			transition.to (optionsGroup, { time = 100, alpha = 0 } )
			storyboard.gotoScene( "menu", { effect="slideRight", time=800})
		
end

local function calcTouch( event )
	if event.phase == "ended" then
    
    Runtime:removeEventListener( "touch", onScreenTouch  )
		
		if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end
		
		whatTap = event.target.tap
		
		if whatTap > 5 then
			tapCount = tapCount + 1
		end
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end
		
		storyboard.showOverlay( "calculator", { effect="fromTop", time=200, params = { negTrue = false, needDec = true }, isModal = true }  )
		
		return true
	end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			--measureLabel.text = "Metric"
      measureLabel:setText("metric")
      measureLabel.x = backEdgeX + 115
      measureLabel.y = backEdgeY + 95
			for i = 1, 3, 1 do			
        if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		else
			measure:setLabel("TO METRIC")
			--measureLabel.text = "Imperial"
      measureLabel:setText("imperial")
      measureLabel.x = backEdgeX + 115
      measureLabel.y = backEdgeY + 95
			for i = 1, 3, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		end
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
    end
	end
  
	
end

local function stepPress( event )
	local phase = event.phase
	
	if "increment" == phase then
		places = places + 1
		decLabel.text = places
	elseif "decrement" == phase then
		places = places - 1
		decLabel.text = places
	end
end

local function alertListener ( event )
	if "clicked" == event.action then

		sideAtap.alpha = 1
		sideAtext.alpha = 0
		sideBtap.alpha = 1
		sideBtext.alpha = 0
		sideAtext.text = "Tap Me"
		sideBtext.text = "Tap Me"
		tapCount = 1
		if angleAtext.text == "Tap Me" then
			angleAtap.alpha = 1
			angleAtext.alpha = 0
		end
		if angleBtext.text == "Tap Me" then
			angleBtap.alpha = 1
			angleBtext.alpha = 0
		end
	end
end

--End Listeners


--Called when the scene doesn't exist, only called once unless purged/removed

function scene:createScene( event )
	local screenGroup = self.view
	
	tapTable = {}
	aniTable = {}
	optionsGroup = display.newGroup ( )
	options = false
  local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="WCManoNegraBta", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="WCManoNegraBta", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="WCManoNegraBta", fontSize=24}
  local textOptionsL2 = {text="", x=0, y=0, width=200, align="left", font="WCManoNegraBta", fontSize=24}
  
  Runtime:addEventListener( "key", onKeyEvent )
  Runtime:addEventListener( "touch", onScreenTouch  )

	stepSheet = graphics.newImageSheet("Images/customStep_customStep.png", stepperDataFile.getSpriteSheetData() )
	
	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
	local tapAniSequenceDataFile = require("Images.tapAniv2");
	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
	tapCount = 0
	continue = false
	
	back = display.newImageRect ( screenGroup, "backgrounds/rightangle.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
	
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
	
	menuBack = display.newImageRect( optionsGroup, "backgrounds/optionsBack.png", 143, 294 )
	menuBack.x = backEdgeX + 120
	menuBack.y = backEdgeY + 180
  
  helpButt = widget.newButton
	{
		id = "helpButt",
		--label = "HELP",
		--labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 16,
		onEvent = helpScreen,
		defaultFile = "Images/infoButt.png",
		overFile = "Images/infoButtOver.png",
		}
	optionsGroup:insert(helpButt)
	helpButt.x = backEdgeX + 105
	helpButt.y = backEdgeY + 85

	decStep = widget.newStepper
	{
		
		left = 0,
		top = 0,
		initialValue = 4,
		minimumValue = 2,
		maximumValue = 5,
		sheet = stepSheet,
		defaultFrame = 1,
		noMinusFrame = 4,
		noPlusFrame = 5,
		minusActiveFrame = 2,
		plusActiveFrame = 3,
		onPress = stepPress,		
		}
	optionsGroup:insert(decStep)
	decStep.x = backEdgeX + 105
	decStep.y = backEdgeY + 120
	
	measure = widget.newButton
	{
		id = "measureButt",
		label = "TO METRIC",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 16,
		onEvent = measureChange,
		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
	optionsGroup:insert(measure)
	measure.x = backEdgeX + 115
	measure.y = backEdgeY + 170
	
	menu = widget.newButton
	{
		id = "menuButt",
		label = "MENU",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "WCManoNegraBta",
		fontSize = 16,
		onRelease = goBack,

		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
	optionsGroup:insert(menu)
	menu.x = backEdgeX + 115
	menu.y = backEdgeY + 230
	
	reset = widget.newButton
	{
		id = "resetButt",
		label = "RESET",
		labelColor = { default = {128, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 18,
		onEvent = resetCalc,

		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
	optionsGroup:insert(reset)
	reset.x = backEdgeX + 115
	reset.y = backEdgeY + 290
	
	optionsGroup.alpha = 0
	transition.to ( optionsGroup, { time = 500, alpha = 1, delay = 500} )
	transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125), delay = 1300} )
	transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 1500} )
	
	decPlaces = display.newEmbossedText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
  decPlaces:setTextColor(255)
  decPlaces:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	decPlaces.x = backEdgeX + 115
	decPlaces.y = backEdgeY + 117
	
	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "WCManoNegraBta", 18 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 118
  
  measureLabel = display.newEmbossedText(screenGroup, "imperial", 0, 0, "Rock Salt", 16)
  measureLabel:setTextColor(255)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 95
	
--	measureLabel = display.newText( screenGroup, "imperial", 0, 0, "Rock Salt", 16 )
--	measureLabel.x = backEdgeX + 115
--	measureLabel.y = backEdgeY + 95
	
--	area = display.newText( screenGroup, "AREA: ", 0, 0, "WCManoNegraBta", 20 )
--	area.x = backEdgeX + 320
--	area.y = backEdgeY + 230

  area = display.newEmbossedText(screenGroup, "Area:", 0, 0, "Rock Salt", 16)
  area:setTextColor(255)
  area:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	area.x = backEdgeX + 320
	area.y = backEdgeY + 230
  
  areaAnswer = display.newText( textOptionsL2 )
  screenGroup:insert(areaAnswer)
	areaAnswer.x = backEdgeX + 450
	areaAnswer.y = backEdgeY + 230
	
	sideCtext = display.newText( textOptionsR )
	sideCtext:addEventListener ( "touch", calcTouch )
  screenGroup:insert(sideCtext)
	sideCtext.x = backEdgeX + 250
	sideCtext.y = backEdgeY + 145
	sideCtext.tap = 1
	tapTable[1] = sideCtext
	sideCtext.alpha = 0

	sideCtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	sideCtap.x = backEdgeX + 290
	sideCtap.y = backEdgeY + 145
	screenGroup:insert(sideCtap)
	sideCtap:addEventListener ( "touch", calcTouch )
	sideCtap.tap = 11
	aniTable[11] = sideCtap
	sideCtap:play()

	sideAtext = display.newText( textOptionsC )
	sideAtext:addEventListener ( "touch", calcTouch )
  screenGroup:insert(sideAtext)
	sideAtext.x = backEdgeX + 330
	sideAtext.y = backEdgeY + 275
	sideAtext.tap = 2
	tapTable[2] = sideAtext
	sideAtext.alpha = 0
	
	sideAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	sideAtap.x = backEdgeX + 330
	sideAtap.y = backEdgeY + 275
	screenGroup:insert(sideAtap)
	sideAtap:addEventListener ( "touch", calcTouch )
	sideAtap.tap = 12
	aniTable[12] = sideAtap
	sideAtap:play()
	
	sideBtext = display.newText( textOptionsR )
	sideBtext:addEventListener ( "touch", calcTouch )
  screenGroup:insert(sideBtext)
	sideBtext.x = backEdgeX + 420
	sideBtext.y = backEdgeY + 180
	sideBtext.tap = 3
	tapTable[3] = sideBtext
	sideBtext.alpha = 0
	
	sideBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	sideBtap.x = backEdgeX + 450
	sideBtap.y = backEdgeY + 180
	screenGroup:insert(sideBtap)
	sideBtap:addEventListener ( "touch", calcTouch )
	sideBtap.tap = 13
	aniTable[13] = sideBtap
	sideBtap:play()
		
	angleAtext = display.newText( textOptionsR )
	angleAtext:addEventListener ( "touch", calcTouch )
  screenGroup:insert(angleAtext)
	angleAtext.x = backEdgeX + 405
	angleAtext.y = backEdgeY + 70
	angleAtext.tap = 4
	tapTable[4] = angleAtext
	angleAtext.alpha = 0
	
	angleAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	angleAtap.x = backEdgeX + 400
	angleAtap.y = backEdgeY + 70
	screenGroup:insert(angleAtap)
	angleAtap:addEventListener ( "touch", calcTouch )
	angleAtap.tap = 14
	aniTable[14] = angleAtap
	angleAtap:play()
	
	angleBtext = display.newText( textOptionsL )
	angleBtext:addEventListener ( "touch", calcTouch )
  screenGroup:insert(angleBtext)
	angleBtext.x = backEdgeX + 190
	angleBtext.y = backEdgeY + 290
	angleBtext.tap = 5
	tapTable[5] = angleBtext
	angleBtext.alpha = 0
	
	angleBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	angleBtap.x = backEdgeX + 170
	angleBtap.y = backEdgeY + 290
	screenGroup:insert(angleBtap)
	angleBtap:addEventListener ( "touch", calcTouch )
	angleBtap.tap = 15
	aniTable[15] = angleBtap
	angleBtap:play()

	optionsGroup:setReferencePoint(display.CenterReferencePoint)
  
  for i = 1, 5, 1 do
      tapTable[i]:setTextColor(0, 0, 0)
  end

end


-- Called immediately after scene has moved onscreen, called everytime scene is loaded

function scene:enterScene( event )
  local group = self.view
        
		storyboard.purgeScene( "menu" )

end

--Called when user leaves scene

function scene:exitScene( event )
  local group = self.view
   
  Runtime:removeEventListener( "touch", onScreenTouch  )
  Runtime:removeEventListener( "key", onKeyEvent )
	
end

--Called when scene is Purged or Removed

function scene:destroyScene( event )
   local group = self.view

		optionsGroup:removeSelf()
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "destroyScene", scene )

scene:addEventListener( "exitScene", scene )

--Overlay
-- the following event is dispatched once overlay is enabled
function scene:overlayBegan( event )
    print( "Showing overlay: " .. event.sceneName )
end

-- the following event is dispatched once overlay is removed
function scene:overlayEnded( event )
    local group = self.view
    
    Runtime:addEventListener( "touch", onScreenTouch  )
    storyboard.isOverlay = false
    
  if storyboard.number ~= "Tap Me" then
  
  local doneCount = 0
  print(tapCount)

	if whatTap > 5 then
			for i = 11, 15, 1 do
				if whatTap == i then					
					aniTable[i].alpha = 0
					tapTable[i - 10].alpha = 1
					whatTap = (whatTap - 10)	
				end
			end
	end
	
  tapTable[whatTap].text = storyboard.number
	
	if angleAtext.text ~= "Tap Me" then
		if tonumber(angleAtext.text) >= 90 then
			angleAtext.text = 89
		end
	elseif angleBtext.text ~= "Tap Me" then
		if tonumber(angleBtext.text) >= 90 then
			angleBtext. text = 89
		end
	end
	
	if tapCount == 2 then
		continue = true
		angleAtext.alpha = 1
		angleBtext.alpha = 1
		sideAtext.alpha = 1
		sideBtext.alpha = 1
		sideCtext.alpha = 1
		angleAtap.alpha = 0
		angleBtap.alpha = 0
		sideAtap.alpha = 0
		sideBtap.alpha = 0
		sideCtap.alpha = 0
	end
	
	if continue ~= true then
		if whatTap == 4 then		
			angleBtext.text = 90 - angleAtext.text
			angleBtext.alpha = 1
			angleBtap.alpha = 0
		elseif whatTap == 5 then		
			angleAtext.text = 90 - angleBtext.text
			angleAtext.alpha = 1
			angleAtap.alpha = 0
		end
	end
		
	if (continue) then
		if sideCtext.text ~= "Tap Me" then
			if sideAtext.text ~= "Tap Me" then
				if tonumber(sideCtext.text) < tonumber(sideAtext.text) then
				native.showAlert ( "Error", "Hypotenuse cannot be smaller than another side!", { "OK" }, alertListener )
				continue = false
				end
			elseif sideBtext.text ~= "Tap Me" then
				if tonumber(sideCtext.text) < tonumber(sideBtext.text) then
				native.showAlert ( "Error", "Hypotenuse cannot be smaller than another side!", { "OK" }, alertListener )
				continue = false
				end
			end
		end
	end
		
	if (continue) then
		if whatTap == 1 then
			sideCcalc()
		elseif whatTap == 2 then
			sideAcalc()
		elseif whatTap == 3 then
			sideBcalc()
		elseif whatTap == 4 then
			angAcalc()
		elseif whatTap == 5 then
			angBcalc()
		end
	end
  
  
	if (continue) then
		local areaContent = 0.5 * (sideAtext.text * sideBtext.text)
		areaAnswer.text = math.round(areaContent * math.pow(10, places)) / math.pow(10, places)
	end
		
	if (continue) then
		for i =1, 5, 1 do
			tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
		end
	end
  
  for i = 1, 5, 1 do
    if tapTable[i].text ~= "Tap Me" then
      doneCount = doneCount + 1
    end
  end
  
  if doneCount == 5 then
    print("removing event listeners")
    timer.performWithDelay( 10, removeListeners, 2 )
  end
  
  if doneCount == 5 then
    for i = 1, 5, 1 do
      tapTable[i]:setTextColor(255, 255, 255)
    end
  end
  
else
  tapCount = tapCount - 1
  end	
 
end
	

function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
end

function sideAcalc()
		if sideAtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
			sideBtext.text = math.sqrt(( sideCtext.text * sideCtext.text) - ( sideAtext.text * sideAtext.text))
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
		elseif sideAtext.text ~= "Tap Me" and sideBtext.text ~= "Tap Me" then
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideAtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
			sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideAtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
			angleAtext.text = 90 - angleBtext.text
			sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		
	end
end

function sideBcalc()
		if sideBtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
			sideAtext.text = math.sqrt (( sideCtext.text * sideCtext.text ) - ( sideBtext.text * sideBtext.text ))
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
		elseif sideBtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
			angleBtext.text = 90 - angleAtext.text
			sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideBtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
			angleAtext.text = 90 - angleBtext.text
			sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))

		elseif sideAtext.text ~= "Tap Me" and sideBtext.text ~= "Tap Me" then
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

function sideCcalc()
	if sideCtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideCtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
		sideAtext.text = math.sqrt (( sideCtext.text * sideCtext.text ) - ( sideBtext.text * sideBtext.text ))
		angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
		angleBtext.text = 90 - angleAtext.text
	elseif sideAtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
		sideBtext.text = math.sqrt(( sideCtext.text * sideCtext.text) - ( sideAtext.text * sideAtext.text))
		angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
		angleBtext.text = 90 - angleAtext.text
	end
end

function angAcalc()
	if sideCtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	elseif sideAtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
		angleBtext.text = 90 - angleAtext.text
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

function angBcalc()
	if sideCtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	elseif sideAtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

function addListeners()
  print("adding event listeners")
  sideAtext:addEventListener( "touch", calcTouch )
  sideBtext:addEventListener( "touch", calcTouch )
  sideCtext:addEventListener( "touch", calcTouch )
  angleAtext:addEventListener( "touch", calcTouch )
  angleBtext:addEventListener( "touch", calcTouch )
end

function removeListeners()
  print("removing event listeners")
  sideAtext:removeEventListener( "touch", calcTouch )
  sideBtext:removeEventListener( "touch", calcTouch )
  sideCtext:removeEventListener( "touch", calcTouch )
  angleAtext:removeEventListener( "touch", calcTouch )
  angleBtext:removeEventListener( "touch", calcTouch )
end

function goBack2()
	
  if (storyboard.isOverlay) then
    storyboard.number = "Tap Me"
    storyboard.hideOverlay()
  else
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
  end
		
end
  
--Scene Overlay Listeners

scene:addEventListener( "overlayEnded" )

scene:addEventListener( "overlayBegan" )


return scene