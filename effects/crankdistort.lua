--[[
name: Crank Distortion
author: J.R.
--]]
require "include/protoplug"

local power
local threshold
local gain
local mix

stereoFx.init ()
function stereoFx.Channel:init ()
    -- create per-channel fields (filters)
end

function stereoFx.Channel:processBlock (samples, smax)
    for i = 0, smax do
        local s = samples[i]
        local neg = 1
        if (s<0) then neg = -1; s = -s; end
        
        if (s < threshold) then s = s^power
        else s = s^(1/power)
        end
        
        samples[i] = s * gain * neg * mix + samples[i] * (1-mix)
    end
end

params = plugin.manageParams {
    {
        name = "Power";
        min = 1;
        max = 0.01;
        changed = function (val) power = val end;
    };
    {
        name = "Character";
        min = 0;
        max = 1;
        changed = function (val) val = 1-val;threshold = (val*val*val*val) end;
    };
    {
        name = "Gain";
        min = 0;
        max = 1;
        changed = function (val) gain = val end;
    };
    {
        name = "Mix";
        min = 0;
        max = 100;
        default = 100;
        changed = function (val) mix = val*0.01; end;
    };
}
