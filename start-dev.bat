net start postgresql-x64-13
cd docs
start /min deno-file-server
start /min cmd.exe /k "cd /d d:\github\bassmati-on-code\postgtes\docs&psql"
d:\progs\VS2022\Common7\IDE\devenv.com "D:\github\bassmati-on-code\postgres\"
start "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" "http://localhost:4507/data-types.htm"
