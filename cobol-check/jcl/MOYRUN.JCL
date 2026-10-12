//MOYRUNJ  JOB 1,NOTIFY=&SYSUID
//***************************************************
//* Execution reelle de MOYENNES sur Z87663.NOTES.CSV
//***************************************************
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD PATHOPTS=ORDONLY,FILEDATA=TEXT,
//  PATH='/z/z87663/cobolcheck/src/main/cobol/MOYENNES.CBL'
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(MOYRUN),DISP=SHR
//***************************************************
// IF RC LE 4 THEN
//RUN     EXEC PGM=MOYRUN
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//NOTESIN   DD DSN=&SYSUID..NOTES.CSV,DISP=SHR
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
// ENDIF
