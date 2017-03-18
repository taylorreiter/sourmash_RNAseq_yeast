for k in 17 19 21 23
do
    for scale in 500 1000 5000 10000
    do
        sourmash compute -k $k --scale $scale blah blah blah -o output.${k}.${scale}.sig
    done
done
