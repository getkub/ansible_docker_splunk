import csv
import json
import sys

# Input a CSV file and using its headers , create a JSON file
inputCSV = sys.argv[1]
outputJSON = sys.argv[2]

# input CSV
with open(inputCSV) as f:
    reader = csv.DictReader(f)
    rows = list(reader)

# output JSON
with open(outputJSON, 'w') as f:
    json.dump(rows, f)
