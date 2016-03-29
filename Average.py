import pandas as pd
from os import listdir
from os.path import isfile, join

mypath = './submissions/'

onlyfiles = [join(mypath,f) for f in listdir(mypath) if isfile(join(mypath, f))]

file = onlyfiles.pop(0)
print(file)
sum = pd.read_csv(file)

for currentFile in onlyfiles:
    print(currentFile)
    data = pd.read_csv(currentFile)
    sum += data

submission = sum / (len(onlyfiles)+1)
submission[["QuoteNumber"]] = data[["QuoteNumber"]]
submission.to_csv(join(mypath,'avg.csv'),index=False)