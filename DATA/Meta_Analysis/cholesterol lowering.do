
clear
input trial year deaths1 pop1 deaths0 pop0 
1	1967	33	207	38	213	
2	1972	3	38	3	39	
3	1974	7	114	14	116	
4	1974	5	69	11	93	
5	1975	102	1533	127	1520	
6	1979	1	11	1	11	
7	1979	61	238	62	242	
8	1980	4	59	6	52	
9	1980	28	355	27	365	
10	1980	17	132	19	129	
11	1980	19	127	19	129	
12	1981	40	698	62	697	
13	1981	98	945	152	939	
14	1982	25	278	37	282	
15	1982	64	873	52	583	
16	1982	138	1916	188	1921	
17	1982	60	632	48	471	
18	1983	9	273	16	280	
19	1983	25	154	31	147	
20	1983	45	263	47	266	
21	1984	5	101	11	103	
22	1984	57	853	45	883	
23	1985	49	416	52	348	
24	1987	7	102	12	98	
25	1987	86	1195	93	1200	
26	1988	3	25	3	25	
27	1990	17	298	34	309	
28	1992	2	48	12	56	
29	1993	17	130	9	123	
30	1992	15	437	27	432	
31	1995	3	23	1	24	
32	1997	2	75	3	71	
33	1997	44	79	60	79	
end

generate alive1=pop1-deaths1
generate alive0=pop0-deaths0

generate logor=log((deaths1/alive1)/(deaths0/alive0))
generate selogor=sqrt((1/deaths1)+(1/alive1)+(1/deaths0)+(1/alive0))
save "C:\DATA\Meta_Analysis\betablocker.dta", replace

exit


clear
input str2 trialnam pop1 pop0 cure1 cure0
1 154 155 67 69
2 146 142 49 48
3 174 87 166 83
4 13 16 9 10
5 129 59 117 56
end
generate nocure1=pop1-cure1
generate nocure0=pop0-cure0
generate logor=log((cure1/nocure1)/(cure0/nocure0))
generate selogor=sqrt((1/cure1)+(1/nocure1)+(1/cure0)+(1/nocure0))


save "C:\DATA\Meta_Analysis\antibiotic.dta", replace
exit

clear
input str2 trialnam pop1 pop0 deaths1 deaths0 chd1 chd0
1 204 202 28 51 25 45	
2 285 147 70 38 62 35	
3 156 119 37 40 34 39	
4 88 30 2 3 2 2	
5 30 33 0 3 0 2	
6 279 276 61 82 47 73	
7 206 206 41 55 37 50	
8 123 129 20 24 17 20	
9 1018 1015 111 113 97 97	
10 427 143 81 27 71 23	
11 244 253 31 51 25 44	
12 50 50 17 12 13 10	
13 47 48 23 20 13 5	
14 30 60 0 4 0 4	
15 5552 2789 1025 723 826 632	
16 424 422 174 178 41 50	
17 199 194 28 31 25 25	
18 350 367 42 48 34 35	
19 79 78 4 5 2 4	
20 1149 1129 37 48 19 31	
21 221 237 39 28 35 26	
22 54 26 8 1 8 1	
23 71 72 5 7 5 6	
24 4541 4516 269 248 61 54	
25 421 417 49 62 32 44	
26 94 94 0 1 0 1	
27 311 317 19 12 17 8	
28 1906 1900 68 71 32 44	
29 2051 2030 44 43 14 19	
30 6582 1663 33 3 28 3	
31 5331 5296 236 181 91 77	
32 48 49 0 1 0 0	
33 94 52 1 0 1 0	
34 23 29 1 2 1 0	
end

generate alive1=pop1-deaths1
generate alive0=pop0-deaths0
generate n_chd1=pop1-chd1
generate n_chd0=pop0-chd0

foreach X of varlist  deaths1 deaths0 chd1 chd0 alive1 alive0 n_chd1 n_chd0 {
replace `X'=`X'+0.5
}

generate logor=log((deaths1/alive1)/(deaths0/alive0))
generate selogor=sqrt((1/deaths1)+(1/alive1)+(1/deaths0)+(1/alive0))
generate logorchd=log((chd1/n_chd1)/(chd0/n_chd0))
generate selogorchd=sqrt((1/chd1)+(1/alive1)+(1/deaths0)+(1/alive0))

foreach X of varlist  deaths1 deaths0 chd1 chd0 alive1 alive0 n_chd1 n_chd0 {
replace `X'=`X'-0.5
}

save "C:\DATA\Meta_Analysis\cholesterol.dta", replace
exit

metan deaths1 alive1 deaths0 alive0, rr xlab(.1,1,10) label(namevar=trialnam)


meta logor selogor, eform graph(f) cline xline(1) xlab(.1,1,10) id(trialnam) b2title(Odds ratio) print
