sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''_+_) .KProperLabel, _`,`,_ (.*, .*)), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''_==_) .KProperLabel, _`,`,_ (.*, .*)), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''Apply) .KProperLabel, _`,`,_ (.*, .*)), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''application) .KProperLabel, _`,`,_ (.*, .*)), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''Apply) .KProperLabel, Kcxt:KProper), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''bind) .KProperLabel, _`,`,_ (_`(_`) (kList (("wklist_") .String), _`,`,_ (?.:List`{K`}, Kcxt:KProper, ?.:List`{K`})), _`(_`) (kList (("wklist_") .String), ?.:List`{KResult`}))), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''Apply) .KProperLabel, Kcxt:KProper), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1
sed -i 's|eq \(<_>_</_> ((k) .CellLabel, _~>_ (_`(_`) (('\''application) .KProperLabel, _`,`,_ (?.:K, _`(_`) (kList (("wklist_") .String), _`,`,_ (?.:List`{K`}, Kcxt:KProper, ?.:List`{K`})))), Rest:K), (k) .CellLabel) =\)|rl \1>|' $1