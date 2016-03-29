del .Rhistory
del res_nnet.txt

for %%a in ("*nnet_model.R") do (
echo %%a
"C:\Program Files\R\R-3.2.0\bin\x64\Rscript.exe" %%a >> res.txt
)

pause