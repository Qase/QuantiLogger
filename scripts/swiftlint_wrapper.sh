#!/bin/sh

OUTPUT_FILE="tmp"


swiftlint 2>&1 | tee -a "$OUTPUT_FILE"

WARNINGS=$(tail -n 1 tmp | cut -d ' ' -f 4)
ERRORS=$(tail -n 1 tmp | cut -d ' ' -f 6)

rm tmp

if [ "$ERRORS" -gt "0" ]; then
    echo "Errors exist, total number of errors: " "$ERRORS" 
    exit 1  
fi

if [ "$WARNINGS" -gt "0" ]; then
    echo "Warnings exist, total number of warnings: " "$WARNINGS" 
    exit 1  
fi

exit 0

