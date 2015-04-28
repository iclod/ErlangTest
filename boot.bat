@echo off
@echo 启动本地开发节点
msg %username% /time:3 /w "正在启动本地开发节点..."
goto continue        
:continue
set cookie=abc
set nodeName=ErlangOTP@192.168.0.18
set Dir="G:/ErlangTest/plugin/StudyErlangOTP/ebin"
"g:\tools\erl6.3\bin\werl" +P 30000   +e 30000  -boot start_sasl  -pa %Dir%
pause