#! /usr/bin/perl -w
my $input="";
printf("置換対象ファイル指定: ");
$input = <STDIN>;
chomp($input);
my @flist   = glob("$input");
my $filenum = @flist;
for(my $i=0; $i<$filenum; $i++){
    printf("$flist[$i]\n");
}
system("\\tar czf archive.tar.gz $input");   
printf("--> archive.tar.gz に圧縮バックアップを取りました\n");

printf("検索文字列指定: ");
$prestr = <STDIN>;
chomp($prestr);
printf("置換文字列指定: ");
$outstr = <STDIN>;
chomp($outstr);
printf("置換を開始します(y/n): ");
$input = <STDIN>;
chomp($input);
if(($input eq "y")||($input eq "yes")){
    my $count = 0;
    for my $file (@flist){
        open(my $fhr, "<$file") or die $!;
        my @fline = <$fhr>;
        close($fhr);
        open(my $fhw, ">$file") or die $!;
        my $line = 0;
        for my $str (@fline){
            $line++;
            if($str =~ /\Q$prestr\E/){
                $count++;
                printf("[置換前] $file (%04d) <$str", $line);
                $str =~ s/\Q$prestr\E/$outstr/g;
                printf("[置換後] $file (%04d) >$str", $line);
            }
            $str =~ s/\Q%\E/%%/g;
            printf ($fhw "$str"); 
        }
        close($fhw);
    }
    if($count){
        printf("$count 箇所の置換を実行しました．\n");
    }
    else{
        printf("置換対象文字列が見つかりませんでした．");
    }
}
else{
    printf("==> 置換を実行せずに，終了しました\n");
    exit(1);
}

exit 0;

