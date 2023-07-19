

proc import out=my_data
    datafile='/home/u59687616/category.xlsx'
    dbms=xlsx
    replace;
    getnames=YES;
run;

****Define variable formats needed for table;
proc format;
	value trtpn
		1 = "Active"
		0 = "Placebo";
	value sexn
		. = "Missing"
		1 = "Male"
		2 = "Female";
	value racen
		1 = "White"
		2 = "Black"
		3 = "Other*";
run;

******Create summary of demographics with proc tabulate;
options nodate nonumber missing = ' ';
ods escapechar = '#';
ods pdf style = htmlblue file = 'saspractice.pdf';

proc tabulate 
	data =my_data
	missing;
	class trtpn sexn racen;
	var age;
	table age = 'Age' * (n = 'n' * f = 8. mean = 'Mean' * f = 5.1
							std = 'Standard Deviation' * f = 5.1
							min = 'Min' * f = 3. Max = 'Max' * f = 3.)
		  sexn = 'Sex' * (n = 'n' * f = 3. colpctn = '%' * f = 4.1)
		  racen = 'Race' * (n = 'n' * f = 3. colpctn = '%' * f = 4.1) ,
		  	(trtpn = " ") (all = 'Overall') ;
	format trtpn trtpn. racen racen. sexn sexn.;
	title1 j=l 'Medcomplytics/RX8777'
		   j=r 'Page #{thispage} of #{lastpage}';
	title2 j=c 'Table 5.1';
	title3 j=c 'Demographics and Baseline Characteristics';
	footnote1 j=l '* Other includes Asian , Native American , and other' 'races.';
	footnote2 j=l 
				"Created by %sysfunc(getoption(sysin)) on &sysdate9..";
				run;
				ods pdf close;