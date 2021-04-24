:: go one level up
cd %SRC_DIR%
cd ..

:: create the gopath directory structure
set "GOPATH=%CD%\gopath"
mkdir "%GOPATH%\src\github.com\github" || goto :error
mklink /D "%GOPATH%\src\github.com\github\git-sizer" "%SRC_DIR%" || goto :error
cd "%GOPATH%\src\github.com\github\git-sizer"

:: build the project
set "CGO_ENABLED=0"  :: disable CGO, as there are no C libs to load
set "LDFLAGS=-s -w"  :: omit the symbol table / debug information and
                     :: DWARF symbol table.
go build  -ldflags "%LDFLAGS% -X main.ReleaseVersion=%PKG_VERSION%" . || goto :error

:: install the binary
mv "%GOPATH%\..\work\git-sizer.exe" "%LIBRARY_BIN%\git-sizer.exe" || goto :error
goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1