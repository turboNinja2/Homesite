del .Rhistory
del *.Rdata
del res.txt

"C:\Program Files\R\R-3.2.0\bin\x64\Rscript.exe" _import_data.R >> res.txt

for %%a in ("*model.R") do (
"C:\Program Files\R\R-3.2.0\bin\x64\Rscript.exe" %%a >> res.txt
)

pause