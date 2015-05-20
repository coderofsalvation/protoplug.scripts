--[[
name: Soft clipping 1
author: J.R.
--]]
require "include/protoplug"

local power
local gain
local gain2
local mix

stereoFx.init ()
function stereoFx.Channel:init ()
    -- create per-channel fields (filters)
end

function stereoFx.Channel:processBlock (samples, smax)
    for i = 0, smax do
    	
        local s = samples[i] * (1/gain)
        local neg = 1
        if (s<0) then neg = -1; s = -s; end
        
        if (s>1) then s=1; end
              
        s = (s - (s^power/power)) * (power / (power-1))* gain * gain2
        samples[i] = s * neg * mix + samples[i] * (1-mix)
 
    end
end

params = plugin.manageParams {
    {
        name = "Strength";
        min = 1;
        max = 100;
        changed = function (val) power = 100.01/(val); end;
    };
    {
        name = "Threshold";
        min = 0;
        max = 1;
        changed = function (val) gain = (1-(val*0.99)); end;
    };
    {
        name = "Gain";
        min = 0;
        max = 1;
        default = 1;
        changed = function (val) gain2 = val; end;
    };
    {
        name = "Mix";
        min = 0;
        max = 100;
        default = 100;
        changed = function (val) mix = val*0.01; end;
    };
}
