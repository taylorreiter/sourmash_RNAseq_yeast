	for k in 18 27 36
	do
    	for scale in 20000 40000 60000 80000
    	do
        sourmash compute -k $k  -o WT_BR21_k${k}_s${scale}.sig --track-abundance --scaled $scale ./khmer_out/*abundtrim
    	done
	done
