for k in 18 27 36
do
    for scale in 20000 40000 60000 80000
    do
        sourmash compare -k $k *k${k}_s${scale}* -o compared.${k}.${scale}
    done
done
