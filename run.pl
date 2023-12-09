#! /usr/bin/perl -w
################################################################################
use strict;
use warnings;
use threads;

use utf8;
use Encode 'encode';
use Encode 'decode';
use File::Copy 'copy';
use File::Copy 'move';
use Cwd;

################################################################################
binmode(STDOUT, ":utf8");

################################################################################
local $|=1;

################################################################################
our $flg_windows=0;

################################################################################
if ((defined $ENV{'os'}) && ($ENV{'os'} =~ /windows/i)){
    $flg_windows=1;
}

if ((defined $ENV{'OS'}) && ($ENV{'OS'} =~ /windows/i)){
    $flg_windows=1;
}

if( defined $ARGV[0] ){}
elsif($flg_windows){
    printf("X Error X Not Supported :: OS=Windows\n");
    system("bat_files\\xtex.bat");
    exit(0);
}

################################################################################
my $cp              = "cp -rpf"         ;
my $rm              = "rm -rfv"         ;
my $mv              = "mv -f"           ;
my $basemap         = "uptex-ipa.map"   ; # takao.map or ipa.map or uptex-ipa.map
my $pdfviewer       = "qpdfview "       ;
my $NG_LIST_FILE    = "NG_LIST.TXT"     ;
my $tex_command     = "uplatex"         ;
my $pdf_command     = "dvipdfmx"        ;
my $MaxLine         = 2000              ;
my $pdfver          = 7                 ; # dvipdfmx: -V number   Set PDF minor version
my $command         = $ARGV[0]          ; # 第一引数がコマンド
my $cpu_limit_mode  = 1                 ; # シーケンシャル実行モード
my $flg_divnoteB5   = 0                 ; # B5 の分割ノートを作るか否か
my $flg_landscape   = 0                 ; # 横書きのファイルを作るか否か
my $flg_mathdoc     = 0                 ; # 数学ノートを作るか否か

################################################################################
if (-f $NG_LIST_FILE){unlink $NG_LIST_FILE;}

