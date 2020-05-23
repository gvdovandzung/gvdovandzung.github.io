*! version 1.0.0  19apr1995
program define cstddlg
	version 5.0

	precmd cstddlg
	global D_sm1 = 15
	global D_sm2 = 10
	global coldel = 2+$D_sm1
	global rowdel = 2+$D_sm2
	global winht =  13*$rowdel
	global winwd =  7+5*$coldel
	global btnwd = 2*$D_sm1+2
	global expwd = 4*$D_sm1+6
	global row1 = 17
	global col1 = 10
	global col2 = $col1 + $coldel 
	global col3 = $col2 + $coldel
	global col4 = $col3 + $coldel
	global row2 = $row1 + $rowdel
	global row3 = $row2 + $rowdel
	global row4 = $row3 + $rowdel
	global row5 = $row4 + $rowdel
	global row6 = $row5 + $rowdel
	global row7 = $row6 + $rowdel
	global row8 = $row7 + $rowdel
	global row9 = $row8 + $rowdel
	global row10 = $row9 + $rowdel
	window control button "0" $col2 $row7 $D_sm1 $D_sm2 D_bz
	window control button "1" $col2 $row6 $D_sm1 $D_sm2 D_b1
	window control button "2" $col3 $row6 $D_sm1 $D_sm2 D_b2
	window control button "3" $col4 $row6 $D_sm1 $D_sm2 D_b3
	window control button "4" $col2 $row5 $D_sm1 $D_sm2 D_b4
	window control button "5" $col3 $row5 $D_sm1 $D_sm2 D_b5
	window control button "6" $col4 $row5 $D_sm1 $D_sm2 D_b6
	window control button "7" $col2 $row4 $D_sm1 $D_sm2 D_b7
	window control button "8" $col3 $row4 $D_sm1 $D_sm2 D_b8
	window control button "9" $col4 $row4 $D_sm1 $D_sm2 D_b9
	window control button "-" $col1 $row4 $D_sm1 $D_sm2 D_bs
	window control button "+" $col1 $row5 $D_sm1 $D_sm2 D_bp
	window control button "x" $col1 $row6 $D_sm1 $D_sm2 D_bm
	window control button "/" $col1 $row7 $D_sm1 $D_sm2 D_bd
	window control button "sin" $col1 $row3 $D_sm1 $D_sm2 D_bsin
	window control button "cos" $col2 $row3 $D_sm1 $D_sm2 D_bcos
	window control button "sqrt" $col3 $row3 $D_sm1 $D_sm2 D_bsqr
	window control button "y^x" $col4 $row3 $D_sm1 $D_sm2 D_byx
	window control button "1/x" $col1 $row2 $D_sm1 $D_sm2 D_binv
	window control button "log" $col2 $row2 $D_sm1 $D_sm2 D_blog
	window control button "exp" $col3 $row2 $D_sm1 $D_sm2 D_bexp
	window control button "+/-" $col4 $row2 $D_sm1 $D_sm2 D_bchs
	window control button "." $col3 $row7 $D_sm1 $D_sm2 D_bper
	window control button "cls" $col4 $row7 $D_sm1 $D_sm2 D_bcls
	
	window control button "=" $col2 $row8 $btnwd $D_sm2 D_bent
	
	window control button "Quit" $col1 $row10 $btnwd $D_sm2 D_quit
	window control button "Help" $col3 $row10 $btnwd $D_sm2 D_help help
	
	global fx = $col1-1
	global fy = $expwd+2
       	window control static D_sm4 9 9 $fy 12 blackframe
	window control static D_exp $col1 10 $expwd 10 right

        global D_bz "calcstd addchar 0"
        global D_b1 "calcstd addchar 1"
        global D_b2 "calcstd addchar 2"
        global D_b3 "calcstd addchar 3"
        global D_b4 "calcstd addchar 4"
        global D_b5 "calcstd addchar 5"
        global D_b6 "calcstd addchar 6"
        global D_b7 "calcstd addchar 7"
        global D_b8 "calcstd addchar 8"
        global D_b9 "calcstd addchar 9"
	global D_bper "calcstd addchar ."
	global D_bcls "global D_exp 0"
	global D_bent "calcstd enter"
	global D_bs "calcstd sub"
	global D_bp "calcstd sum"
	global D_bm "calcstd mul"
	global D_bd "calcstd div"
	global D_bchs "calcstd chs"
	global D_bsin "calcstd sin"
	global D_bcos "calcstd cos"
	global D_bexp "calcstd exp"
	global D_blog "calcstd log"
	global D_bsqr "calcstd sqrt"
	global D_binv "calcstd inv"
	global D_byx "calcstd yupx"
	global D_quit "exit 3000"
	global D_help "whelp cstddlg"
	
	global D_clr "1"
	global D_exp 0
	
	
	capture noisily window dialog "Calculator" . . $winwd $winht
	
       	global D_bz
	global D_bs
	global D_bp
	global D_bd
	global D_bm
	global D_bexp
	global D_byx
	global D_binv
	global D_bchs
	global D_bsin
	global D_bcos
	global D_blog
	global D_bsqr
	global winwd
	global winht
	global row1
	global row2
	global row3
	global row4
	global row5
	global row6
	global row7
	global row8
	global col1
	global col2
	global col3
	global col4
	global coldel
	global rowdel
	global winht
	global winwd
	global btnwd
	global expwd
	global D_clr
end
