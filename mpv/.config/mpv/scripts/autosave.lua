-- autosave.lua
--
-- Adapted from https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef
--
-- Saves a watch later config if the video has been paused for more than 1 minute.
--
-- Does not save in the first/last 30 seconds of the file.
--
-- Also clears watch later on clean exit.
-- This lets you easily recover your position in the case of an ungraceful shutdown of mpv (crash, power failure, etc.).
local save_delay = 60 * 1

local mp = require 'mp'

local save_timer = nil

local function stop()
  if save_timer ~= nil then
    save_timer:stop()
    save_timer = nil
  end
end

local function save()
  stop()

  local elapsed = mp.get_property_native("time-pos")

  if elapsed < 30 then
    return
  end

  local remaining = mp.get_property_native("time-remaining")

  if remaining < 30 then
    return
  end

  mp.commandv("set", "msg-level", "cplayer=warn")
  mp.command("write-watch-later-config")
  mp.commandv("set", "msg-level", "cplayer=status")
end

local function loaded()
  -- At least for my setup, starting paused almost always means this was resumed
  local paused = mp.get_property_native("pause")

  if paused then
    save()
  else
    stop()
  end
end

mp.register_event("file-loaded", loaded)

local function pause(name, paused)
  if paused then
    if save_timer == nil then
      save_timer = mp.add_timeout(save_delay, save)
    end
  else
    stop()
    mp.command("delete-watch-later-config")
  end
end

mp.observe_property("pause", "bool", pause)

local function end_file(data)
  stop()

  if data.reason == 'eof' or data.reason == 'stop' then
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


local function quit_cleanup()
  mp.command("delete-watch-later-config")
  mp.command("quit")
end

mp.add_key_binding("q", "quit_cleanup", quit_cleanup)
