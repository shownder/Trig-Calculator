local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require ( "widget" )
local store = require ("store")
local loadsave = require ("loadsave")

local back

local mySettings, restoring
local sineButt, speedButt, boltButt, buyButt, restoreButt, backButt
local sineText, speedText, boltText
local sineDesc, speedDesc, boltDesc
local backEdgeX, backEdgeY, optionsBack
local sineGroup, speedGroup, boltGroup

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   
   if ( "back" == keyName and phase == "up" ) then
       
       timer.performWithDelay(100,goBack2,1)
   end
   return true
end

local function goBack( event )
  if event.phase == "ended" then
    
    storyboard.gotoScene( "menu", { effect="slideRight", time=800})
    
  end
end

local function restorePurchases( event )
  if event.phase == "ended" then
    
    print("Restore all purchases")
    
  end
end

local function descSelect ( event )
  local phase = event.phase 
   if "ended" == phase then

    if event.target.num == 1 then
      if event.target.pressed == false then
        sineGroup.alpha = 1
        speedGroup.alpha = 0
        boltGroup.alpha = 0
        sineButt:setLabel("Purchase")
        sineButt.pressed = true
        speedButt:setLabel("Speeds & Feeds")
        speedButt.pressed = false
        boltButt:setLabel("Bolt Circle")
        boltButt.pressed = false
      else
        --Handle Purchase here
        print("Purchasing SineBar")
      end
    elseif event.target.num == 2 then
      if event.target.pressed == false then
        speedGroup.alpha = 1
        sineGroup.alpha = 0
        boltGroup.alpha = 0
        speedButt:setLabel("Purchase")
        speedButt.pressed = true
        sineButt:setLabel("Sine Bar")
        sineButt.pressed = false
        boltButt:setLabel("Bolt Circle")
        boltButt.pressed = false
      else
        --Handle Purchase here
        print("Purchasing Speeds & Feeds")
      end
    elseif event.target.num == 3 then
      if event.target.pressed == false then
        boltGroup.alpha = 1
        sineGroup.alpha = 0
        speedGroup.alpha = 0
        boltButt:setLabel("Purchase")
        boltButt.pressed = true
        sineButt:setLabel("Sine Bar")
        sineButt.pressed = false
        speedButt:setLabel("Speeds & Feeds")
        speedButt.pressed = false
      else
        --Handle Purchase here
        print("Purchasing Bolt Circle")
      end
    end

   end
end


function scene:createScene( event )
	local screenGroup = self.view

	Runtime:addEventListener( "key", onKeyEvent )

  sineGroup = display.newGroup ( )
  speedGroup = display.newGroup ( )
  boltGroup = display.newGroup ( )

	back = 	display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
  backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin

  optionsBack = display.newRect(screenGroup, 0, 0, display.contentWidth/3, 365)
  optionsBack:setFillColor(255, 255, 255)
  optionsBack:setReferencePoint(display.TopRightReferencePoint)
  optionsBack.x = display.actualContentHeight
  optionsBack.y = 0

  local options = {text="", x=0, y=0, width=300, align="left", font="BerlinSansFB-Reg", fontSize=18}

  title = display.newText( screenGroup, "Function Store", 0, 5, 150, 100, "BerlinSansFB-Reg", 28 )
  title:setTextColor(35, 87, 157)
  --title:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
  title.x = display.actualContentHeight-60

  sineButt = widget.newButton
  {
    id = "sineButt",
    width = 125,
    label = "Sine Bar",
    labelColor = { default = {255, 255, 255}, over = {39, 102, 186, 200}},
    font = "BerlinSansFB-Reg",
    fontSize = 20,
    defaultFile = "Images/buttonOver.png",
    overFile = "Images/button.png",
    onRelease = descSelect,    
    }
  sineButt.num = 1
  sineButt.pressed = false
  screenGroup:insert(sineButt)
  sineButt.x = display.actualContentHeight-85
  sineButt.y = 110

  speedButt = widget.newButton
  {
    id = "speedButt",
    width = 125,
    label = "Speeds & Feeds",
    labelColor = { default = {255, 255, 255}, over = {39, 102, 186, 200}},
    font = "BerlinSansFB-Reg",
    fontSize = 16,
    defaultFile = "Images/buttonOver.png",
    overFile = "Images/button.png",
    onRelease = descSelect,    
    }
  speedButt.num = 2
  speedButt.pressed = false
  screenGroup:insert(speedButt)
  speedButt.x = display.actualContentHeight-85
  speedButt.y = 170

  boltButt = widget.newButton
  {
    id = "boltButt",
    width = 125,
    label = "Bolt Circle",
    labelColor = { default = {255, 255, 255}, over = {39, 102, 186, 200}},
    font = "BerlinSansFB-Reg",
    fontSize = 20,
    defaultFile = "Images/buttonOver.png",
    overFile = "Images/button.png",
    onRelease = descSelect,    
    }
  boltButt.num = 3
  boltButt.pressed = false
  screenGroup:insert(boltButt)
  boltButt.x = display.actualContentHeight-85
  boltButt.y = 230

  restoreButt = widget.newButton
  {
    id = "restoreButt",
    width = 125,
    label = "Restore",
    labelColor = { default = {255,255,255}, over = {198,68,68}},
    font = "BerlinSansFB-Reg",
    fontSize = 20,
    defaultFile = "Images/restoreButtOver.png",
    overFile = "Images/restoreButt.png",
    onRelease = restorePurchases,    
    }
  restoreButt.num = 3
  restoreButt.pressed = false
  screenGroup:insert(restoreButt)
  restoreButt.x = display.actualContentHeight-85
  restoreButt.y = 290

  backButt = display.newImageRect(screenGroup, "Images/backButt.png", 54, 22)
  backButt:setReferencePoint(display.TopLeftReferencePoint)
  backButt:addEventListener("touch", goBack)
  backButt.isHitTestable = true
  backButt.x = 10
  backButt.y = 10

  sineDesc = display.newImageRect( sineGroup, "backgrounds/sineDesc.png", 285, 180 )
  sineDesc.x = 200
  sineDesc.y = 115

  sineText = display.newText( options )
  sineGroup:insert(sineText)
  sineText.text = "Sine Description goes here. Sine Description goes here. Sine Description goes here. Sine Description goes here. "
  sineText.x = 200
  sineText.y = 230

  sineGroup.alpha = 0

  speedDesc = display.newImageRect( speedGroup, "backgrounds/speedDesc.png", 285, 180 )
  speedDesc.x = 200
  speedDesc.y = 115

  speedText = display.newText( options )
  speedGroup:insert(speedText)
  speedText.text = "Sine Description goes here. Sine Description goes here. Sine Description goes here. Sine Description goes here. "
  speedText.x = 200
  speedText.y = 230

  speedGroup.alpha = 0

  boltDesc = display.newImageRect( boltGroup, "backgrounds/boltDesc.png", 285, 180 )
  boltDesc.x = 200
  boltDesc.y = 115

  boltText = display.newText( options )
  boltGroup:insert(boltText)
  boltText.text = "Sine Description goes here. Sine Description goes here. Sine Description goes here. Sine Description goes here. "
  boltText.x = 200
  boltText.y = 240

  boltGroup.alpha = 0

  screenGroup:insert(sineGroup)
  screenGroup:insert(speedGroup)
  screenGroup:insert(boltGroup)


end

function scene:enterScene( event )
  local group = self.view
        
		storyboard.purgeScene( "menu" )

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


