-- Toggle redshift when viewing videos with mpv
-- When pausing redshift is reenabled (and disabled again when continuing)
-- Uses the redshift-toggle script so that it still remains somewhat usable if multiple mpv instances run or somethign else changes the state.

function rs_disable()
    mp.msg.log("info", "Disabling redshift")
    os.execute("redshift-toggle false")
end

function rs_enable()
    mp.msg.log("info", "Reenabling redshift")
    mp.msg.log("info", "Disabling redshift")
    os.execute("redshift-toggle true")
end

function rs_handler()
    if mp.get_property("video") ~= "no" then
        rs_disable()
    else
        rs_enable()
    end
end


function on_pause_change(name, value)
    if value then  --pause started
        rs_enable()
    else
        rs_disable()
    end
end


mp.register_event("file-loaded", rs_handler)
mp.register_event("shutdown", rs_enable)
mp.observe_property("pause", "bool", on_pause_change)
