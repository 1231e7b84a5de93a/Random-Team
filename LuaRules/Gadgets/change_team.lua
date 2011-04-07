function gadget:GetInfo()
return {
  name      = "Change Team",
  desc      = "change team periodically",
  author    = "SirMaverick",
  date      = "2011",
  license   = "GNU GPL, v2 or later",
  layer     = 0,
  enabled   = true  --  loaded by default?
	}
end

if (gadgetHandler:IsSyncedCode()) then

local teamchangetime = Spring.GetModOption("teamchangetime", false, 15)

function GetAlivePlayers()

  local alive = {}

  local players = Spring.GetPlayerList(true)
  for i=1,#players do
    local p = players[i]
    local _, active, spec = Spring.GetPlayerInfo(p)
    if active and not spec then
      table.insert(alive, p)
    end
  end

  return alive

end

function GetAliveTeams()

  local alive = {}

  local teams = Spring.GetTeamList()
  local gaiateam = Spring.GetGaiaTeamID()
  for i=1,#teams do
    local t = teams[i]
    local _, _, isDead, isAiTeam = Spring.GetTeamInfo(t)
    if not isDead and not isAiTeam and (gaiateam ~= t) then
      table.insert(alive, t)
    end
  end

  return alive

end

-- from CA/ZK
-- {[1] = 1, [2] = 3, [3] = 4} -> {[3] = 1, [1] = 4, [4] = 3}
local function ShuffleSequence(nums)
  local seq, shufseq = {}, {}
  for i = 1, #nums do
    seq[i] = {nums[i], math.random()}
  end
  table.sort(seq, function(a,b) return a[2] < b[2] end)
  for i = 1, #nums do
    shufseq[nums[i]] = seq[i][1]
  end
  return shufseq
end

function gadget:Initialize()

end

function gadget:GameFrame(n)

  if n%(teamchangetime*30) == 0 then

    local players = GetAlivePlayers()
    local teams = GetAliveTeams()
    local newteams = ShuffleSequence(teams)

    for i=1,#players do

      local p = players[i]
      local teamold = select(4,Spring.GetPlayerInfo(p))
      local teamnew = newteams[teamold]

      if Spring.ChangeTeam then
        Spring.ChangeTeam(p, teamnew)
      end

    end

  end

end

else

end
