local _, core = ...;   --addon name, core is the namespace (a table shared between all lua files within the addon)

print("|cff00ccffLvlzackig loaded! Type /lvlhelp for /commands |r")


--local Tracker_Frame = CreateFrame("Frame")

local segments = {} --table for data storage, one subtable per registered segment.
local run = 1	--initializes segment number
local running = 0	--set run mode off
local str = "%.1f";

local pause = {} --table for time stamp storage during breaks.

---------
--XP Tracker

local curXP = UnitXP("player")
local curMaxXP = UnitXPMax("player")
local splitXP = 0
local function calcxpgain(new)
    if new > curXP then
        local d = new-curXP
        curXP = new
        return d
    else
        local d = curMaxXP-curXP+new
        curXP = new
        curMaxXP = UnitXPMax("player")
        return d
    end
end
 


local function zackiggo()	--function for start / end slash command
	if running == 1 then
		segments[run].t2 = GetTime()
		local dt = segments[run].t2-(segments[run].t1+segments[run].stoptime)          
		local str = "%.1f";
		print("|cff00ccffSegment |r" .. #segments .. "|cff00ccff ended after |r" .. str:format(dt) .. "|cff00ccff seconds. Comment: |r" )
		print("|cff00ccffExp gained in this Segment: |r" .. splitXP)
		segments[run].segtime = str:format(dt)
		segments[run].xpgain = splitXP
		run = run+1			--for next run segment
		running = 0			--sets run to inactive
		splitXP = 0	--resets XP
	else 
		running = 1			--sets run to active
		local runone = {stoptime = 0} --Breaktime initialized 
		runone.comment = cmt	--Optional Comment for Segment, added after the start command.
		runone.t1 = GetTime()	--Servertime in seconds when the run is startet.
		table.insert(segments, runone)	--Add run segment in data table
		
		print("|cff00ff00Segment No. |r" .. #segments .. "|cff00ff00 startet!|r")
	end
end




---------
---SLASH COMMANDS


SLASH_LVLZACKIG_GO1 = "/lvlgo"	--slash command 1 to start / end a segment
SLASH_LVLZACKIG_GO2 = "/zack"	--slash command 2 to start / end a segment	
SlashCmdList["LVLZACKIG_GO"] = function(cmt)	--function for start / end slash command

	if running == 1 then
		segments[run].t2 = GetTime()
		local dt = segments[run].t2-(segments[run].t1+segments[run].stoptime)          
		local str = "%.1f";
		print("|cff00ccffSegment |r" .. #segments .. "|cff00ccff ended after |r" .. str:format(dt) .. "|cff00ccff seconds. Comment: |r" .. segments[run].comment)
		print("|cff00ccffExp gained in this Segment: |r" .. splitXP)
		segments[run].segtime = str:format(dt)
		segments[run].xpgain = splitXP
		run = run+1			--for next run segment
		running = 0			--sets run to inactive
		splitXP = 0	--resets XP
	else 
		running = 1			--sets run to active
		local runone = {stoptime = 0} --Breaktime initialized 
		runone.comment = cmt	--Optional Comment for Segment, added after the start command.
		runone.t1 = GetTime()	--Servertime in seconds when the run is startet.
		table.insert(segments, runone)	--Add run segment in data table
		
		print("|cff00ff00Segment No. |r" .. #segments .. "|cff00ff00 startet!|r")
	end
end



SLASH_LVLZACKIG_BREAK1 = "/lvlbreak"
SlashCmdList["LVLZACKIG_BREAK"] = function()
	if running == 1 then
		running = 2
		pause.t1 = GetTime()	--Time at start of break.
		print("|cffFF4500Segment |r" .. #segments .."|cffFF4500 stopped. Time for a Beer!|r")
	elseif running == 2 then
		running = 1
		pause.t2 = GetTime()	--Time at end of break.
		local pausetime = (pause.t2-pause.t1)
		segments[run].stoptime = segments[run].stoptime+pausetime
		local str = "%.1f";
		print("|cffFF4500Break ended after |r" .. str:format(pausetime) .. "|cffFF4500 seconds|r")
	else 
		print("|cffff0000 No running segment!|r")
	end
end



SLASH_LVLZACKIG_RESET1 = "/lvlreset"
SlashCmdList["LVLZACKIG_RESET"] = function()
    segments = {}
    running = 0
    run = 1
    splitXP = 0
end


SLASH_LVLZACKIG_PRINT1 = "/lvlprint"
SlashCmdList["LVLZACKIG_PRINT"] = function()
	print(segments[1].segtime)
	
	for i=1,#segments do
	    if segments[i].segtime == nil then
	        segments[i].segtime = "NOTSET"
        end
	   if segments[i].xpgain == nil then
	        segments[i].xpgain = "NOTSET"
        end
	    print(" |cffDA70D6Segment |r" .. i .. " |cffDA70D6 took |r" .. segments[i].segtime .. "|cffDA70D6 seconds and gained |r" .. segments[i].xpgain .. " |cffDA70D6 Exp. Comment: |r" .. segments[i].comment)
	end
end



SLASH_LVLZACKIG_COMMENT1 = "/lvlcmt"
SlashCmdList["LVLZACKIG_COMMENT"] = function(comm)
	local seg, text = comm:match("(%d+)%s+(.+)")
	if seg and text then
		seg = tonumber(seg)	--converts the string called seg into a integer called seg
		segments[seg].comment = text
		print(text .. "|cffCD661D was added as a comment to segment |r" .. seg)
	else 
		print("Error: Enter command as: /lvlcmt <SEGMENT NUMBER> <COMMENT>")
	end	
end


SLASH_LVLZACKIG_HELP1 = "/lvlhelp"
SlashCmdList["LVLZACKIG_HELP"] = function()
	print("/lvlgo or /zack is used to start and end a segment.")
	print("/lvlbreak stops the timer of the run. Please not that the XP gain is running on!")
	print("/lvlreset deletes all stored data. Might be handy in case of a bug a well.")
	print("/lvlprint prints all stored segments including time and XP gain.")
	print("/lvlcmt <SEGMENT NUMBER> <COMMENT>  can be used to add a comment / change an existing comment to a certain segment. Currently bugged.")
end

	
	
	
	




