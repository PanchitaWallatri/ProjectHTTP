***Setting***
Library    Browser

***Variable***
${RecordWeb}    https://ce.kmitl.ac.th

*** Tasks ***
RecordWeb
    ${old_timeout} =     Set Browser Timeout    50 seconds
    New Browser    chromium    headless=false
    New Context    ignoreHTTPSErrors=true
    New Page    ${RecordWeb}
    Set Browser Timeout    ${old_timeout}
