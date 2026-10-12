       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOYENNES.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NOTES-FILE ASSIGN TO NOTESIN
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-FS.
       DATA DIVISION.
       FILE SECTION.
       FD  NOTES-FILE
           RECORDING MODE F.
       01  NOTES-REC                PIC X(300).
       WORKING-STORAGE SECTION.
       01  WS-FS                    PIC XX.
       01  WS-EOF                   PIC X VALUE 'N'.
           88  END-OF-FILE                VALUE 'Y'.
       01  WS-LINE                  PIC X(300).
       01  WS-IDX                   PIC 99.
       01  WS-SOMME                 PIC 9(3)V99.
       01  WS-MOY-EDIT              PIC Z9.99.
       01  WS-STUDENT.
           05  WS-NOM               PIC X(20).
           05  WS-PRENOM            PIC X(20).
           05  WS-NOTE-TXT          PIC X(6) OCCURS 5.
           05  WS-NOTE              PIC 99V99 OCCURS 5.
           05  WS-MOY-ELEVE         PIC 99V99.
       01  WS-TOTALS.
           05  WS-NB-ELEVES         PIC 9(3).
           05  WS-TOTAL-MAT         PIC 9(5)V99 OCCURS 5.
           05  WS-MOY-MAT           PIC 99V99 OCCURS 5.
       01  WS-MATIERES.
           05  FILLER               PIC X(10) VALUE 'MATHS'.
           05  FILLER               PIC X(10) VALUE 'PHYSIQUE'.
           05  FILLER               PIC X(10) VALUE 'CHIMIE'.
           05  FILLER               PIC X(10) VALUE 'DROIT'.
           05  FILLER               PIC X(10) VALUE 'BIOLOGIE'.
       01  WS-MAT-TABLE REDEFINES WS-MATIERES.
           05  WS-MAT-NOM           PIC X(10) OCCURS 5.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INIT-TOTALS.
           OPEN INPUT NOTES-FILE.
           IF WS-FS NOT = '00'
               DISPLAY "ERREUR OUVERTURE NOTESIN, STATUS " WS-FS
               MOVE 8 TO RETURN-CODE
               GOBACK
           END-IF.
           PERFORM READ-RECORD.
           PERFORM READ-RECORD.
           PERFORM UNTIL END-OF-FILE
               PERFORM PROCESS-STUDENT
               PERFORM READ-RECORD
           END-PERFORM.
           CLOSE NOTES-FILE.
           PERFORM COMPUTE-SUBJECT-AVG.
           PERFORM SHOW-SUBJECT-AVG.
           GOBACK.

       INIT-TOTALS.
           INITIALIZE WS-TOTALS.

       READ-RECORD.
           READ NOTES-FILE INTO WS-LINE
               AT END SET END-OF-FILE TO TRUE
           END-READ.

       PROCESS-STUDENT.
           PERFORM PARSE-LINE.
           PERFORM COMPUTE-STUDENT-AVG.
           PERFORM ACCUMULATE-TOTALS.
           PERFORM SHOW-STUDENT.

       PARSE-LINE.
           INITIALIZE WS-STUDENT.
           UNSTRING WS-LINE DELIMITED BY ','
               INTO WS-NOM WS-PRENOM
                    WS-NOTE-TXT (1) WS-NOTE-TXT (2) WS-NOTE-TXT (3)
                    WS-NOTE-TXT (4) WS-NOTE-TXT (5)
           END-UNSTRING.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 5
               COMPUTE WS-NOTE (WS-IDX) =
                   FUNCTION NUMVAL(WS-NOTE-TXT (WS-IDX))
           END-PERFORM.

       COMPUTE-STUDENT-AVG.
           MOVE ZERO TO WS-SOMME.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 5
               ADD WS-NOTE (WS-IDX) TO WS-SOMME
           END-PERFORM.
           COMPUTE WS-MOY-ELEVE ROUNDED = WS-SOMME / 5.

       ACCUMULATE-TOTALS.
           ADD 1 TO WS-NB-ELEVES.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 5
               ADD WS-NOTE (WS-IDX) TO WS-TOTAL-MAT (WS-IDX)
           END-PERFORM.

       COMPUTE-SUBJECT-AVG.
           IF WS-NB-ELEVES > 0
               PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 5
                   COMPUTE WS-MOY-MAT (WS-IDX) ROUNDED =
                       WS-TOTAL-MAT (WS-IDX) / WS-NB-ELEVES
               END-PERFORM
           END-IF.

       SHOW-STUDENT.
           MOVE WS-MOY-ELEVE TO WS-MOY-EDIT.
           DISPLAY FUNCTION TRIM(WS-PRENOM) " "
                   FUNCTION TRIM(WS-NOM) " : " WS-MOY-EDIT.

       SHOW-SUBJECT-AVG.
           DISPLAY "----------------------------------".
           DISPLAY "NOMBRE D'ELEVES : " WS-NB-ELEVES.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 5
               MOVE WS-MOY-MAT (WS-IDX) TO WS-MOY-EDIT
               DISPLAY "MOYENNE " WS-MAT-NOM (WS-IDX) " : " WS-MOY-EDIT
           END-PERFORM.
