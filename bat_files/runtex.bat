@ECHO off
setlocal
@set path=
:: = = = = = = = = = = = = = = = = = = = =
::  ** カレントドライブの抽出
:: = = = = = = = = = = = = = = = = = = = =
@SET DRV=%~d0
@echo :: =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=
@echo :: = カレントドライブ名は，%DRV% です．
@echo :: =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=
@echo ::
@echo :: * Comment;  バックグラウンド 実行させるには，start　コマンドを使用する．
@echo ::      ex.) start sakura
@echo ::         # ↑ これで，サクラエディタが，バックグラウンドで起動する．
@echo ::

:: バッチファイルの動作設定（YES/NOで選択すること）
:: ========================================================
::  * 環境変数設定
::    -- 環境変数PATHに一時追加するのみ．batchを終了すると，
::       この追加したPATHは消去される．
:: ========================================================
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Shell
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::@SET PATH=%DRV%\usr\bin\shell\CygwinPortable\App\Cygwin\bin;%PATH%
::@SET PATH=%DRV%\usr\bin\shell\CygwinPortable\App\Cygwin\lib;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Launcher
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\PApps;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Firefox Portable
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\WebBrowser\FirefoxPortable;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Google Chrome Portable
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\WebBrowser\GoogleChromePortable;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Filer: XF
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\Filer\xf11-7;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** for platex2e
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\LaTeX\EPS-draw\;%PATH%
@SET PATH=%DRV%\usr\bin\tool\LaTeX\EpsConv;%PATH%
@SET PATH=%DRV%\usr\bin\w32tex\bin;%PATH%
@SET PATH=%DRV%\usr\bin\tool\LaTeX\dviout;%PATH%
@SET PATH=%DRV%\usr\bin\tool\LaTeX\WinShell;%PATH%
@SET PATH=%DRV%\usr\bin\tool\Office\FoxitReaderPortable;%PATH%
@SET PATH=%DRV%\usr\bin\PApps\PortableApps\Editra;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** shell
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Cygwin
@SET PATH=%DRV%\usr\bin\shell\CygwinPortable\App\Cygwin\bin;%PATH%
@SET PATH=%DRV%\usr\bin\shell\CygwinPortable\App\Cygwin\lib;%PATH%
@SET PATH=C:\windows\system32;%PATH%
@SET PATH=C:\windows;%PATH%
@SET PATH=C:\windows\System32\Wbem;%PATH%
@SET SHELL=Cygwin's binary

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** vim
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\EditText\vim73-kaoriya-msvc10_x32j;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** sakura_editor
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\tool\EditText\sakura_editer;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** batch file for global command
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\setpath\batch_glb;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** batch file for latex compile
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=%DRV%\usr\bin\setpath\batch_latex;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** local command batch file
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PATH=cmd;%PATH%

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::  *** Perl(strawberry)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SET PERLDIR=%DRV%\usr\bin\develop\Perl\strawberry\perl
@SET PATH=%PERLDIR%\bin;%PATH%
@SET PATH=%PERLDIR%\lib;%PATH%

@runtex.exe

endlocal
