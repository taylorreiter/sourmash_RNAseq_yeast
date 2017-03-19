for k in 18 27 36
do
for scale in 20000 40000 60000 80000
do
sourmash compute -k $k  -o SNF2_BR48_k${k}_s${scale}* --track-abundance --scaled $scale ./khmer_out/*abundtrim
done
done
