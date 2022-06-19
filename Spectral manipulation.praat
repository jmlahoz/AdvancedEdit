# Spectral manipulation (TextGrid)
# José María Lahoz-Bengoechea (jmlahoz@ucm.es)
# Version 2021-10-07

# LICENSE
# (C) 2021 José María Lahoz-Bengoechea
# This file is part of the plugin_AdvancedEdit.
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation
# either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# For more details, you can find the GNU General Public License here:
# http://www.gnu.org/licenses/gpl-3.0.en.html
# This file runs on Praat, a software developed by Paul Boersma
# and David Weenink at University of Amsterdam.


# This script modifies formant and bandwith values for a selected portion of a sound.
# Target values are pre-built for some Spanish sounds (liquids and vowels).
# Alternatively, modifications can be entered manually.
# Formant values are expressed as a shift from original (i.e. either an addition or substraction in Hz, depending on the sign).
# Bandwith values are expressed as a factor of original (i.e. they multiply, so 1 leaves Bn as is, 0.5 reduces it to half, etc.).
# Manipulation may cause an undesired increase of the bandwidths, so a factor of 0.8 is suggested to restore them.
# The sound will be created as a new object.

# This is an Editor script.

include utils.praat

form Spectral manipulation...
choice sex 1
button Male
button Female
choice target_sound 1
button r
button l
button a
button e
button i
button o
button u
button manual change
real f1_shift 0
real b1_factor 1
real f2_shift 0
real b2_factor 1
real f3_shift 0
real b3_factor 1
real f4_shift 0
real b4_factor 1
endform

# Sex-dependent parameters
if sex = 1
fs = 20000
npoles = 9
max_formant = 6000
nformants = 6
else
fs = 20000
npoles = 8
max_formant = 6500
nformants = 6
endif

# Pre-built values for Spanish liquids
if target_sound = 1
newf1 = 480
newf2 = 1700
newf3 = 2900
newf4 = 3800
elsif target_sound = 2
newf1 = 300
newf2 = 1515
newf3 = 2570
newf4 = 3700
endif

# Pre-built values for Spanish vowels
if sex = 1
if target_sound = 3
newf1 = 699
newf2 = 1471
newf3 = 2568
newf4 = 3507
elsif target_sound = 4
newf1 = 457
newf2 = 1926
newf3 = 2674
newf4 = 3597
elsif target_sound = 5
newf1 = 200
newf2 = 2300
newf3 = 2950
newf4 = 3723
elsif target_sound = 6
newf1 = 450
newf2 = 850
newf3 = 2602
newf4 = 3413
elsif target_sound = 7
newf1 = 320
newf2 = 580
newf3 = 2436
newf4 = 3494
endif
elsif sex = 2
if target_sound = 3
newf1 = 886
newf2 = 1400
newf3 = 2605
newf4 = 3800
elsif target_sound = 4
newf1 = 576
newf2 = 1900
newf3 = 2600
newf4 = 3737
elsif target_sound = 5
newf1 = 300
newf2 = 2300
newf3 = 3200
newf4 = 3665
elsif target_sound = 6
newf1 = 600
newf2 = 1000
newf3 = 2709
newf4 = 3809
elsif target_sound = 7
newf1 = 350
newf2 = 900
newf3 = 2471
newf4 = 3730
endif
endif

ini = Get start of selection
end = Get end of selection
if ini = end
exit Select portion to manipulate
endif

@getinfo: 1
endeditor

@selobj: 1, 0
original_fs = Get sampling frequency

# Inverse filtering
downsample = noprogress Resample... 'fs' 50
lpc = noprogress To LPC (burg)... 'npoles' 0.025 0.005 50
select downsample
plus lpc
source = noprogress Filter (inverse)
Rename... source

@selobj: 1, 0
formant = noprogress To Formant (burg)... 0.005 nformants max_formant 0.025 50
pini = Get frame number from time... ini
pini = round(pini)
pend = Get frame number from time... end
pend = round(pend)

# Get formant shift as a function of original and pre-built target values
if target_sound != 8
mid = ('ini' + 'end')/2
f1 = Get value at time... 1 'mid' Hertz Linear
f2 = Get value at time... 2 'mid' Hertz Linear
f3 = Get value at time... 3 'mid' Hertz Linear
f4 = Get value at time... 4 'mid' Hertz Linear
f1_shift = 'newf1' - 'f1:0'
f2_shift = 'newf2' - 'f2:0'
f3_shift = 'newf3' - 'f3:0'
f4_shift = 'newf4' - 'f4:0'
b1_factor = 1
b2_factor = 1
b3_factor = 1
b4_factor = 1
endif

filter = Down to FormantGrid

Formula (frequencies)... if row = 1 then if col > pini then if col < pend then self + f1_shift else self fi else self fi else self fi
Formula (frequencies)... if row = 2 then if col > pini then if col < pend then self + f2_shift else self fi else self fi else self fi
Formula (frequencies)... if row = 3 then if col > pini then if col < pend then self + f3_shift else self fi else self fi else self fi
Formula (frequencies)... if row = 4 then if col > pini then if col < pend then self + f4_shift else self fi else self fi else self fi

if target_sound = 8
Formula (bandwidths)... if row = 1 then if col > pini then if col < pend then self * b1_factor else self fi else self fi else self fi
Formula (bandwidths)... if row = 2 then if col > pini then if col < pend then self * b2_factor else self fi else self fi else self fi
Formula (bandwidths)... if row = 3 then if col > pini then if col < pend then self * b3_factor else self fi else self fi else self fi
Formula (bandwidths)... if row = 4 then if col > pini then if col < pend then self * b4_factor else self fi else self fi else self fi
endif


# Once our filter is set up, we use it to filter the previously extracted source
select source
plus filter
sofiltered = noprogress Filter
resample = noprogress Resample... 'original_fs' 50
Rename... Spectral_Manipulation 'data_name$'


# Clean workspace
select downsample
plus lpc
plus source
plus formant
plus filter
plus sofiltered
nocheck plus socopy
Remove

# Show results
select resample
if data_type$ = "TextGrid"
plus tg
endif
View & Edit


