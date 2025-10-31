---
sidebar_position: 3
---

# Python Scripts

In some cases, the only title list we had available was in an addendum to a license agreement. We wanted to be able to match the list to a Knowledge Base package to ensure that our holdings were accurate but there was no easy way to derive useable structured data from the PDF so we created a python script that can extract just the ISSN numbers. 

## Process

1. Ensure that the PDF file is searchable. If it is not, use Adobe Acrobat's Scan and OCR function.
2. Copy and paste the data from the title list portion of the document into a file named ``input.txt`` in a folder that will also contain the python script.
3. Create the following script using a plaintext editor making sure to give it a ```.py``` file extension:
```python
import csv
import re

def extract_issns(input_file="input.txt", output_file="issns.csv"):
    """
    Extracts ISSNs (4-digit-hyphen-4-digit or 4-digit-hyphen-3-digit-X patterns)
    from a plaintext file and writes them to a single-column CSV file named "issns.csv".
    """

    try:
        with open(input_file, 'r', encoding='utf-8') as infile, \
             open(output_file, 'w', newline='', encoding='utf-8') as outfile:

            csv_writer = csv.writer(outfile)
            csv_writer.writerow(["ISSN"])  # Write header

            for line in infile:
                # Find all ISSN patterns in the line
                issns = re.findall(r'\d{4}-\d{3}[\dX]', line)
                for issn in issns:
                    csv_writer.writerow([issn])

        print(f"Successfully extracted ISSNs from '{input_file}' and created '{output_file}'")

    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    extract_issns()

##
```
When run, the srcipt will create the file ```issns.csv``` that will consist of a single column with all ISSNs derived from the input data. 
