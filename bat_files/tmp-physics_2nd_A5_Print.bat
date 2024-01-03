@echo off
rm -rf physics_2nd_A5_Print.pdf
title uplatex 1:  physics_2nd_A5_Print
uplatex -shell-escape physics_2nd_A5_Print >  platex_log1_physics_2nd_A5_Print.log
title uplatex 2:  physics_2nd_A5_Print
uplatex -shell-escape physics_2nd_A5_Print >  platex_log2_physics_2nd_A5_Print.log
title uplatex 3:  physics_2nd_A5_Print
uplatex -shell-escape physics_2nd_A5_Print >  platex_log3_physics_2nd_A5_Print.log
title dvipdfmx :  physics_2nd_A5_Print
start dvipdfmx -V 7 -vv  -f uptex-ipa.map -f dlbase14.map  -p a5  physics_2nd_A5_Print
exit

