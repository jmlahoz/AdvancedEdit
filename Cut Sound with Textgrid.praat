# Cut Sound with TextGrid
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

# This script allows to cut a sound when in the TextGrid Editor. The accompanying TG will be cut accordingly.
# The resulting sound and TG will be created as new objects.
# This is an Editor script.

include utils.praat

ini = Get start of selection
if ini = 0
ini = 0.001
endif
end = Get end of selection
cut_dur = end - ini

if ini = end
exit Select portion to delete
endif

@getinfo: 1
endeditor

@selobj: 1, 0
sostart = Get start time
soend = Get end time
so1 = Extract part... sostart ini rectangular 1 no
select socopy
so2 = Extract part... end soend rectangular 1 no
select so1
plus so2
sonew = Concatenate

@selobj: 0, 1
tg1 = Extract part... editor_start ini yes
if end = editor_end
end = end - 0.001
cut_dur = end - ini
endif
extension1 = editor_end - end
Extend time... extension1 End
@selobj: 0, 1
tg2 = Extract part... end editor_end yes
Shift times by... -cut_dur
extension2 = ini - editor_start
Extend time... extension2 Start

select tg2
ntiers = Get number of tiers
for itier from 1 to ntiers
@selobj: 0, 1
orig_int_ini = Get interval at time... itier ini
orig_int_end = Get interval at time... itier end
orig_boundary_ini = Get start point... itier orig_int_ini
select tg1
orig_nint1 = Get number of intervals... itier

select tg2
nint2 = Get number of intervals... itier

for int2 from 2 to nint2
select tg2
intstart2 = Get start time of interval... itier int2
label2$ = Get label of interval... itier int2

select tg1
if (int2 = 2) and (orig_int_ini = orig_int_end) and (orig_boundary_ini != ini)
else
nocheck Insert boundary... itier intstart2
nint1 = Get number of intervals... itier
Set interval text... itier nint1 'label2$'
endif

endfor ; nint2



if (orig_int_ini = orig_int_end) and (orig_boundary_ini != ini)
select tg1
Remove left boundary... itier orig_nint1
else
select tg1
left_int = orig_nint1 - 1
left_label$ = Get label of interval... itier left_int
right_label$ = Get label of interval... itier orig_nint1
if left_label$ = "" or left_label$ = "_"
if right_label$ = "" or right_label$ = "_"
Remove left boundary... itier orig_nint1
endif
endif
endif

endfor ; to ntiers


select socopy
plus so1
plus so2
plus tg2
Remove

tgnew = tg1
select tgnew
Rename... 'data_name$'_cut

select 'sonew'
Rename... 'data_name$'_cut
plus 'tgnew'
View & Edit
editor TextGrid 'data_name$'_cut
Move cursor to... 'ini'
endeditor
