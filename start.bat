@echo off
chcp 65001 > nul
title POLYSHIP AI MUSIC - 독자 생성형 AI 음원 플랫폼

echo =======================================================
echo    [ POLYSHIP AI MUSIC ] 실시간 AI 스트리밍 & 아티스트 플랫폼
echo =======================================================
echo.
echo 1. 기본 브라우저에서 POLYSHIP AI MUSIC을 바로 실행합니다...
echo 2. 나만의 아티스트 프로필과 4대 계정(구글, 수노, 네이버, 카카오)을 연동해보세요!
echo.

where python >nul 2>nul
if %ERRORLEVEL% equ 0 (
    echo [안내] Python 환경 감지됨 - 로컬 웹서버(포트 3000)를 구동합니다.
    start http://localhost:3000
    python -m http.server 3000
) else (
    echo [안내] 브라우저 직접 열기로 실행합니다.
    start "" "%~dp0index.html"
)

pause