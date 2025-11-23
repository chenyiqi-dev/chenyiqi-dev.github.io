@echo off
echoStart deploying...

:: 1. 添加所有文件
git add .

:: 2. 提交更改（自动加上日期时间作为备注，省得你还要想名字）
set mydate=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,5%
git commit -m "Auto update: %mydate%"

:: 3. 推送到 GitHub 源码仓库
echo Pushing source code...
git push

:: 4. 部署网站
echo Building and deploying website...
mkdocs gh-deploy

echo.
echo ==========================================
echo   Success! Your blog is updating...
echo ==========================================
pause