# Create source
# José María Lahoz-Bengoechea (jmlahoz@ucm.es)
# Version 2021-10-06

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

# This script creates a glottal source.

form Create source...
positive duration 0.500
positive initial_pitch 150
positive final_pitch 100
natural sampling_frequency 44100
positive adaptation 0.6
positive maximum_period 0.050
positive open_phase 0.7
positive collision_phase 0.03
positive power1 3.0
positive power2 4.0
endform

pitchTier = Create PitchTier... source 0 'duration'
Add point... 0 'initial_pitch'
Add point... 'duration' 'final_pitch'
pulses = To PointProcess
Remove points between... 0 0.02
Remove points between... 'duration'-0.02 'duration'
source = To Sound (phonation)... 'sampling_frequency' 'adaptation' 'maximum_period' 'open_phase' 'collision_phase' 'power1' 'power2'
select pitchTier
plus pulses
Remove
select source