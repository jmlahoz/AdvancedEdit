# Add silence after cursor
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

# This script adds a silence after the cursor or after the end of the selection.
# Silence length is specified by the user.
# This is a Sound Editor script.

include auxiliary.praat

form Add silence after cursor...
positive length 0.015
endform

# Get cursor
t = Get end of selection

@getinfo: 0
endeditor

@selobj: 1, 0
nchan = Get number of channels
fs = Get sampling frequency

# Create silence
if nchan = 1
sil = Create Sound from formula... sil Mono 0 'length' 'fs' 0
elsif nchan = 2
sil = Create Sound from formula... sil Stereo 0 'length' 'fs' 0
endif

# Shift to Editor window (silence), and copy silence
View & Edit
editor Sound sil
Select... 0 'length'
Copy selection to Sound clipboard
endeditor

# Shift to Editor window (original), and paste silence
select so
editor Sound 'data_name$'
Move cursor to... 't'
Paste after selection
endeditor

# Remove silence object
select sil
Remove

# Restore workspace
@restorews