################################################################################
##### RUN LaTeX
################################################################################
if (!defined $ARGV[0]){
    print ("X Error X Argument Error\n");
}
elsif($command eq "help"){
    printf("[Message] command: $command\n");
    &help();
}
elsif($command eq "remake"){
    printf("[Message] command: $command\n");
    my $flg_all = "";
    system("perl $0 clean");
    system("perl $0 chk");
    if((defined $ARGV[1]) && ($ARGV[1] eq "all")){
        $flg_all = "all";
    }
    system("perl $0 cmp $flg_all");
}
elsif($command eq "chk"){
    printf("[Message] command: $command\n");
    &str_and_chr_chk();
}
elsif($command eq "chkenc"){
    printf("[Message] command: $command\n");
    &chgenc_by_nkf_utf8();
}
elsif ($command eq "pdffonts"){
    printf("[Message] command: $command\n");
    &check_pdffonts();
}
elsif ($command eq "eps2pdf"){
    printf("[Message] command: $command\n");
    &eps2pdf();
}
elsif ($command eq "archive"){
    printf("[Message] command: $command\n");
    &archive();
}
elsif ($command eq "cmp"){
    printf("[Message] command: $command\n");
    my $flg_all     =0;
    my $flg_all_phys=0;
    my $flg_all_math=0;
    my $flg_part    =0;

    if( ! -d "0Result") {
            print "[Message] Create 0Result/ (as New Dir.)\n";
            mkdir "0Result";
    }
    if((defined $ARGV[1])&&($ARGV[1] eq "chk")){
        &str_and_chr_chk();
        $flg_all = 1;
    }

    if   (! defined $ARGV[1]                      ){ $flg_all=1; }
    elsif((defined $ARGV[1])&&($ARGV[1] eq "all") ){ $flg_all=1; }
    elsif((defined $ARGV[1])&&($ARGV[1] eq "pall")){ $flg_all_phys=1; }
    elsif((defined $ARGV[1])&&($ARGV[1] eq "mall")){ $flg_all_math=1; }
    else{}

    if($flg_all){
        printf("[Message] Make All Note , OK ? (y or n)>> ");
        my $tmp = <STDIN>;
        chomp($tmp);
        if($tmp eq "y"){ }
        else{ exit(0);}
    }

    my $file       = "";
    my $map        = "";
    my $size       = "";
    my $opt        = "";
    my $batname    = "";
    my $thr00      =undef;
    my $thr01      =undef;
    my $thr02      =undef;
    my $thr03      =undef;
    my $thr04      =undef;
    my $thr05      =undef;
    my $thr06      =undef;
    my $thr07      =undef;
    my $thr08      =undef;
    my $thr09      =undef;
    my $thr10      =undef;
    my $thr11      =undef;
    my $thr12      =undef;
    my $thr13      =undef;
    my $thr14      =undef;
    my $thr15      =undef;

    # Physics
    if((defined $ARGV[1])){
        printf("[Message]     cmp($ARGV[1])\n");
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa5n")){
        printf("[Message]     cmp-all\n");
        # physics_2nd_A5_Normal
        $file       = "physics_2nd_A5_Normal"           ;
        $map        = "-f $basemap -f dlbase14.map"     ;
        $size       = "-p a5"                           ;
        $opt        = "-V $pdfver -vv"                  ;
        $batname    = "tmp-$file.bat"                   ;

        # CPU_LIMIT_MIDE ... Limit  CPU NUM < 2
        $thr00 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa5p")){
        printf("[Message]     cmp-all\n");
        # physics_2nd_A5_Normal
        $file       = "physics_2nd_A5_Print"           ;
        $map        = "-f $basemap -f dlbase14.map"     ;
        $size       = "-p a5"                           ;
        $opt        = "-V $pdfver -vv"                  ;
        $batname    = "tmp-$file.bat"                   ;
        # CPU_LIMIT_MIDE ... Limit  CPU NUM < 2
        $thr00 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa5sp")){
        # physics_2nd_A5_SmartPhone
        $file       = "physics_2nd_A5_SmartPhone"       ;
        $map        = "-f $basemap -f dlbase14.map"      ;
        $size       = "-p a5"                           ;
        $opt        = "-V $pdfver -vv"                  ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr00) {$thr00->join();}}
        $thr01 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa4p")){
        # physics_2nd_A4_Print
        $file = "physics_2nd_A4_Print"                  ;
        $map  = "-f $basemap -f dlbase14.map"            ;
        $size = "-p a4"                                 ;
        $opt  = "-V $pdfver -vv"                        ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr01) {$thr01->join();}}
        $thr02 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa4p1p")){
        # physics_2nd_A4_Print
        $file = "physics_2nd_A4_Print_1plane"                  ;
        $map  = "-f $basemap -f dlbase14.map"            ;
        $size = "-p a4"                                 ;
        $opt  = "-V $pdfver -vv"                        ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr01) {$thr01->join();}}
        $thr02 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pa4n")){
        # physics_2nd_A4_Normal
        $file = "physics_2nd_A4_Normal"                 ;
        $map  = "-f $basemap -f dlbase14.map"            ;
        $size = "-p a4"                                 ;
        $opt  = "-V $pdfver -vv"                        ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr02) {$thr02->join();}}
        $thr03 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pb5")){
        # physics_2nd_B5_Normal
        $file = "physics_2nd_B5_Normal"                 ;
        $map  = "-f $basemap -f dlbase14.map"            ;
        $size = "-p jisb5"                              ;
        $opt  = "-V $pdfver -vv"                        ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr03) {$thr03->join();}}
        $thr04 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "2in1")){
        # physics_2nd_A4_A5_Normal_2in1
        $file = "physics_2nd_A4_A5_Normal_2in1"         ;
        $map  = "-f $basemap -f dlbase14.map"           ;
        $size = "-p a4"                                 ;
        $opt  = "-V $pdfver -vv"                        ;
        $batname    = "tmp-$file.bat"                   ;
        if($cpu_limit_mode){if(defined $thr04) {$thr04->join();}}
        $thr05 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
        $flg_part   = 1;
    }

    if($cpu_limit_mode){if(defined $thr05) {$thr05->join();}}

    if($flg_divnoteB5){
        if($flg_all||$flg_all_phys||(defined $ARGV[1])&&($ARGV[1] eq "pb5ll")){ # loose leaf
            # physics_2nd_B5_Normal_01: CM
            $file = "physics_2nd_B5_Normal_01"              ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p jisb5"                              ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr06) {$thr06->join();}}
            # physics_2nd_B5_Normal_02: EM/RT/SM
            $thr05 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $file = "physics_2nd_B5_Normal_02"              ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p jisb5"                              ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr07) {$thr07->join();}}
            # physics_2nd_B5_Normal_03: QM
            $thr06 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $file = "physics_2nd_B5_Normal_03"              ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p jisb5"                              ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr08) {$thr08->join();}}
            # physics_2nd_B5_Normal_04: App
            $thr07 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $file = "physics_2nd_B5_Normal_04"              ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p jisb5"                              ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr09) {$thr09->join();}}
            $thr08 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
    }

    if($flg_mathdoc){
        ### Math
        if($flg_all||$flg_all_math||(defined $ARGV[1])&&($ARGV[1] eq "mb5")){
            # math_2nd_B5_Normal
            $file = "math_2nd_B5_Normal"                    ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p jisb5"                              ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr10) {$thr10->join();}}
            $thr09 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
        if($flg_all||$flg_all_math||(defined $ARGV[1])&&($ARGV[1] eq "ma5n")){
            # math_2nd_A5_Normal
            $file = "math_2nd_A5_Normal"                    ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p a5"                                 ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr11) {$thr11->join();}}
            $thr10 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
        if($flg_all||$flg_all_math||(defined $ARGV[1])&&($ARGV[1] eq "ma5sp")){
            # math_2nd_A5_SmartPhone.tex
            $file = "math_2nd_A5_SmartPhone"                ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p a5"                                 ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr12) {$thr12->join();}}
            $thr11 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
        if($flg_all||$flg_all_math||(defined $ARGV[1])&&($ARGV[1] eq "ma4p")){
            # math_2nd_A4_Print
            $file = "math_2nd_A4_Print"                     ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p a4"                                 ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr13) {$thr13->join();}}
            $thr12 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
        if($flg_all||$flg_all_math||(defined $ARGV[1])&&($ARGV[1] eq "ma4n")){
            # math_2nd_A4_Normal
            $file = "math_2nd_A4_Normal"                    ;
            $map  = "-f $basemap -f dlbase14.map"            ;
            $size = "-p a4"                                 ;
            $opt  = "-V $pdfver -vv"                        ;
            $batname    = "tmp-$file.bat"                   ;
            if($cpu_limit_mode){if(defined $thr14) {$thr14->join();}}
            $thr13 = threads->new(\&texcmp, $file, $opt, $map , $size, $batname) ;
            $flg_part   = 1;
        }
    }

    if($cpu_limit_mode){if(defined $thr14) {$thr14->join();}}

    if(!$flg_part&&(defined $ARGV[1])){
        printf("X Error X Unexpected Arrgument($ARGV[1])\n");
        printf(" --> All(default) : perl $0 cmp all <Hit-Enter>\n");
        printf(" --> Physics      : perl $0 cmp [pa5n/pa5p/pa5sp/pa4p/pa4p1p/pa4n/pb5/p5ll/pall] <Hit-Enter>\n");
        printf(" --> Math         : perl $0 cmp [ma5/ma5sp/ma4p/ma4n/mb5/mall]      <Hit-Enter>\n");
        exit(1);
    }

    if(defined $thr00) {$thr00->join(); printf("thr00 end\n");}
    if(defined $thr01) {$thr01->join(); printf("thr01 end\n");}
    if(defined $thr02) {$thr02->join(); printf("thr02 end\n");}
    if(defined $thr03) {$thr03->join(); printf("thr03 end\n");}
    if(defined $thr04) {$thr04->join(); printf("thr04 end\n");}
    if(defined $thr05) {$thr05->join(); printf("thr05 end\n");}
    if(defined $thr06) {$thr06->join(); printf("thr06 end\n");}
    if(defined $thr07) {$thr07->join(); printf("thr07 end\n");}
    if(defined $thr08) {$thr08->join(); printf("thr08 end\n");}
    if(defined $thr09) {$thr09->join(); printf("thr09 end\n");}
    if(defined $thr10) {$thr10->join(); printf("thr10 end\n");}
    if(defined $thr11) {$thr11->join(); printf("thr11 end\n");}
    if(defined $thr12) {$thr12->join(); printf("thr12 end\n");}
    if(defined $thr13) {$thr13->join(); printf("thr13 end\n");}
    if(defined $thr14) {$thr14->join(); printf("thr14 end\n");}
    if(defined $thr15) {$thr15->join(); printf("thr15 end\n");}

    printf("---> ALL Compile Finish!!\n\n");
}
elsif ($command eq "begin"){
    printf("[Message] command: $command\n");
    my @FLIST = glob("tex_files/*.tex "
                    ."pdf_files/*.pdf "
                    ."xbb_files/*.xbb "
                    ."sty_files/*.sty "
                    #."sty_files/extsizes/*.* " # Font Size Extension: extsizes
                    ."map_files/*.map "
                    ."cls_files/*.cls "
                    ."aux_files/*.*   "
             );
    my $fnum = @FLIST;
    my $cnt=0;
    for(@FLIST){
        $cnt++;
        $|=1;
        printf("\r[Message] Now Coping (%3.0d%%:%4d/%4d)", ($cnt/$fnum)*100,$cnt, $fnum);
        copy $_ ,".";
    }
    printf("\r%80s", " ");
    printf("\r[Message] Finish !!\n");

    if($flg_windows){
    }
    else{
        my @mkstylist=("bbding", "onlyamsmath", "dashbox", "wasysym");
        for(@mkstylist){ &prepare_style($_); }
    }
}
elsif ($command eq "end"){
    local $|=1;
    printf("[Message] command: $command\n");
    system("perl $0 update");
    my @FILE_LIST=glob("physics_*_*.pdf");
    for(@FILE_LIST){if(-f $_){ unlink $_;}}
    printf("[Message] Now Get File List\n");
    @FILE_LIST=sort(glob("*.*"));
    my $fnum=@FILE_LIST;
    my $cnt=0;
    for(@FILE_LIST){
        $cnt++;
        printf("\r[Message] Now Moving (%3.0d%%:%4d/%4d)", ($cnt/$fnum)*100,$cnt, $fnum);
        if   ($_ =~ /\.tex/i){  move $_ , "tex_files/"  ; }
        elsif($_ =~ /\.pdf/i){  move $_ , "pdf_files/"  ; }
        elsif($_ =~ /\.cls/i){  move $_ , "cls_files/"  ; }
        elsif($_ =~ /\.dvi/i){  move $_ , "dvi_files/"  ; }
        elsif($_ =~ /\.xbb/i){  move $_ , "xbb_files/"  ; }
        elsif($_ =~ /\.aux/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.out/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.log/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.lof/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.toc/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.idx/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.toc/i){  move $_ , "aux_files/"  ; }
        elsif($_ =~ /\.sty/i){  move $_ , "sty_files/"  ; }
        elsif($_ =~ /\.map/i){  move $_ , "map_files/"  ; }
        elsif($_ =~ /\.eps/i){  move $_ , "eps_files/"  ; }
        elsif($_ =~ /\.edf/i){  move $_ , "edf_files/"  ; }
        elsif($_ =~ /\.odg/i){  move $_ , "odg_files/"  ; }
        elsif($_ =~ /\.bat/i){  move $_ , "bat_files/"  ; }
        elsif($_ =~ /\.ods/i){  move $_ , "ods_files/"  ; }
        elsif($_ =~ /\.rb/i) {  move $_ , "ruby_files/" ; }
        elsif($_ =~ /\.pl/i) {} # Do Nothing
        else    {
            printf("\r%80s", " ");
            printf("\r>>> Warnings <<<   (Ignore File)  $_\n");
        }
    }
    if(-f "list.txt"){unlink "list.txt";}
    printf("\r%80s", " ");
    printf("\r[Message] Finish !!\n");
}
elsif($command eq "search"){
    printf("[Message] command: $command\n");
    if((! defined $ARGV[1]) || (! defined $ARGV[2])){
        printf("X Error X Argument Error at search command\n");
        exit(1);
    }
    my $str   = "$ARGV[1]"; # Search Strings
    my @flist = @ARGV; # Search File Names
    &searchString($str,@flist);
}
elsif($command eq "overwrite"){
    printf("[Message] command: $command\n");
    my $script = "./script/overwrite.pl";
    if (!-f $script){
        printf("X Error X File Not Found: $script\n");
        exit(1);
    }
    if(system("perl $script")){
        printf("\nX Error X 処理失敗\n");
    }
}
elsif ($command eq "view"){
    if(defined $ARGV[1] ){
        $pdfviewer = $ARGV[1];
    }
    printf("[Message] command: $command\n");
    my @physflist = sort(glob("physics_2nd_*.pdf"));
    my @mathflist = sort(glob("math_2nd_*.pdf"));
    my @flist     = (@physflist,@mathflist);
    my $fnum=@flist;
    if($fnum==0){
        printf(">>> Warnings <<<   Non-Text\n");
        exit(1);
    }
    printf("[Message] Select (default: $flist[0])\n");
    my $i=0;
    for my $file (@flist){
        $i++;
        printf("    %d) $file\n" , $i);
    }

    printf("    q) __ quit __\n");
    printf(" INPUT >>> ");
    my $sw=<STDIN>;
    chomp($sw);
    if($sw eq "q") {exit(0);}
    elsif($sw >   $i) {exit(0);}
    elsif($sw eq "")  {$sw = "1";}
    my $file=$flist[hex($sw)-1];

    printf ("pdf viewer is $pdfviewer\n");
    printf ("file  name   : $file\n");
    if($flg_windows){
        system ("start $file &");
    }
    else{
        system (" $pdfviewer $file &");
    }

}
elsif ($command eq "update"){
    printf("[Message] command: $command\n");

    for(glob("./0Result/*.*")){
        if( -f $_ ){
            printf("%-60s","\r[Message] rm $_");
            unlink $_;
        }
    }

    if(-d "./0Result"  ){
        printf("%-60s","\r[Message] rmdir ./0Result");
        rmdir "./0Result";

        my $xtimes = 0;
        while(  -d "0Result"){
            $xtimes += 1;
            if($xtimes>5){
                print("time is over !!, update fail 1\n");
                last;
            }
            print(".");
            sleep(1);
        }
    }

    printf("%-60s","\r[Message] mkdir ./0Result");
    mkdir "./0Result", 0777;

    my $xtimes = 0;
    while( ! -d "0Result"){
        $xtimes += 1;
        if($xtimes>30){
            print("time is over !!, update fail 2\n");
            last;
        }
        print(".");
        sleep(1);
    }

    if( ! -d "./0Result"  ){
        printf("%-60s\n","\rX Error X 0Result does not exist.");
        exit(1);
    }

    copy "physics_2nd_A4_Normal.pdf"                , "0Result/";
    copy "physics_2nd_A4_Print.pdf"                 , "0Result/";
    copy "physics_2nd_A5_Normal.pdf"                , "0Result/";
    copy "physics_2nd_A5_SmartPhone.pdf"            , "0Result/";
    copy "physics_2nd_B5_Normal.pdf"                , "0Result/";
    copy "physics_2nd_B5_Normal_01.pdf"             , "0Result/";
    copy "physics_2nd_B5_Normal_02.pdf"             , "0Result/";
    copy "physics_2nd_B5_Normal_03.pdf"             , "0Result/";
    copy "physics_2nd_B5_Normal_04.pdf"             , "0Result/";
    copy "physics_2nd_A4_A5_Normal_2in1.pdf"        , "0Result/";
    copy "physics_2nd_A4_A5_Normal_2in1-nup.pdf"    , "0Result/";


    my @UPLIST = glob("./0Result/*.pdf");
    my $fnum   = @UPLIST;
    if($fnum){
        printf("-%60s\n","\r[Message] Update Finished");
        for my $filename (@UPLIST){
            printf(" --> %s\n", $filename);
        }
    }
    else{
        printf("%-60s\n","\r[Message] Update File is Nothing");
    }
}
elsif ($command eq "clean"){
    printf("%-60s","\r[Message] command: $command\n");
    if ((defined $ARGV[1]) && ($ARGV[1] eq "-r")){
        &clean_recursive();
    }
    else{
        &clean();
    }
}
else{
    print("X Error X Unexpected Argument($command)\n");
}

exit(0);

#------------------------------------------------------------------------------
sub clean
{
    my @sfx_list = (  "*.dvi"
                    , "*.xbb"
                    , "*.bmc"
                    , "*.bak"
                    , "*.lof"
                    , "*.log"
                    , "*.out"
                    , "*.aux"
                    , "*.idx"
                    , "*.toc"
                    , "*.ind"
                    , "*.ilg"
                    , "*.fdb_latexmk"
                    , "*.fls"
                    , "tmp-*.*");

    for my $sfx (@sfx_list){
        my @now_files = glob($sfx);
        for my $target (@now_files){
            #printf("<<<Debug>>> target=%s\n", $target);
            if(-f $target){
                printf("[Delete] $target\n");
                unlink $target;
            }
        }
    }
}

sub clean_recursive
{
    my @alllist = glob("*");
    for my $target (@alllist){
        printf("<<<Debug>>> target=%s\n", $target);
        if (-d $target){
            printf("[CLEAN_Recursive] DIR=%s\n", getcwd());
            chdir $target;
            &clean_recursive();
            chdir "..";
        }
    }

    &clean();
}


sub texcmp
{
        my ($file, $opt, $map , $size, $batname) = @_;

        #system("if exist *.xbb del *.xbb");
        sleep(2);

        if($flg_windows){
            open(my $fhw, ">:utf8" , $batname) or die $!;
            printf ($fhw "\@echo off\n"          );
            printf ($fhw "rm -rf $file.pdf\n"          );
            printf ($fhw "title $tex_command 1:  $file\n");
            printf ($fhw "$tex_command -shell-escape $file >  platex_log1_$file.log\n");
            printf ($fhw "title $tex_command 2:  $file\n");
            printf ($fhw "$tex_command -shell-escape $file >  platex_log2_$file.log\n");
            printf ($fhw "title $tex_command 3:  $file\n");
            printf ($fhw "$tex_command -shell-escape $file >  platex_log3_$file.log\n");
            printf ($fhw "title $pdf_command :  $file\n");
            printf ($fhw "start $pdf_command $opt  $map  $size  $file\n");
            printf ($fhw "exit\n\n");
            close($fhw);
            system("$batname");
        }
        else{
            # ---- Compile Check
            system("$tex_command -shell-escape $file")      ;
            # ---- 1st $tex_command
            printf ("1st $tex_command -shell-escape $file --> platex_$file-1.log\n");
            #system ("$tex_command -shell-escape $file");
            system ("$tex_command -shell-escape $file   > platex_$file-1.log");
            # ---- 2nd $tex_command
            printf ("2nd $tex_command -shell-escape $file --> platex_$file-2.log\n");
            system ("$tex_command -shell-escape $file   > platex_$file-2.log");
            # ---- 3rd $tex_command
            printf ("3rd $tex_command -shell-escape $file --> platex_$file-3.log\n");
            system ("$tex_command -shell-escape $file   > platex_$file-3.log");
            # ---- create pdf
            printf ("$pdf_command $opt  $map  $size  $file --> $pdf_command-$file.log");
            system ("$pdf_command $opt  $map  $size  $file   > $pdf_command-$file.log");
            open(my $fhr,"<", "$pdf_command-$file.log") or die $!;
            my @DATA=<$fhr>;
            close($fhr);
            for my $line (@DATA){ print; }
            printf ("pdf file: $file.pdf\n");
        }

        open(my $fhw_texcmp_log, ">>:utf8", "texcmp.log") or die $!;
        my $execute_datetime = localtime();
        printf($fhw_texcmp_log "time=$execute_datetime, file=$file, option=$opt, fontmap=$map , papersize=$size\n");
        close($fhw_texcmp_log);

        if($file =~ /_2in1/i){
            my $landscape = "--landscape"                   ; # or # "--landscape";
            my $XinX      = "2x1"                           ; # 2x1  2x2
            my $trim      = "--trim \"0cm 0cm 0cm 0cm\""    ; # right top bottom left
            my $scale     = "--scale 1.0"                   ; # 1.0   0.96  1.41
            printf("pdfnup  $landscape  $scale  $trim  --nup $XinX  ${file}.pdf");
            system("pdfnup  $landscape  $scale  $trim  --nup $XinX  ${file}.pdf");
        }

        return 0;
}

##### String / Charactor Check
sub str_and_chr_chk()
{
    my $flg_check_NG = 0;
    my $cnt_file     = 0;
    my @flist = glob("*.tex");
    my $check_file_number = @flist;
    printf("Now Easy Checking\n");
    for my $file (@flist) {
        open(my $fhr, "<:utf8" , $file) or die $!;
        my $cnt_line=0;
        $cnt_file++;
        local $|=1;
        my $percent = ($cnt_file/$check_file_number)*100;
        printf("\r %3d %% : %-60s ", $percent, $file);
        #######
        ####### NG WORD
        #######
        my @NG_LIST = (
                    # texのコマンドチェック
                    "itemise"       ,
                    # 変換ミスチェック
                    "，．"          , "．，"        , "迄"          ,
                    "。"            , "、"          , "．．"        , "，，"            ,
                    "表わす"        , "と置く"      , "仮設"        , "橋に"            ,
                    "話し"          , "考る"        , "おもう"      , "かんがえる"      ,
                    "のよって"      , "あいまい"    , "方物運動"    , "成立つ"          ,
                    "振動数"        , "呼ぶ"        , "次の通り"    , "以下の通り"      ,
                    "定義をする"    , "時間で微分"  , "空間で微分"  , "所謂"            ,
                    "勿論"          , "といえる．"  , "表わされる"  , "一を示す"        ,
                    "滑らか"        , "直行"        , "斜行"        , "成りたつ"        ,
                    "従って，"      , "然るに"      , "ぼくは"      , "ぼくの"          ,
                    "Newtonの"      , "家庭する"    , "過程する"    , "Coulombの"       ,
                    "変微分"        , "と仮定をする", "Diracの"     , "Faradayの"       ,
                    "Maxwellの"     , "いかのような", "いかのように", "あらわす"        ,
                    "僕"            , "あらわし"    , "かんがる"    , "つぎに"          ,
                    "なにか"        , "一番最初"    , "ほかの"      , "することができる",
                    "そのなかに"    , "しようとしたりする"          , "たとえば"        ,
                    "がついている"  , "性の方向"    , "の様に"      , "起動"            ,
                    "積分系"        , "微分系"      , "完成形"      , "返還"            ,
                    "ギリシャ"                          , # ギリシア
                    "復讐"                              , # 復習
                    "表すことができる"                  , # 表せる
                    "先程"                              , # 先ほど
                    "その内の",                         , # そのうちの
                    "はたらく"                          , # 働く
                    "してる"                            , # している
                    "あたらく"                          , #「はたらく」のTypo
                    "許可書"                            , #「教科書」のTypo
                    "まず最初"                          , # 最初に だけで十分
                    "割り当て"                          , # 割当て
                    "成り立っている"                    , # 成立している
                    "何故"                              , # なぜ ひらがなで書く
                    "約束がされている"                  , # 約束されている
                    "正の方向"      , "負の方向"        , # "正/負方向" と書きたい
                    "書くことができる"                  , # "書ける" と表現すべき
                    "した時，"      , "する時，"        , # "時" をひらがなにしたい
                    "考えることができる"                , # "考えられる" に置き換えられるはず
                    "してない"                          , # "い抜き言葉" かもしれない
                    "Coulombの"                         , # クーロンの
                    "超伝導"                            , # "超電導"　に統一する
                    "おきてない"                        , # "おきていない"
                    "れてない"                          , # "れていない"
                    "じつは"                            , # "実は"
                    "dummy_XXXXXXXXXX_dummy"
        );

        while (<$fhr>) {
            $cnt_line++;
            for my $str (@NG_LIST) {
                $flg_check_NG += &strCheck($str, $cnt_file, $file, $cnt_line, $_);
            }
        }
        close($fhr);
    }
    printf("\nCheck Finish !!\n");
    if(-f $NG_LIST_FILE){
        open(my $fhr, "<:utf8" , $NG_LIST_FILE);
        while(<$fhr>){
            my $str = $_;
            #$str = encode('utf8', $str);
            print $str;
        }
        close($fhr);
    }
    printf("*** ALL FILE NUM: %04d%50s\n", $cnt_file, " ");
    if($flg_check_NG){
        printf("... ErrorNum: $flg_check_NG\n");
        printf("** Question:: OK ? (y/n)>>");
        my $tmp = <STDIN>; chomp($tmp);
        if (($tmp eq "y") || ($tmp eq "yes")){
        } else {
            exit(1);
        }
    }
}

sub strCheck()
{
    my ($str, $cnt_file,  $file, $cnt_line, $src) = @_;
    $src =~ s/^\s+/ /g;
    if($_ =~ /$str/){
        open(my $fhw, ">>:utf8" , $NG_LIST_FILE) or die $!;
        my $string = sprintf("FNUM%04d: <NG> [$str] $file ($cnt_line) $src", $cnt_file);
        printf($fhw "$string");
        close($fhw);
        return 1;
    } else {
        return 0;
    }
}

sub searchString()
{
    my ($str,@search_list) = @_;
    my $hitnum=0;
    my $cnt_target=0;
    for my $file (@search_list) {
        $cnt_target++;
        if($cnt_target<=2){next;}
        open(my $fhr, "<:utf8",$file) or die $!;
        my @str = <$fhr>;
        close($fhr);
        my $line = 0;
        for(@str){
            $line ++;
            if($_ =~ /$str/ig){
                $hitnum++;
                my $now_str = $_;
                chomp($now_str);
                $now_str =~ s/^\s+/ /g;
                $now_str =~ s/%/%%/g;
                printf("h%d/f%d: $file (%d) $now_str\n",$hitnum,$cnt_target,$line);
            }
        }
        if($line > $MaxLine){
            printf(">>> Warnings <<<   ${MaxLine}行を超えるファイル: $file(実際:${line}行)\n");
        }
    }
    if($hitnum){
        printf("... $hitnum HIT\n");
    }
    else{
        printf("... HITなし\n");
    }
    printf("... Target Num: $cnt_target files\n");
}


sub prepare_style()
{
    my $stylename=$_[0];
    chdir "sty_files/$stylename";

    printf("[Message] Make Style File : $stylename  ");

    my @dellist = glob("*.sty *.fd");
    for my $delfile (@dellist){
        if(-f $delfile){unlink $delfile;}
    }

    if(system("$tex_command $stylename.ins > make_$stylename.log")){
        printf(" --> XXX Fail XXX\n");
        return 0;
    }

    printf(" ---> Finish !!!\n");

    copy "$stylename.sty", "../../";

    chdir "../..";

    return 0;
}

sub eps2pdf()
{
    my @EPS_FILES = glob("*.eps");
    my $NUM_EPS   = @EPS_FILES;
    if($NUM_EPS){
        open(my $fhw, ">>:utf8" , "eps2pdf.log") or die $!;
        my $cnt=0;
        for(@EPS_FILES){
            $cnt++;
            my $cmd  = "epstopdf -embed $_";
            my $time = localtime();
            system($cmd);
            printf(     "(%3d/%3d) %s\n",$cnt ,$NUM_EPS ,"epstopdf $_");
            printf($fhw "$time, $cmd\n");
        }
        close($fhw);
    }
    else{
        printf(">>> Warnings <<<   eps file NOT exist.\n");
    }

    return 0;
}

sub archive()
{
    if(defined $ARGV[1]){
        my $V = '/';
        if($flg_windows){
            $V = '\\'
        }
        system("ruby script". $V ."archive.rb " . $ARGV[1]);
    }
    else{
        printf("[Error] Arg2: Version as Label\n");
    }
}

sub check_pdffonts()
{
    my @PDF_FILES = glob("*.pdf");
    my $NUM_PDF   = @PDF_FILES;
    if($NUM_PDF){
        my $cnt=0;
        for(@PDF_FILES){
            $cnt++;
            my $cmd  = "pdffonts $_";
            my $time = localtime();
            my @RESULT = `$cmd`;
            printf(     "(%3d/%3d) %s\n",$cnt ,$NUM_PDF ,"pdffonts $_");
            for(@RESULT){
                if(($_ =~ /no\s+yes\s+yes/) || ($_ =~ /no\s+no\s+yes/) || ($_ =~ /no\s+yes\s+no/) || ($_ =~ /no\s+no\s+no/)){
                    printf("X Error X: $_");
                    printf("\n");
                }
            }
        }
    }
    else{
        printf(">>> Warnings <<<   pdf file NOT exist.\n");
    }

    return 0;
}

sub chgenc_by_nkf_utf8()
{
    my @TEX_FILES = glob("*.sty *.cls *.tex *.idx *.log");
    my $NUM_TEX   = @TEX_FILES;
    if($NUM_TEX){
        my $cnt=0;
        for(@TEX_FILES){
            $cnt++;
            my $chkcmd  = "nkf -g $_";
            my $time = localtime();
            my $RESULT = `$chkcmd`;
            my $optL   = "-Lu -d";
            chomp($RESULT);
            if ($flg_windows){
                $optL = "-Lw -c";
            }
            if((defined $ARGV[2]) && ($ARGV[2] eq "-f")){
                    printf(" --> [Forced] ??? to UTF-8\n");
                    my $chgnkfcmd = sprintf("nkf -w %s -w8 --overwrite $_", $optL);
                    printf("     $chgnkfcmd\n");
                    system($chgnkfcmd);
            }
            elsif($RESULT =~ /BINARY/){
                printf("[Message](%3d) %-10s %s\n", $cnt, $RESULT, $_);
            }
            elsif($RESULT =~ /ASCII/){
                printf("[Message](%3d) %-10s %s\n", $cnt, $RESULT, $_);
            }
            elsif($RESULT =~ /UTF-8/){
                printf("[Message](%3d) %-10s %s\n", $cnt, $RESULT, $_);
            }
            else{
                printf("X Error X(%3d) %-10s %s\n"  , $cnt, $RESULT, $_);
                if((defined $ARGV[1]) && ($ARGV[1] eq "-t")){
                    printf(" --> to UTF-8\n");
                    my $chgnkfcmd = sprintf("nkf -w %s -w8 --overwrite $_", $optL);
                    printf("     $chgnkfcmd\n");
                    system($chgnkfcmd);
                }
            }
        }
    }
    else{
        printf(">>> Warnings <<<   tex file NOT exist.\n");
    }

    return 0;
}


sub help()
{
        printf( "----[Help]-------------------------------------------------"  . "\n");
        printf( " * remake        : cleanしてからコンパイル"                  . "\n");
        printf( " * chk           : スペルミスの確認"                         . "\n");
        printf( " * chkenc (-t)   : 文字エンコーディングの確認"               . "\n");
        printf( " * pdffonts      : PDFファイルの文字埋め込みの確認"          . "\n");
        printf( " * eps2pdf       : 全EPSファイルをPDFに変換するバッチ"       . "\n");
        printf( " * cmp           : LaTeX Compile"                            . "\n");
        printf( " * begin         : 作業開始コマンド"                         . "\n");
        printf( " * end           : 作業終了コマンド"                         . "\n");
        printf( " * search        : 文字列検索(grepもどき)"                   . "\n");
        printf( " * overwrite     : 複数ファイルに対して文字列置換"           . "\n");
        printf( " * view          : Veiw Result Document for check"           . "\n");
        printf( " * update        : Resutl document update"                   . "\n");
        printf( " * clean         : Current Directory Cleaning"               . "\n");
        printf( "   clean -r      : Recursive Clean Mode"                     . "\n");
        printf( " * archive [Ver] : Archive for backup(arg2=VersionLabel)"    . "\n");
        printf( " * help          : Display this help"                        . "\n");
        printf( "----------------------------------------------------------"  . "\n");

        return 0;
}
