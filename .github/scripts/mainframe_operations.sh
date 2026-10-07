#!/bin/bash
# mainframe_operations.sh

# Set up environment
export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64
export PATH=$PATH:/usr/lpp/zowe/cli/node/bin

# Check Java availability
java -version

# Set ZOWE_USERNAME
ZOWE_USERNAME="Z87663"

# Change to the cobolcheck directory (stop if it doesn't exist)
cd cobolcheck || { echo "ERREUR : dossier cobolcheck introuvable"; exit 1; }
echo "Changed to $(pwd)"
ls -al

# Make script in scripts directory executable
cd scripts
chmod +x linux_gnucobol_run_tests
echo "Made linux_gnucobol_run_tests executable"
cd ..

# Function to run cobolcheck and copy files
run_cobolcheck() {
  program=$1
  echo "Running cobolcheck for $program"

  # Remove the file generated for the previous program
  rm -f "testruns/CC##99.CBL"

  # Run cobolcheck, but don't exit if it fails
  java -jar bin/cobol-check-0.2.19.jar -p "$program"
  echo "Cobolcheck execution completed for $program (exceptions may have occurred)"

  # Check if CC##99.CBL was created, regardless of cobolcheck exit status
  if [ -f "testruns/CC##99.CBL" ]; then
    if cp "testruns/CC##99.CBL" "//'${ZOWE_USERNAME}.CBL($program)'"; then
      echo "Copied CC##99.CBL to ${ZOWE_USERNAME}.CBL($program)"
    else
      echo "Failed to copy CC##99.CBL to ${ZOWE_USERNAME}.CBL($program)"
    fi
  else
    echo "CC##99.CBL not found for $program"
  fi

  # Copy the JCL file if it exists
  if [ -f "${program}.JCL" ]; then
    if cp "${program}.JCL" "//'${ZOWE_USERNAME}.JCL($program)'"; then
      echo "Copied ${program}.JCL to ${ZOWE_USERNAME}.JCL($program)"
    else
      echo "Failed to copy ${program}.JCL to ${ZOWE_USERNAME}.JCL($program)"
    fi
  else
    echo "${program}.JCL not found"
  fi
}

# Run for each program
for program in NUMBERS EMPPAY DEPTPAY; do
  run_cobolcheck "$program"
done

echo "Mainframe operations completed"
