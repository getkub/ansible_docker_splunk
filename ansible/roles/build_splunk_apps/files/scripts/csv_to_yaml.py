
#
# https://blog.jasoncallaway.com/2017/12/08/parsing-csv-into-an-ansible-vars_file/
import csv
import sys
import yaml

# Input a CSV file and using its headers , create a YAML file
inputCSV = sys.argv[1]
outputYML = sys.argv[2]

with open(inputCSV) as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        outputYML.append(row)

with open(outputYML + '.yml', 'w') as outfile:
    outfile.write(yaml.dump({'outputYML': outputYML}))
