# Remove tiers
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

# This script will show an ordered list with the names of the different tiers in a TextGrid
# so that the user can choose which tiers they want to remove (you can delete several tiers at once).

include utils.praat

@getinfo: 0

endeditor

@selobj: 0, 1

ntier = Get number of tiers
for itier from 1 to ntier
tier'itier'$ = Get tier name... 'itier'
tier'itier'$ = replace$(tier'itier'$,"/","",0)
endfor

beginPause: "Remove tiers..."
for itier from 1 to ntier
tiername$ = tier'itier'$
boolean: "remove_'tiername$'",0
endfor
endPause: "OK",1

for itier from 1 to ntier
tiername$ = tier'itier'$
if remove_'tiername$' = 1
call findtierbyname 'tiername$' 1 0
tierID = findtierbyname.return
Remove tier... tierID
endif
endfor

@restorews
