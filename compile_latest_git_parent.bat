set PATH=C:\cygwin\bin;%PATH%
set PATH=C:\cygwin64\bin;%PATH%

rem Git v1.7.9 doesn't recognize push.default=simple:
git config --global --unset push.default simple

sh -x compile_latest_git_child.sh
rem turn push.simple back on
git config --global push.default simple
