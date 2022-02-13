echo on
cd /d d:\github\bassmati-on-code\postgres\
pause
chcp 1252
@SET PGDATA=D:\Data\postgres
@SET PGDATABASE=postgres
@SET PGUSER=postgres
@SET PGPORT=5432
@SET PGLOCALEDIR=D:\progs\pg\14\share\locale
pause
runas /user:administrator "net start postgresql-x64-14"
pause
start /min "cmd.exe /k d:\progs\pg\14\bin\psql.exe"
pause
cd docs
start /min deno-file-server
d:\progs\VS2022\Common7\IDE\devenv.com "D:\github\bassmati-on-code\postgres\"
start "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "http://localhost:4507/psql.htm"
