--[[
name: Variable-hardness clipping
author: Laurent de Soras / J.R.
url: http://musicdsp.org/showone.php?id=104
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
    	
        local x = samples[i] * (1/gain)
        local neg = 1
        if (x<0) then neg = -1; x = -x; end
              
        x = math.pow (math.atan (math.pow (math.abs (x), power)), (1 / power)) * gain * gain2      
              
        if (x>1) then x=1; end

        samples[i] = x * neg * mix + samples[i] * (1-mix)
  
    end
end

params = plugin.manageParams {
    {
        name = "Strength";
        min = 1;
        max = 1000;
        changed = function (val) power = val; end;
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
        max = 2;
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
