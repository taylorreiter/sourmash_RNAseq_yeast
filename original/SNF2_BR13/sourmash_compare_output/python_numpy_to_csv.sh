for file in *000
do
python -c "import numpy; import pylab; numpy.savetxt('${file}.csv', 'D', delimiter=',')"
done
