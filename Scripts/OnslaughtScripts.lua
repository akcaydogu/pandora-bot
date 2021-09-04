function SetupOnslaught( source, args )

	local rotationSize = #OnslaughtRotationData
	local availableSlots = 3
	local currentTime = GetDate({ }) + (DebugOnslaughtTimeOffset or 0)
	--DebugPrint({ Text = "currentTime = "..currentTime })
	local secondsInDay = 24 * 60 * 60
	local currentDayCount = math.floor( currentTime / secondsInDay )
	DebugPrint({ Text = "currentDayCount = "..currentDayCount })

	local rotationNum = math.ceil( (currentDayCount + (source.Slot - 1)) / availableSlots )
	DebugPrint({ Text = "rotationNum = "..rotationNum })

	local onslaughtIndex = ((rotationNum + (source.Slot-1)) % rotationSize) + 1
	DebugPrint({ Text = "onslaughtIndex = "..onslaughtIndex })

	local onslaughtName = OnslaughtRotationData[onslaughtIndex]

	GameState.OnslaughtsCompleted = GameState.OnslaughtsCompleted or {}
	GameState.OnslaughtsCompleted[rotationNum] = GameState.OnslaughtsCompleted[rotationNum] or {}
	if GameState.OnslaughtsCompleted[rotationNum][source.Slot] then
		-- Completed
		GameState.Onslaughts[source.Slot] = nil
		source.UseText = source.UseTextLocked
		--source.UnlockTime = GetTimerStringHours( unlockTime, { Decimals = 0, Hours = true, Minutes = true, Seconds = false } )
	else
		GameState.Onslaughts[source.Slot] = onslaughtName
		--GameState.LastOnslaughtServeTime = currentTime + unlockTime
	end

	if GameState.Onslaughts[source.Slot] ~= nil then
		local onslaughtName = GameState.Onslaughts[source.Slot]
		source.Onslaught = OnslaughtData[onslaughtName]
		if source.Onslaught ~= nil then
			SetAnimation({ Name = source.AvailableAnimation, DestinationId = source.ObjectId })
		end
	end

end

function ChooseOnslaught()
	local available = {}
	for name, data in pairs( OnslaughtData ) do
		if not IsOnslaughtServed( name ) then
			table.insert( available, name )
		end
	end
	return GetRandomValue( available )
end

function IsOnslaughtServed( name )
	for k, onslaughtName in pairs( GameState.Onslaughts ) do
		if onslaughtName == name then
			return true
		end
	end
	return false
end

function StartOnslaught( source, args )

	local onslaught = source.Onslaught
	if onslaught == nil then
		return
	end

	AddInputBlock({ Name = "StartOnslaught" })

	-- Misc cleanup
	StopSound({ Id = AmbientMusicId, Duration = 1.0 })
	AmbientMusicId = nil
	AmbientTrackName = nil
	ResetObjectives()
	killTaggedThreads( RoomThreadName )
	CurrentDeathAreaRoom = nil
	PreviousDeathAreaRoom = nil
	SetConfigOption({ Name = "FlipMapThings", Value = false })

	GameState.SuspendedRun = CurrentRun
	GameState.ActiveOnslaught = onslaught.Name
	onslaught.IgnoreKeepsake = true
	local onslaughtRun = StartNewRun( nil, onslaught )
	AddTimerBlock( onslaughtRun, "StartOnslaught" )
	EnterOnslaughtPresentation( onslaughtRun, source )
	RemoveInputBlock({ Name = "StartOnslaught" })
	RemoveTimerBlock( onslaughtRun, "StartOnslaught" )

	LoadMap({ Name = onslaughtRun.CurrentRoom.Name, ResetBinks = true })

end

function SpawnOnslaughtObjects( source )

	local metaUpgradeViewerId = SpawnObstacle({ Name = "MetaUpgradeViewer", Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId, OffsetX = 200, OffsetY = 0 })
	local shrineUpgradeViewerId = SpawnObstacle({ Name = "ShrineUpgradeViewer", Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId, OffsetX = -200, OffsetY = 0 })

	local startButtonId = SpawnObstacle({ Name = "OnslaughtStartButton", Group = "Standing", DestinationId = CurrentRun.Hero.ObjectId, OffsetX = 0, OffsetY = -200 })
	local notifyName = "OnslaughtStart"
	NotifyOnInteract({ Id = startButtonId, Notify = notifyName })
	waitUntil( notifyName )

	SetMusicSection( 2, MusicId )

	Destroy({ Ids = { metaUpgradeViewerId, shrineUpgradeViewerId, startButtonId } })

end

function OnslaughtVictory()

	AddInputBlock({ Name = "OnslaughtVictory" })

	CurrentRun = GameState.SuspendedRun
	GameState.SuspendedRun = nil
	RemoveLastAwardTrait()
	RemoveLastAssistTrait()

	ClearOnslaughtPresentation( CurrentRun )

	for slot, onslaughtName in pairs( GameState.Onslaughts ) do
		if onslaughtName == GameState.ActiveOnslaught then

			local rotationSize = #OnslaughtRotationData
			local availableSlots = 3
			local currentTime = GetDate({ }) + (DebugOnslaughtTimeOffset or 0)
			local secondsInDay = 24 * 60 * 60
			local currentDayCount = math.floor( currentTime / secondsInDay )
			local rotationNum = math.ceil( (currentDayCount + (slot - 1)) / availableSlots )
			local onslaughtIndex = ((rotationNum + (slot-1)) % rotationSize) + 1
			GameState.OnslaughtsCompleted = GameState.OnslaughtsCompleted or {}
			GameState.OnslaughtsCompleted[rotationNum] = GameState.OnslaughtsCompleted[rotationNum] or {}
			GameState.OnslaughtsCompleted[rotationNum][slot] = true

			GameState.Onslaughts[slot] = nil
		end
	end
	GameState.ActiveOnslaught = nil

	LoadMap({ Name = "RoomPreRun", ResetBinks = true })
	RemoveInputBlock({ Name = "OnslaughtVictory" })

	LeaveOnslaughtPresentation( CurrentRun, true )

end

function OnslaughtDeath( currentRun, killer, killingUnitWeapon )

	AddInputBlock({ Name = "OnslaughtDeath" })
	ClearHealthShroud()
	currentRun.Hero.HandlingDeath = true
	currentRun.Hero.IsDead = true

	table.insert( currentRun.RoomHistory, currentRun.CurrentRoom )
	UpdateRunHistoryCache( currentRun, currentRun.CurrentRoom )

	ZeroSuperMeter()
	ResetObjectives()
	ActiveScreens = {}

	FailOnslaughtPresentation( currentRun, killer, killingUnitWeapon )

	currentRun.Hero.HandlingDeath = false

	CurrentRun = GameState.SuspendedRun
	GameState.SuspendedRun = nil
	GameState.ActiveOnslaught = nil
	RemoveLastAwardTrait()
	RemoveLastAssistTrait()

	LoadMap({ Name = "RoomPreRun", ResetBinks = true })
	RemoveInputBlock({ Name = "OnslaughtDeath" })

	LeaveOnslaughtPresentation( CurrentRun, false )

end