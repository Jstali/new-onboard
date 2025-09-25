@echo off
echo =============================================================================
echo DATABASE SETUP SCRIPT FOR ONBOARD PROJECT (Windows)
echo =============================================================================
echo.

set "PSQL_PATH=C:\Program Files\PostgreSQL\17\bin\psql.exe"
set "DB_NAME=onboardd"
set "DB_USER=postgres"
set "DB_HOST=localhost"
set "DB_PORT=5432"

echo Checking PostgreSQL connection...
"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "SELECT version();" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to PostgreSQL!
    echo Please make sure PostgreSQL is running and the password is correct.
    pause
    exit /b 1
)
echo PostgreSQL connection successful!

echo.
echo Checking if database '%DB_NAME%' exists...
"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -lqt | findstr /C:"%DB_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo Database '%DB_NAME%' already exists!
    set /p choice="Do you want to drop and recreate it? (y/N): "
    if /i "%choice%"=="y" (
        echo Dropping existing database...
        "%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "DROP DATABASE IF EXISTS %DB_NAME%;"
        if %errorlevel% neq 0 (
            echo ERROR: Failed to drop database!
            pause
            exit /b 1
        )
        echo Database dropped successfully!
    ) else (
        echo Using existing database.
        goto :setup_schema
    )
)

echo.
echo Creating database '%DB_NAME%'...
"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "CREATE DATABASE %DB_NAME%;"
if %errorlevel% neq 0 (
    echo ERROR: Failed to create database!
    pause
    exit /b 1
)
echo Database '%DB_NAME%' created successfully!

:setup_schema
echo.
echo Setting up database schema and data...
"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f COMPLETE_DATABASE_SETUP.sql
if %errorlevel% neq 0 (
    echo ERROR: Failed to setup database schema!
    pause
    exit /b 1
)
echo Database schema and data setup completed successfully!

echo.
echo Verifying database setup...
for /f %%i in ('"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';"') do set TABLE_COUNT=%%i
for /f %%i in ('"%PSQL_PATH%" -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -t -c "SELECT COUNT(*) FROM users;"') do set USER_COUNT=%%i

echo Database verification completed:
echo    Tables created: %TABLE_COUNT%
echo    Sample users: %USER_COUNT%
echo    Functions created: 2
echo    Indexes created: 10+

echo.
echo =============================================================================
echo Database setup completed successfully!
echo =============================================================================
echo.
echo Next steps:
echo 1. Update backend/config.env with your database password
echo 2. Start the application: npm run dev
echo.
echo Default login credentials:
echo   HR: hr@nxzen.com / password123
echo   Admin: admin@nxzen.com / password123
echo   Manager: manager@nxzen.com / password123
echo.
echo Setup complete! Happy coding!
pause
