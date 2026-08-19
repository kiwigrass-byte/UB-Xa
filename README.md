# Summary
Building an Electra One mk2 preset for the Behringer UB-Xa synth. This repository is for iterations of the lua code. 

UB-Xa v3 published 8/16/26

UB-Xa v4 published 8/18/26

UB-Xa v4.1 published 8/19/26

[Latest version] (https://app.electra.one/preset/nVbPHKdqN1K0JLBvJ1XK)

<img width="1003" height="718" alt="image" src="https://github.com/user-attachments/assets/a248d916-3998-4e95-a48c-f366de079591" />

## Behringer UB-Xa NewIgnis 10/2024

Updated by kiwigrass August 2026

Version 4.1
- *Requires UB-Xa firmware version 3.124*

- *MODEL_BYTE = 0x21 (desktop model) by default. Change top of lua code to MODEL_BYTE = 0x3A if you have the keyboard version.*

- *Make sure the UB-Xa is set to transmit and receive NRPNs.*
---
## What's new
- The preset should automatically detect the upper and lower part's midi transmit channels from the UB-Xa. 

- Various global settings are parsed when the preset is first loaded. This can also be triggered by pressing the **GLOBALS** button. The 512 patch names are also parsed on load. The names are displayed when scrolling the **PATCH** number fader. Parsing all the patch names takes a few seconds to complete (it is 8192 bytes of data) so be patient. The patch names can also be retrieved by pressing the **PATCH NAMES** button.

- If the **PATCH MODE** control is on Single then a patch is loaded on the synth and parsed when a **PATCH SELECT** button is pressed. After parsing, the patch name appears in bottom right corner of screen.

- The atrophy profile saved in the patch is loaded automatically when a patch is parsed. A stored atrophy profile is parsed when selected from the **PROFILE NUMBER** control. 

- 35 stored Double (Split) profiles (patch names and associated performance panel settings) are parsed when the **PATCH MODE** control is on Double (Split). After selecting one of the Double (Split) profiles use the **SELECT** button to load that profile on the synth. The **PART** control determines which of the two parts is parsed.

- You can send a patch to an active Double (Split) profile using the **PATCH SELECT** controls. 

## What's in the preset
- Controls **all** parameters of a patch. Also, responds to most parameter changes on the synth.

- Controls ARP and SEQ parameters of both parts.  

- There are options added for 3 types of pre-defined voice panning controls, and a panning width control that scales the extent of panning (thank you @NewIgnis!).

- Performance controls for 35 Doubles and 35 Split patch combinations.

- **White** controls are send-only settings. They could not be parsed.

- **Dark blue** controls are Global settings. 

- **Bright Green** controls are Atrophy Profile settings.

- Unless it is very obvious, dark blue global controls and **grey** shift patch controls display a help text in the lower right corner upon touch, showing where to find them on the UB-Xa. Bright green atrophy controls display the atrophy parameter number when touched.

## Notes: 
- The Double/Split mode and the Upper/Lower panel controls on the UB-Xa panel can not be controlled remotely. To use the Double (Split) features of the preset you need to enter the mode on the synth first. 

- Currently, only one part's ARP and SEQ settings are parsed at a time. But both parts can be simultaneously controlled.

- The sequencer start/stop control only works when the synth is using an external clock.

- The oscillator frequency adjustments are a function of the quantification type. The frequency parameter is 14-bit. For octave changes, turning the knob does not provide very precise control since it involves large MIDI value jumps. I have found it better to use the touch screen. 

- In early testing the preset occasionally tripped up while parsing the large sysEx dumps. Sometimes this could be fixed by manually triggering the requests again. However, sometimes I have to reboot the controller. It seems to have been more stable since version 3 parsing code improvements. I am connected to the UB-Xa via a mioXL midi interface. The Electra One is connected via DIN and the UB-Xa is connected via USB.

## References
[Guide_UB-Xa D_2024_09-06_Rev.1.1.pdf]

[UB-Xa D manual.pdf]

[Electra One Lua API] (https://docs.electra.one/developers/luaext.html)
