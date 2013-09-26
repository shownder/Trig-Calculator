local widget = require ( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local utility = require( "utility" )

--Load Forward Variables

local sineButt, speedButt, boltButt
local sineText, speedText, boltText, descText
local sineDesc, speedDesc, boltDesc
local sineBuy, speedBuy, boltBuy
local sineRestore, speedRestore, boltRestore
local descBox

local back, backButt

local mySettings, restoring

--Listeners

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   
   if ( "back" == keyName and phase == "up" ) then
       
       timer.performWithDelay(100,goBack2,1)
   end
   return true
end

local function description ( event )
	local phase = event.phase
  
  print("button was pushed")

   if "ended" == phase then
   	if event.target.num == 1 then
		--storyboard.gotoScene( "rightAngle", { effect="slideLeft", time=800} )
		elseif event.target.num == 2 then
		--storyboard.gotoScene( "oblique", { effect="slideLeft", time=800} )
		elseif event.target.num == 3 then
      descText.text = "Quickly and accurately calculate precision block stack or angle for use with sine bars or sine plates."
		elseif event.target.num == 4 then
      descText.text = "Calculate cutting speeds and feeds for drills, milling cutters, and lathe workpieces. Also between RPM and feet/min or meters/min and between feed/rev and feed/minute."
		elseif event.target.num == 5 then
      descText.text = "Calculate X-Y coordinates for equally spaced bolts. You can make the center of the circle any coordinate you need, and place the first hole at any angle."
    elseif event.target.num == 6 then
		--storyboard.gotoScene( "storePage", { effect="slideLeft", time=800} )
   	end
   end
end

local function buySomething ( event )
	local phase = event.phase
  
  if "ended" == phase then
   	
   end
end

local function goBack(event)
	
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
		
end

function scene:createScene( event )
	local screenGroup = self.view
  
  Runtime:addEventListener( "key", onKeyEvent )
  
  back = display.newImageRect ( screenGroup, "backgrounds/storeBack.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
	
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  backButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 50,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "goBack",
		label = "<-",
		onRelease = goBack,		
		}
	screenGroup:insert(backButt)
	backButt.x = backEdgeX + 80
	backButt.y = backEdgeY + 50
  
  sineButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "SineButt",
		label = "SINEBAR",
		onRelease = description,		
		}
	sineButt.num = 3
	screenGroup:insert(sineButt)
	sineButt.x = backEdgeX + 150
	sineButt.y = backEdgeY + 180
  
	speedButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "speedButt",
		label = "SPEEDS & FEEDS",
		onRelease = description,		
		}
	speedButt.num = 4
	screenGroup:insert(speedButt)
	speedButt.x = backEdgeX + 150
	speedButt.y = backEdgeY + 240

	
	boltButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 20,
		id = "boltButt",
		label = "BOLT CIRCLE",
		onRelease = description,		
		}
	boltButt.num = 5
	screenGroup:insert(boltButt)
	boltButt.x = backEdgeX + 150
	boltButt.y = backEdgeY + 300
  
  descBox = display.newRoundedRect(screenGroup, 220, 70, 250, 250, 12)
  descBox.x = backEdgeX + 380
  descBox.y = backEdgeY + 190
  descBox.strokeWidth = 2
  descBox:setStrokeColor(0, 0, 0)
  
  descText = display.newText( {parent = screenGroup, text = "Choose a function from the left to see a description. Once purchased, it will appear on the main menu.", x = 0, y = 0, width = 220, height = 200, font = native.systemFontBold, fontSize = 18, align = "center"})
  descText:setTextColor(0, 0, 0)
  descText.x = backEdgeX + 380
  descText.y = backEdgeY + 170
  
  sineBuy = widget.newButton
	{
		id = "sineBuy",
		label = "",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "WCManoNegraBta",
		fontSize = 16,
		onRelease = buySomething,

		defaultFile = "Images/buyButt.png",
		overFile = "Images/buyButtOver.png",
		}
	screenGroup:insert(sineBuy)
	sineBuy.x = backEdgeX + 320
	sineBuy.y = backEdgeY + 290
  
  sineRestore = widget.newButton
	{
		id = "sineRestore",
		label = "",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "WCManoNegraBta",
		fontSize = 16,
		onRelease = buySomething,

		defaultFile = "Images/restoreButt.png",
		overFile = "Images/restoreButtOver.png",
		}
	screenGroup:insert(sineRestore)
	sineRestore.x = backEdgeX + 450
	sineRestore.y = backEdgeY + 290
  
  
end

function scene:enterScene( event )
  local group = self.view
        
    storyboard.purgeScene( "menu" )
    
    mySettings = utility.loadTable("settings.json")

    if mySettings == nil then
      mySettings = {}
      mySettings.sinePaid = false
      mySettings.speedPaid = false
      mySettings.boltPaid = false
      utility.saveTable(mySettings, "settings.json")
    end

end

function scene:exitScene( event )
  local group = self.view
   
  Runtime:removeEventListener( "key", onKeyEvent )
	
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

function goBack2()
	
  if (storyboard.isOverlay) then
    storyboard.number = "Tap Me"
    storyboard.hideOverlay()
  else
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
  end
		
end

return scene
