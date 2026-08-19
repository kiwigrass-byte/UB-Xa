-- parse a current program dump
function currentProgram(dump)
  -- parse of the incoming dump
  local result = parse_sysex(dump)
  if not result or type(result.data) ~= "table" then
    print("Could not read data")
    return
  end
  local data = result.data
  local mode = parameterMap.get(deviceId, PT_VIRTUAL, PATCH_MODE)
  local part = parameterMap.get(deviceId, PT_VIRTUAL, PART_NUMBER)
  local jj = 0
  -- offset by 739 if parsing lower part
  if part == 1 then jj = 739 end
  for i = 1479,#data do 
    print("current program: current performance values: ".. i .. ": " .. data[i])
  end

  for i = 672,685 do 
    print("current program: stored upper performance values: ".. i .. ": " .. data[i])
  end

  for i = 672+739,685+739 do 
    print("current program: stored lower performance values: ".. i .. ": " .. data[i])
  end

  -- print patch name to screen
  local param2 = {}  -- store 2 byte parameters
  local idx = 1
  for i = 1,77,2 do -- 2-byte parameters - parameter value is located in the 2nd byte of pair
    param2[idx] = data[i+jj+1]
--    print("patch: 2nd 2-byte parameter " .. idx .. ": " .. data[i+1])
    idx = idx+1
  end
  -- Assign the 39 2-byte parameters. Multiple 0-255 range parameters by 64 to scale to the 0-16383 (14-bit) range of nrpn
  -- The result doesn't always exactly match the UB-Xa because the range of a 2-byte parameter is actually 0-65535 (16-bit)
  local paramList = {0,1,2,3,128,256,257,258,259,260,384,385,386,387,388,389,390,391,392,393,394,395,396,
                  512,513,514,515,640,641,642,643,768,770,772,774,769,771,773,775}
  for i = 1,39 do
    parameterMap.updateValue (deviceId, PT_NRPN, paramList[i], param2[i]*64) 
  end
  -- Assign remaining patch parameters. Some are bitmasked and treated separately. Some PLFO settings are 2-byte
  local mappings = {
    {4, 95},      -- unison mode toggle 
    {5, 96},      -- poly voice #
    {6, 97},      -- unison voice #
    -- { , 98},   -- ?? (skipped)
    {11, 99},     -- portamento spread
    {12, 100},     -- portamento range
    {262, 102},    -- LFO shape
    {533, 110},   -- Osc FEnv range
    {518, 112},   -- Osc1 shape
    {535, 113},   -- (Osc1 quantize) ??
    {519, 114},   -- Osc2 level
    {520, 115},   -- Osc2 shape
    {536, 116},   -- Osc2 quantize
    {525, 117},   -- Osc1 lfo amount
    {534, 118},   -- Osc2 lfo amount
    {526, 119},   -- Osc1 pwm lfo amount
    {537, 120},   -- Osc2 pwm lfo amount
    {664, 122},   -- Range of filter tracking
    {650, 123},   -- Range of filter envelope
    {647, 124},   -- Range of filter frequency
    {653, 125},   -- Range of filter LFO
    {657, 126},   -- Range of filter pedal
    {776, 127},   -- mod source 1
    {777, 128},   -- mod dest 1
    {780, 129},   -- mod source 2
    {781, 130},   -- mod dest 2
    {784, 131},   -- mod source 3
    {785, 132},   -- mod dest 3
    {788, 133},   -- mod source 4
    {789, 134},   -- mod dest 4
    {778, 135},   -- mod source 5
    {779, 136},   -- mod dest 5
    {782, 137},   -- mod source 6
    {783, 138},   -- mod dest 6
    {786, 139},   -- mod source 7
    {787, 140},   -- mod dest 7
    {790, 141},   -- mod source 8
    {791, 142},   -- mod dest 8
    {913, 152},   -- Atrophy preference
    {1152, 153},  -- patch midi transpose
-- (154 is RFU)    
    {2056, 155},  -- VCA LFO Amount

-- atrophy patch parameters
    {138, 686},  -- max speed of main mod LFO
    {267, 687},  -- max speed of performance LFO
    {268, 688},  -- OB-8 quairks (bitmasked)
    {521, 689},  -- Osc1 PW left trim
    {522, 690},  -- Osc1 PW right trim
    {523, 691},  -- Osc2 PW left trim
    {524, 692},  -- Osc2 PW right trim
    {527, 693},  -- PWM offset
    {528, 694},  -- osc drift
    {529, 695},  -- osc vol/oct error 
    {530, 696},  -- osc drift speed
    {531, 697},  -- osc vol/oct chaos !!WRONG!!!
    {532, 698},  -- osc initial freq
    {645, 699},  -- 2-pole resonance trim
    {646, 700},  -- 4-pole resonance trim
    {648, 701},  -- 2-pole floor
    {649, 702},  -- 4-pole floor
    {665, 703},  -- filter env attack linearity      
    {666, 704},  -- filter env decay linearity
    {652, 705},  -- filter env chaos
    {654, 706},  -- filter drift
    {655, 707},  -- filter drift speed
    {656, 708},  -- filter track offset
    {658, 709},  -- filter v/oct error
    {659, 710},  -- filter v/oct drift
    {660, 711},  -- filter initial freq
    {2049, 712},  -- VCA bias 2p filter
    {2050, 713},  -- VCA bias unison bias
    {2051, 714},  -- VCA bias master
    {2054, 715},  -- VCA attack linearity
    {2055, 716},  -- VCA decay linearity
    {2053, 717},  -- VCA env chaos
    {2176, 718},  -- per voice pan settings - 01
    {2177, 719},  -- per voice pan settings - 02
    {2178, 720},  -- per voice pan settings - 03
    {2179, 721},  -- per voice pan settings - 04
    {2180, 722},  -- per voice pan settings - 05
    {2181, 723},  -- per voice pan settings - 06
    {2182, 724},  -- per voice pan settings - 07
    {2183, 725},  -- per voice pan settings - 08
    {2184, 726},  -- per voice pan settings - 09
    {2185, 727},  -- per voice pan settings - 10
    {2186, 728},  -- per voice pan settings - 11
    {2187, 729},  -- per voice pan settings - 12
    {2188, 730},  -- per voice pan settings - 13
    {2189, 731},  -- per voice pan settings - 14
    {2190, 732},  -- per voice pan settings - 15
    {2191, 733},  -- per voice pan settings - 16
    {2304, 734},  -- Atrophy profile name character 1
    {2305, 735},  -- Atrophy profile name character 2
    {2306, 736},  -- Atrophy profile name character 3
    {2307, 737},  -- Atrophy profile name character 4
    {2308, 738},  -- Atrophy profile name character 5
    {2309, 739},  -- Atrophy profile name character 6
  }
  -- Batch assign parameters
  for _, m in ipairs(mappings) do
    parameterMap.updateValue (deviceId, PT_NRPN, m[1], data[m[2]+jj])
  end
  -- Assign bit masked groups
  local mappings = {
    {{37,38,39,40}, 101},                 -- 261 LFO modulation
    {{50,51,27}, 103},                    -- 263 CH1 LFO destinations
    {{30,31}, 104},                      -- 264 CH1 quant/invert
    {{33,35,44}, 105},                   -- 265 CH2 LFO destinations
    {{49,46}, 106},                      -- 266 CH2 quant/invert
    {{136,137,138,139,140}, 107},        -- 397 Filter env mods
    {{141,142,143,144,145}, 108},        -- 398 VCA env mods
    {{2,9}, 109},                        -- 516 OSC2 modes
    {{3,154,155}, 111},                  -- 517 Osc1 state
    {{76,89}, 121},                      -- 644 Filter key track and mode
  }
  for _, m in ipairs(mappings) do
    pset(m[1],data[m[2]+jj])
  end
  -- Assign upper patch ARP and sequencer parameters to upper device
  local mappings = {
    {1024, 143},  -- ARP enable
    {1025, 144},  -- ARP mode
    {1026, 145},  -- ARP hold
    {1027, 146},  -- ARP time
    {1028, 147},  -- ARP gate length
    {1029, 148},  -- ARP sync
    {1030, 149},  -- ARP octave range
    {2432, 668},  -- seq # steps
    {2433, 669},  -- seq time 
    {2434, 670},  -- seq gate length
    {2435, 671},  -- seq sync
  }
  for _, m in ipairs(mappings) do
    parameterMap.updateValue(deviceId, PT_NRPN, m[1], data[m[2]+jj])
  end

  print("Patch Mode = ".. mode)
  -- order: LFP modes,kybd split, panel settings, PB range, transpose, lfo rate, shape, depth 
  if mode == 0 then
    -- use patch performance settings
    local mappings = {
      {130, 677},  -- Performance pitch bend range (/64)
      {131, 679},  -- Performance octave pitch transpose (/64)
      {132, 681},  -- Performance LFO rate (/64)
      {134, 685},  -- Performance LFO depth (/64) ??
    }
    for _, m in ipairs(mappings) do
      parameterMap.set(deviceId, PT_NRPN, m[1], data[m[2]+jj]*64)
    end
    local mappings = {
      {1280, 673},  -- Performance keyboard split point
      {133, 682},  -- Performance LFO shape
    }
    for _, m in ipairs(mappings) do
      parameterMap.set(deviceId, PT_NRPN, m[1], data[m[2]+jj])
    end
    local mappings = {
      {{115,117,118,119}, 672},            -- 135 Performance LFO mods
      {{8,10,19,97,103,109}, 674},         -- 129 Performance panel settings
    }
    for _, m in ipairs(mappings) do
      pset(m[1],data[m[2]+jj])
    end
  elseif mode > 0 then
    -- use split/double performance settings located at last 14 bytes of data
    local mappings = {
      {130, 1484},  -- Performance pitch bend range (/64)
      {131, 1486},  -- Performance octave pitch transpose (/64)
      {132, 1488},  -- Performance LFO rate (/64)
      {134, 1492},  -- Performance LFO depth (/64) ??
    }
    for _, m in ipairs(mappings) do
      parameterMap.set(deviceId, PT_NRPN, m[1], data[m[2]]*64)
    end
    -- 1 byte performance parameters
    local mappings = {
      {1280, 1480},  -- Performance keyboard split point
      {133, 1489},  -- Performance LFO shape
    }
    for _, m in ipairs(mappings) do
      parameterMap.set(deviceId, PT_NRPN, m[1], data[m[2]])
    end
    -- bit masked performance parameters
    local mappings = {
      {{115,117,118,119}, 1479},            -- 135 Performance LFO mods
      {{8,10,19,97,103,109}, 1481},         -- 129 Performance panel settings
    }
    for _, m in ipairs(mappings) do
      pset(m[1],data[m[2]])
    end
  end
  patchName = get_patch_name(data,79+jj) -- update patchName (starts at byte 79 of data)
  if part == 0 then
    patchName = "U "..patchName
  elseif part == 1 then 
    patchName = "L "..patchName
  end
  info.setText(patchName)
  local atrophyName = get_atrophy_name(data,734+jj) -- name of the patch atrophy profile (starts at byte 734 of data)
  controls.get (426):setName(atrophyName)  -- display current atrophy profile name
  print("Patch name: ".. patchName)
  print("Patch Atrophy name: ".. atrophyName)
  print("Patch settings parsed. Number of bytes: ".. #data.. " on MIDI channel: "..currentChannel)
  print("current program settings parsed. Number of bytes: ".. #data)
end
