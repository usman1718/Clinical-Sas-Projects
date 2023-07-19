****Sample Seizure Data as SDTM Clinical Events Domain;
data CE;
label	USUBJID = 'Unique Subject Identifier'
		CETERM = 'Reported Term for the Clinical Event'
		CEPRESP = 'Clinical Event Pre-Specified'
		CEOCCUR = 'Clinical Event Occurrence'
		CESTDTC = 'Start Date/Time of Clinical Event';
CETERM = 'Seizure';
CEPRESP = 'Y';
input USUBJID $ 1-3 CEOCCUR $ 5 CESTDTC $ 7-16;
datalines;
101 Y 2004-05-05
102 Y 2004-06-05
103 N 2004-07-05
104 Y 2004-05-05
105 N 2004-06-06
106 Y 2004-07-09
107 N 2004-05-07
108 Y 2004-03-08
109 N 2004-02-09
110 Y 2004-03-01
;
run;
*******End of study date as SDTM demographic domain;
data DM;
label	USUBJID ='Unique Subject Identifier'
		RFENDTC = 'Subject reference End Date/Time';
input USUBJID $ 1-3 RFENDTC $ 5-14;
datalines;
101 2004-08-05
102 2004-08-05
103 2004-08-05
104 2004-09-05
105 2004-09-06
106 2004-08-09
107 2004-09-07
108 2004-08-08
109 2004-09-09
110 2004-08-01
;
run;
******Sample dosing data as SDTM Exposure Domain;
data EX;
label	USUBJID = 'Unique Subject Identifier'
		EXSTDTC = 'Start Date/Time of Treatment';
input USUBJID $ 1-3 EXSTDTC $ 5-14;
datalines;
101 2004-01-05
102 2004-01-05
103 2004-01-05
104 2004-01-05
105 2004-01-06
106 2004-01-09
107 2004-01-07
108 2004-01-08
109 2004-01-09
110 2004-01-01
;
run;

*****Time to Seizure Analysis Dataset as CDISC ADAM Basic Data Structure Time to Event;
data ADSEIZ ;
	merge dm ex ce;
	by usubjid;
	
	PARAM = 'Time to Seizure (days) ';
	
	if ceterm = 'Seizure' and ceoccur = 'Y' then
	do;
		AVAL =	input(cestdtc,yymmdd10.) -
				input(exstdtc,yymmdd10.) + 1;
		CNSR = 0;
		ADT = input(cestdtc,yymmdd10.);
	end;
	else if ceterm = 'Seizure' and ceoccur = 'N' then
	do; 
		AVAL = 	input(rfendtc,yymmdd10.) -
				input(exstdtc,yymmdd10.) + 1;
		CNSR = 1;
		ADT = input(rfendtc,yymmdd10.);
		end;
		
	label 	PARAM = 'Time to Seizure (days) '
			AVAl = 'Analysis Value'
			ADT = 'Analysis Date'
			CNSR = 'Censor';
		format ADT date9.;
		run;
		
		proc print 
			data=adseiz;
			var usubjid param aval cnsr adt rfendtc exstdtc ceterm
				cepresp ceoccur cestdtc;
				run;
		