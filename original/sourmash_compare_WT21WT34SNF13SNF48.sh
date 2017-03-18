for k in 18 27 36
do
    for scale in 20000 40000 60000 80000 
    do
        sourmash compare -k $k ./*/compute_sig_files/*.fixed -o compared.WT34_21SNF_13_48.${k}.${scale}
    done
done
