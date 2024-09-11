-- autosave.lua
--
-- Adapted from https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef
--
-- Saves a watch later config if the video has been paused for more than 5 minutes.
-- Also clears watch later on clean exit.
-- This lets you easily recover your position in the case of an ungraceful shutdown of mpv (crash, power failure, etc.).
local save_delay = 60 * 5

local mp = require 'mp'

local save_timer = nil

local function save()
  if save_timer ~= nil then
    save_timer = nil
  end

  mp.commandv("set", "msg-level", "cplayer=warn")
  mp.command("write-watch-later-config")
  mp.commandv("set", "msg-level", "cplayer=status")
end

local function pause(name, paused)
  if paused then
    if save_timer == nil then
      save_timer = mp.add_timeout(save_delay, save)
    end
  elseif save_timer ~= nil then
    save_timer:stop()
    save_timer = nil
  end
end

mp.observe_property("pause", "bool", pause)

local function end_file(data)
  if data.reason == 'eof' or data.reason == 'stop' then
    if save_timer ~= nil then
      save_timer:stop()
      save_timer = nil
    end

    local playlist = mp.get_property_native('playlist')
    for i, entry in pairs(playlist) do
      if entry.id == data.playlist_entry_id then
        mp.commandv("delete-watch-later-config", entry.filename)
        return
      end
    end
  end
end
mp.register_event("end-file", end_file)

local function cleanup()
  mp.commandv("delete-watch-later-config")
end

mp.register_event("shutdown", cleanup)
