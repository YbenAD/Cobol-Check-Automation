       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYTEST2.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WHO        PIC X(15).
       77  WHERE      PIC X(20).
       77  WHY        PIC X(30).
       77  RATE       PIC 9(3).
       77  HOURS      PIC 9(3).
       77  GROSS-PAY  PIC 9(5).
       77  SUPPL      PIC 9(3).
       77  T-SUP      PIC 9V99.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INITIALIZATION.
           PERFORM COMPUTE-GROSS-PAY.
           PERFORM SHOW-OUTPUT.
           GOBACK.

       INITIALIZATION.
           MOVE "Alex Delors" TO WHO.
           MOVE "Viarolo, Parma" TO WHERE.
           MOVE "Learn to be a COBOL expert" TO WHY.
           MOVE 45 TO HOURS.
           MOVE 25 TO RATE.
           MOVE .30 TO T-SUP.

       COMPUTE-GROSS-PAY.
           IF HOURS > 40
             COMPUTE SUPPL = HOURS - 40
             COMPUTE GROSS-PAY = RATE * (HOURS + SUPPL * (1 + T-SUP))
           ELSE
             COMPUTE GROSS-PAY = HOURS * RATE
           ENDIF.

       SHOW-OUTPUT.
           DISPLAY "Name: " WHO.
           DISPLAY "Location: " WHERE.
           DISPLAY "Reason: " WHY.
           DISPLAY "Hours Worked: " HOURS.
           DISPLAY "Hourly Rate: " RATE.
           DISPLAY "Gross Pay: " GROSS-PAY.
           DISPLAY WHY " from " WHO.
