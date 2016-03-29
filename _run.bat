del *.pyc

python Submissions4.py
python SubmissionsKeras.py -seed 666 -offset 1 
python SubmissionsKeras.py -seed 777 -offset 3 
python SubmissionsKeras.py -seed 888 -offset 5 
python SubmissionsKeras.py -seed 999 -offset 7 
python SubmissionsKeras.py -seed 888 -offset 11 
python Average.py

del *.pyc
pause