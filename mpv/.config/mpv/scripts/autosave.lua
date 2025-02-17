-- autosave.lua
--
-- Adapted from https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef
--
-- Saves a watch later config and updates it every 60 seconds and every time the video is paused for > 10 seconds.
--
-- Also clears watch later on clean exit.
-- This lets you easily recover your position in the case of an ungraceful shutdown of mpv (crash, power failure, etc.).
local save_period = 60 * 1
local pause_delay = 10 * 1

local mp = require 'mp'


local function save()
  -- Do not save in the first 30 seconds of the file.
  -- local elapsed = mp.get_property_native("time-pos")
  --
  -- if elapsed < 30 then
  --   return
  -- end

  -- Do not save in the last 30 seconds of the file.
  -- local remaining = mp.get_property_native("time-remaining")
  --
  -- if remaining < 30 then
  --   mp.command("delete-watch-later-config")
  --   return
  -- end

  mp.commandv("set", "msg-level", "cplayer=warn")
  mp.command("write-watch-later-config")
  mp.commandv("set", "msg-level", "cplayer=status")
end

local pause_timer = mp.add_timeout(pause_delay, save, true)
local save_period_timer = mp.add_periodic_timer(save_period, save)

local function loaded()
  -- At least for my setup, starting paused almost always means this was resumed
  local paused = mp.get_property_native("pause")

  save()
  pause_timer:kill()
  save_period_timer:kill()

  if not paused then
    save_period_timer:resume()
  end
end

mp.register_event("file-loaded", loaded)

local function pause(name, paused)
  if paused then
    pause_timer:resume()
    save_period_timer:stop()
  else
    pause_timer:kill()
    save_period_timer:resume()
  end
end

mp.observe_property("pause", "bool", pause)

local function end_file(data)
  pause_timer:kill()

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
