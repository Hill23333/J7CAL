@echo off
chcp 65001 > nul
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS


:Start
title J7CAL
goto :Command
goto :EOF


:Command
set /p Command="J7CAL>"
%Command%
goto :Command


