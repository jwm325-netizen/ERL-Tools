---
sidebar_position: 1
---

# Fetch ISSNs from CrossRef API by Title in Google Sheets

Using a Google Sheet of journal title metadata without identifiers, fetch ISSNs from CrossRef using cleaned/normalized journal titles. 

From your Sheets file, navigate to Extensions>Apps Script and paste the following:

```python
function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu('CrossRef Tools')
    .addItem('Fetch ISSNs (Clean & Overwrite)', 'fillColumnI')
    .addToUi();
}

function fillColumnI() {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var ui = SpreadsheetApp.getUi();

  // --- SETTINGS ---
  var startRow = 2;       // Data starts at Row 2
  var titleCol = 1;       // Column A = 1
  var destinationCol = 9; // Column I = 9
  // ----------------

  var lastRow = sheet.getLastRow();

  if (lastRow < startRow) {
    ui.alert("No data found starting at row " + startRow);
    return;
  }

  SpreadsheetApp.getActiveSpreadsheet().toast("Cleaning titles & fetching ISSNs...", "Starting");

  // 1. Get Titles from Column A
  var numRows = lastRow - startRow + 1;
  var titles = sheet.getRange(startRow, titleCol, numRows, 1).getValues();
  
  var outputValues = [];
  var count = 0;

  // 2. Loop through EVERY title
  for (var i = 0; i < titles.length; i++) {
    var rawTitle = titles[i][0];
    
    if (rawTitle && rawTitle.toString().trim() !== "") {
      
      // --- CLEANING LOGIC ---
      var cleanedTitle = rawTitle.toString();
      
      // Step A: Remove anything in parentheses (and the parens themselves)
      // regex: \s* matches leading space, \( matches opening (, .*? matches content, \) matches closing )
      cleanedTitle = cleanedTitle.replace(/\s*\(.*?\)/g, '');
      
      // Step B: Replace punctuation with a space (prevents "Word-Word" becoming "WordWord")
      // regex: [^\w\s] means "match anything that is NOT a word character or whitespace"
      cleanedTitle = cleanedTitle.replace(/[^\w\s]/g, ' ');
      
      // Step C: Collapse multiple spaces into one and trim edges
      cleanedTitle = cleanedTitle.replace(/\s+/g, ' ').trim();
      
      // --- API CALL ---
      var result = fetchIssnFromApi(cleanedTitle);
      outputValues.push([result]);
      count++;
      
      // Progress indicator
      if (count % 10 === 0) {
        SpreadsheetApp.getActiveSpreadsheet().toast("Processed " + count + " rows...", "In Progress");
      }

      // Pause to respect API limits
      Utilities.sleep(200); 
      
    } else {
      outputValues.push([""]);
    }
  }

  // 3. Write to Column I (Overwrite)
  sheet.getRange(startRow, destinationCol, outputValues.length, 1).setValues(outputValues);
  
  ui.alert("Finished! Cleaned and processed " + count + " titles.");
}

// --- API HELPER ---
function fetchIssnFromApi(journalTitle) {
  if (!journalTitle) return "";

  var encodedTitle = encodeURIComponent(journalTitle);
  var url = "https://api.crossref.org/journals?query=" + encodedTitle;

  try {
    var response = UrlFetchApp.fetch(url, { muteHttpExceptions: true });
    
    if (response.getResponseCode() !== 200) return "API Error";

    var json = JSON.parse(response.getContentText());

    if (json.message && json.message.items && json.message.items.length > 0) {
      var firstResult = json.message.items[0];
      
      if (firstResult.ISSN && firstResult.ISSN.length > 0) {
        return firstResult.ISSN[0];
      }
    }
    return "Not Found";

  } catch (e) {
    return "Error";
  }
}
##
```
