---
sidebar_position: 2
---

# WorldCat API + OpenRefine

For known backfile purchases with license terms documented,  we used the WorldCat Knowledge Base API find coverage for titles.

## Calling the API from OpenRefine
1. Select the correct package in OCLC Collection Manager.
2. After title indexing is complete, the package can be searched via the KB API.
3. In OpenRefine, import a spreadsheet containing titles and ISSN numbers.
4. Using the ISSN column: Edit column>Add column by fetching URLs.
5. Name the column.
6. Use the following GREL expression to call the KB API, replacing ```COLLECITON_ID_IN_COLLECTION_MANAGER``` with the ID for the collection you are searching, and replacing ```YOUR_API_KEY``` with the API key provided by OCLC:
```
http://worldcat.org/webservices/kb/rest/entries/search?q="+value+"&collection_uid=COLLECTION_ID_IN COLLECTION_MANAGER&startIndex=1&search-type=search&itemsPerPage=10&scope=my&orderBy=title+asc&institution_id=6569?&wskey=YOUR_API_KEY"
```
The new cells in the new column will be populated with the results of the API call in JSON format. For cells that matched an entry in the KB, the JSON will look something like this:
```json
{
  "author" : "OCLC",
  "entries" : [ {
    "sourceInstitution" : "6569",
    "kb:collection_name" : "JSTOR Archival Journals and Primary Sources Collection",
    "kb:collection_uid" : "jstor.titlelist",
    "kb:coverage" : "fulltext@1939-11-01~2023-10-01",
    "kb:coverage_enum" : "fulltext@volume:1;issue:1~volume:80;issue:1",
    "published" : "2025-03-21T19:12:04Z",
    "kb:entry_uid" : "e3161246-7880-4fd1-b3ac-b2cbcd2b06f5-emi",
    "kb:issn" : "0032-8456",
    "kb:jkey" : "prinunivlibrchro",
    "kb:oclcnum" : "568032989",
    "kb:provider_name" : "JSTOR",
    "kb:provider_uid" : "jstor",
    "kb:publisher" : "Princeton University Library",
    "id" : "http://worldcat.org/webservices/kb/rest/entries/jstor.titlelist,e3161246-7880-4fd1-b3ac-b2cbcd2b06f5-emi",
    "links" : [ {
      "href" : "https://www.jstor.org/journal/prinunivlibrchro",
      "rel" : "canonical"
    }, {
      "href" : "https://linker2.worldcat.org/?jHome=https%3A%2F%2Fwww.jstor.org%2Fjournal%2Fprinunivlibrchro&linktype=best&jHomeSig=b2050f2b1c3762b3ddfd5f9f46c2f55b8594f314a38aa0884f755695aa3d361e",
      "rel" : "via"
    }, {
      "href" : "http://worldcat.org/webservices/kb/rest/entries/jstor.titlelist,e3161246-7880-4fd1-b3ac-b2cbcd2b06f5-emi",
      "rel" : "self"
    } ],
    "title" : "Princeton University Library Chronicle, The"
  } ],
  "id" : "urn:uuid:334b9f4f-93a2-4749-a0b1-1e5e3a500448",
  "links" : [ {
    "href" : "http://emmaws-m1.prod.oclc.org/webservices/kb/rest/entries/search?collection_uid=jstor.titlelist&institution_id=2525&itemsPerPage=10&orderBy=title%20asc&q=0032-8456&scope=my&search-type=search&startIndex=1",
    "rel" : "self"
  } ],
  "title" : "WorldCat KnowledgeBase Search: ",
  "updated" : "2025-04-23T19:02:12.737Z",
  "os:itemsPerPage" : "10",
  "os:Query" : "collection_uid=jstor.titlelist&institution_id=2525&itemsPerPage=10&orderBy=title%20asc&q=0032-8456&scope=my&search-type=search&startIndex=1",
  "os:startIndex" : "1",
  "os:totalResults" : "1"
}
```
## Extracting Coverage Data from JSON:
1. Using the newly created column, select Edit column>Add column based on this column.
2. Name the column.
3. Use the following GREL expressions to extract the relevant data from the JSON:
```
value.parseJson().entries[0]['kb:collection_name']+": "+value.parseJson().entries[0]['kb:coverage']
```
If you would prefer to use enumerated coverage, use this expression instead:
```value.parseJson().entries[0]['kb:collection_name']+": "+value.parseJson().entries[0]['kb:coverage_enum']```
In the new column, for rows that have a match in the KB, you should now see something that looks like this: **JSTOR Archival Journals and Primary Sources Collection: fulltext@1939-11-01~2023-10-01**
