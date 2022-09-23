echo off
@echo Starting postgres server
rem pg_ctl start -D d:\progs\pg\data
net start postgresql-x64-14

start start-webserver.bat

start start-msedge.bat

start start-vs.bat

@echo starting database console
cd /d d:\github\bassmati-on-code\postgres\docs\first-steps
start ..\..\start-psql.bat