# Filter (inverse)
# José María Lahoz-Bengoechea (jmlahoz@ucm.es)
# Version 2022-07-01

# LICENSE
# (C) 2022 José María Lahoz-Bengoechea
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

# This script calculates formants and applies an inverse filter in order to obtain the original glottal source.


form Filter (inverse)...
choice sex 1
button Male
button Female
endform

if sex = 1
fs = 10000
else
fs = 11000
endif

data_name$ = selected$("Sound")
downsample = noprogress Resample... fs 50
lpc = noprogress To LPC (burg)... 10 0.025 0.005 50

select downsample
plus lpc
source = noprogress Filter (inverse)
source = Formula... -self
Rename... 'data_name$' source

select downsample
plus lpc
Remove
select source
