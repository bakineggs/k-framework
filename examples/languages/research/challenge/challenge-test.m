load challenge-compiled
rew run('baris) .
q

rew run('p1) .
rew run('p2) .
search run('p3) =>! B:Bag .
rew run('p4) .
rew run('p5) .
rew run('p6) .
rew run('p7) .
rew run('p8) .
rew run('p9, (Int 5(.List{K}),,Int -5(.List{K}))) .
rew run('p10) .
rew run('p11) .
rew run('p12) .
search[2] run('p13) =>! B:Bag .
search run('p14) =>! B:Bag .
search run('p15) =>! B:Bag .
search run('p16) =>! B:Bag .
search run('p17) =>! B:Bag .
search run('p18) =>! B:Bag .
rew run('p19) .
rew run('p20) .
rew run('p21) .
rew run('p22) .
rew run('p23) .
rew run('p24) .
rew run('p25) .
frew run('p25) .
frew run('p26) .
frew run('p27) .
frew run('p28, (Int 5(.List{K}),,Int 3(.List{K}),,Int 7(.List{K}),,Int 2(.List{K}),,Int 9(.List{K}),,Int 4(.List{K}),,Int 8(.List{K}),,Int -1(.List{K}),,Int 1(.List{K}))) .
rew run('p28, (Int 5(.List{K}),,Int 3(.List{K}),,Int 7(.List{K}),,Int 2(.List{K}),,Int 9(.List{K}),,Int 4(.List{K}),,Int 8(.List{K}),,Int -1(.List{K}),,Int 1(.List{K}))) .
frew run('p29, (Int 5(.List{K}),,Int 3(.List{K}),,Int 7(.List{K}),,Int 2(.List{K}),,Int 9(.List{K}),,Int 4(.List{K}),,Int 8(.List{K}),,Int 0(.List{K}),,Int 1(.List{K}))) .
rew run('p29, (Int 5(.List{K}),,Int 3(.List{K}),,Int 7(.List{K}),,Int 2(.List{K}),,Int 9(.List{K}),,Int 4(.List{K}),,Int 8(.List{K}),,Int 0(.List{K}),,Int 1(.List{K}))) .

search run('p30) =>! B:Bag .
search run('p31) =>! B:Bag .
search run('halt-threads) =>! B:Bag .
