# Create filter
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

# This script creates a FormantGrid to be used as a filter for a source.

form Create filter...
positive duration 0.500
natural n_formants 10
positive initial_f1 550
positive formant_spacing 1100
positive initial_b1 60
positive bandwith_spacing 50
real new_f1_value 0
real new_f2_value 0
real new_f3_value 0
real new_f4_value 0
real new_f5_value 0
endform

filter = Create FormantGrid... filter 0 'duration' 'n_formants' 'initial_f1' 'formant_spacing' 'initial_b1' 'bandwith_spacing'

for i from 1 to 5
if new_f'i'_value != 0
new_value = new_f'i'_value
Remove formant points between... 'i' 0 'duration'
Add formant point... 'i' 0 'new_value'
endif
endfor
