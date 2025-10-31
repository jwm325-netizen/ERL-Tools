---
sidebar_position: 1
---

# Helpful Excel Formulas

Here are examples of a few of the Excel formulas we used to manipulate data as a part of our bound journal weeding project:

## TEXTJOIN:

We had several columns that displayed coverage from various backfile purchases and we wanted to merge them into a single column with some sort of delimiter. 

Initially we used Excel's CONCATENATE function, but since we applied no logic to it, the empty cells ended up containing just the delimiters. 

So, instead we used the TEXTJOIN function.

Example spreadsheet data:

|JSTOR|Springer Backfile Purchase 2016|ScienceDirect Backfile Purchase 2019|
|-----------|----------|-----------|
|JSTOR, 1975-2019|Springer Backfile 2016, 1975-present||

This formula will merge the three columns above with a semicolon as the delimiter and will ignore blank cells:

```=TEXTJOIN(";",TRUE,A1,B1,C1)```
