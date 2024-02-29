*** Settings ***
Library    Browser
Library    RPA.JSON
Library    OperatingSystem
Library    SeleniumLibrary

*** Variables ***
${HARFILENAME}=    site2_http3.har
${OUTPUT_DIR}=    /home/master-desktop04
${HAR_FILE_PATH}=    ${OUTPUT_DIR}/${HARFILENAME}.har
${RePlayWeb}=    https://www.project.internal:444/site2_html/site2.html


*** Tasks ***
Record HAR file
    ${old_timeout} =     Set Browser Timeout    5m
    Init File
    ${har_config} =    Create Dictionary    path=${HAR_FILE_PATH}    omitContent=True
    ${browserArgs} =    Set Variable    ['--no-proxy-server', '--enable-quic', '--quic-version=h3-29', '--origin-to-force-quic-on=www.project.internal:444', '--allow_unknown_root_cert']
    ${browserId}  ${contextId}  ${pageDetails} =     New Persistent Context    userDataDir=${OUTPUT_DIR}/userDataDir    headless=False    ignoreHTTPSErrors=True    recordHar=${har_config}    url=${RePlayWeb}    args=${browserArgs} 
    Set Browser Timeout    ${old_timeout}
    Parse HAR
    

*** Keywords ***
Init File
    Create File    ${HAR_FILE_PATH}

Configure HAR
    ${har_config} =
    ...    Create Dictionary
    ...    path=${HAR_FILE_PATH}
    ...    omitContent=True
    
Parse HAR
    ${json}=    Load Json From File    ${HAR_FILE_PATH}
    ${urls}=    Get value from JSON    ${json}    $..url
    Save JSON to file    ${urls}    ${OUTPUT_DIR}${/}urls.json   

