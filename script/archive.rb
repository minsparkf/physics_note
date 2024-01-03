# coding: Shift_JIS
require "date"
require "fileutils"

def archive(arg1)
    if arg1.nil?
        printf("%s) Argument Error(Arg1=LabelString)\n", $0)
        exit(1)
    end

    # setting
    label   = arg1
    mx      = 9
    mfb     = 256

    # don't touch !!
    cmd         = "7z a"
    opt         = sprintf("-mx=%d -mfb=%d", mx, mfb)
    ofname      = sprintf("02PhysicsNote_ver2nd_%s.7z", label)
    target      =  "0Result "
    target      += "aux_files "
    target      += "bat_files "
    target      += "cls_files "
    target      += "csv_files "
    target      += "dvi_files "
    target      += "edf_files "
    target      += "eps_files "
    target      += "Excel_files "
    target      += "font_files "
    target      += "jpg_files "
    target      += "map_files "
    target      += "odf_files "
    target      += "odg_files "
    target      += "ods_files "
    target      += "pdf_files "
    target      += "ppt_files "
    target      += "run.pl "
    target      += "script "
    target      += "sty_files "
    target      += "tex_files "

    print sprintf("%s) DicSize=%d, ArchiveRatio=%d\n", $0, mfb, mx)

    system(sprintf("%s %s %s %s", cmd, opt, ofname, target))
end


archive(ARGV[0]) if $0 == __FILE__
