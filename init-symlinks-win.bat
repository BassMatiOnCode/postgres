rem create symbolik links in a new working tree
cd ..\postgres
mklink /d docs\inc ..\inc\docs
mklink docs\local.css ..\..\site-root\docs\local.css
