# Cut Sound with TextGrid
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

# This script allows to cut a sound when in the TextGrid Editor. The accompanying TG will be cut accordingly.
# The resulting sound and TG will be created as new objects.
# This is an Editor script.

include auxiliary.praat

@getinfo: 1

##{ Get temporal marks of the cut
ini = Get start of selection
if ini = editor_start
ini = ini + 0.001
endif
end = Get end of selection
if end = editor_end
end = end - 0.001
endif
dur = end - ini

if ini = end
exit Select portion to delete
endif
##}

endeditor

##{ Get cut sound
# Portions are extracted before and after the cut, then reassembled
@selobj: 1, 0
so1 = Extract part... editor_start ini rectangular 1 no
@selobj: 1, 0
so2 = Extract part... end editor_end rectangular 1 no
select so1
plus so2
sonew = Concatenate
##}

##{ Extract TG portions before and after the cut, and add each other's length as white portions
# at the end or at the beginning, respectively
# tg1 will later be completed with tg2 information and become tgnew
@selobj: 0, 1
tg1 = Extract part... editor_start ini yes
extension1 = editor_end - end
Extend time... extension1 End
@selobj: 0, 1
tg2 = Extract part... end editor_end yes
Shift times by... -dur
extension2 = ini - editor_start
Extend time... extension2 Start
##}

# Loop for tiers
@selobj: 0, 1
ntier = Get number of tiers
for itier from 1 to ntier
@selobj: 0, 1
isint = Is interval tier... itier
tier$ = Get tier name... itier

##{ Get info from original TG for later adjustments
# id_ini is the interval where the cut starts, or the low point in the case of point tiers
@get_current_index: itier, isint, ini
id_ini = get_current_index.return
# id_end is the interval where the cut ends, or the low point in the case of point tiers
@get_current_index: itier, isint, end
id_end = get_current_index.return
# t_id_ini is the timepoint of the initial boundary of the interval where the cut starts,
# or that of the low point in the case of point tiers
if id_ini != 0
@get_time_of_index: itier, isint, id_ini
t_id_ini = get_time_of_index.return
else
# Index can be zero only in the case of point tiers, at time marks before any point
# In that case, the timepoint of the lower limit coincides with the editor start
t_id_ini = editor_start
endif
##}

select tg1
@get_number_of_indices: itier, isint
nid1 = get_number_of_indices.return
if nid1 != 0
@get_time_of_index: itier, isint, nid1
tid1 = get_time_of_index.return
else
tid1 = editor_start
endif

select tg2
@get_number_of_indices: itier, isint
nid2 = get_number_of_indices.return

##{ Copy tg2 info onto tg1
if isint = 0
# For point tiers, consider all points (from the first)
id2start = 1
elsif isint = 1
# For interval tiers, consider from interval 2
# (interval 1 is blank and spans the length of the portion before the cut)
id2start = 2
endif

for id2 from id2start to nid2
select tg2
@get_time_of_index: itier, isint, id2
tid2 = get_time_of_index.return
@get_label_of_index: itier, isint, id2
lab2$ = get_label_of_index.return$

select tg1
if (isint = 1) and (id2 = 2) and (id_ini = id_end) and (t_id_ini != ini)
# Do not add an extra boundary if you cut a portion within one interval
else
@insert_index: itier, isint, tid2
# The just inserted boundary / point is the rightmost within tg1, so always matches the current number of indices
@get_number_of_indices: itier, isint
nid1now = get_number_of_indices.return

if tier$ != "BI" or tid2 != tid1
# General case (this condition is DeMorgan of following elsif)
@set_index_text: itier, isint, nid1now, lab2$

elsif tier$ = "BI" and tid2 = tid1
# If two BI overlap due to the merge of initial and final portions, respect the higher index
@get_label_of_index: itier, isint, nid1now
lab1$ = get_label_of_index.return$
lab1 = number(lab1$)
lab2 = number(lab2$)
if lab1 > lab2
@set_index_text: itier, isint, nid1now, lab1$
else
@set_index_text: itier, isint, nid1now, lab2$
endif
endif

endif

endfor ; to nid2
##}

##{ Merge concatenated intervals in one single interval if
if isint = 1
if (id_ini = id_end) and (t_id_ini != ini)
# ... they come from the same original interval
select tg1
Remove left boundary... itier nid1
else
# ... or if they are both silent
select tg1
left_int = nid1 - 1
left_label$ = Get label of interval... itier left_int
right_label$ = Get label of interval... itier nid1
if left_label$ = "" or left_label$ = "_"
if right_label$ = "" or right_label$ = "_"
Remove left boundary... itier nid1
endif
endif
endif
endif
##}

endfor ; to ntier


##{ Clean workspace
select socopy
plus so1
plus so2
plus tg2
Remove
##}

##{ Rename new sound and TG objects
tgnew = tg1
select tgnew
Rename... 'data_name$'_cut
select sonew
Rename... 'data_name$'_cut
##}

##{ View new sound and TG
select sonew
plus tgnew
View & Edit
editor TextGrid 'data_name$'_cut
Move cursor to... 'ini'
endeditor
##}
