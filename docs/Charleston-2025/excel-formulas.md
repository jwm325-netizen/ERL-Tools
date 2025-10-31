---
sidebar_position: 1
---

# Helpful Excel Formulas

Here are examples of a few of the Excel formulas we used to manipulate data as a part of our bound journal weeding project.

## TEXTJOIN:

We had several columns that displayed coverage from various backfile purchases and we wanted to merge them into a single column with some sort of delimiter. 

Initially we used Excel's CONCATENATE function, but since we applied no logic to it, the empty cells ended up containing just the delimiters. 

So, instead we used the TEXTJOIN function.

### Example spreadsheet data:

|JSTOR|Springer Backfile Purchase 2016|ScienceDirect Backfile Purchase 2019|
|-----------|----------|-----------|
|JSTOR, 1975-2019|Springer Backfile 2016, 1975-present||

This formula will merge the three columns above with a semicolon as the delimiter and will ignore blank cells:

```=TEXTJOIN(";",TRUE,A1,B1,C1)```

## INDEX MATCH

This function will index the column that contains the data you would like to add to your sheet and match the identifier for that row (ISSN, OCLC number, etc) to data in a range that you specify.

If a unique identifier is available, INDEX MATCH can be used to bring data from other sources into a column in a spreadsheet. 

The data should be either imported through the Get Data function on the Data tab in Excel, or pasted into a new sheet. 

:::note 
It helps to format the data in both sheets as a table- allowing easy reference to ranges

:::

### Example:

```scala =IFERROR(INDEX(NewTable[Coverage], MATCH(A2,NewTable[ISSN],0)),"")```

In this example, the imported data is in a table named **NewTable** and the imformation we want to retrieve in our new column is in a column named **Coverage**. 

### Breakdown of the formula by Function:

IFERROR: If the INDEX and MATCH functions return an error, the formula returns a blank cell, represented by the empty quotation marks at the end of the formula. 

INDEX: Indexes the Coverage column in NewTable

MATCH: Matches the data in cell A2 in the destination table with the data in the ISSN column of NewTable if it is an excact match. 



