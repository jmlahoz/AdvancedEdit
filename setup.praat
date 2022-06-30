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

Add menu command... "Objects" "New" "Create source..." "" 0 Create source.praat
Add menu command... "Objects" "New" "Create filter..." "" 0 Create filter.praat
Add action command... Sound 1 "" 0 "" 0 "Filter (inverse)..." "Remove noise..." 1 Filter (inverse).praat
Add menu command... "SoundEditor" "Edit" "Add silence after cursor..." "" 0 Add silence after cursor.praat
Add menu command... "SoundEditor" "Spectrum" "Spectral manipulation..." "" 0 Spectral manipulation.praat
Add menu command... "TextGridEditor" "Spectrum" "Spectral manipulation..." "" 0 Spectral manipulation.praat
Add menu command... "TextGridEditor" "Edit" "Cut Sound with TextGrid" "Erase text" 0 Cut Sound with Textgrid.praat
Add menu command... "TextGridEditor" "Tier" "Remove tiers..." "Remove entire tier" 0 Remove tiers.praat
