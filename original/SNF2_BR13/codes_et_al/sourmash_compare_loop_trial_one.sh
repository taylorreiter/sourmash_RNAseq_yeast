for k in 6 9 12 15 18 21 24 27 30
do
    for scale in 500 1000 5000 10000 20000 40000 80000 160000 240000 480000
    do
        sourmash compare -k $k SNF2_BR13_k${k}_s${scale}* -o compared.${k}.${scale}
    done
done
