*** Settings ***
Documentation     Insert the sales data for the week and export it as a PDF.
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.Desktop.Windows
Library           OperatingSystem
Library           Collections
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.Tables
Library           RPA.JSON

*** Tasks ***
Calcul sum of amount by Catagory
    Open the website
    Fill the from
    get Data File JSON
    get Data from Table and calcul Amount
    Verifying values of sum Amount
    Sleep    5s

*** Variables ***
${amount}=        0
${category}=      0
${sumAmountAccessories}=    0
${sumAccessories}=    0
${Fitness}=       0
${Clothings}=     0
${Electronics}=    0

*** Keywords ***
Open the website
    Open Available Browser    https://www.primefaces.org/showcase/index.xhtml?jfwid=a7472

Fill the from
    Input Text    j_idt149:j_idt150_input    DataTable
    Sleep    5
    Press Keys    None    ENTER
    Wait Until Page Contains Element    id:form:products

get Data from Table and calcul Amount
    Sleep    2
    ${rowCount}    Get Element Count    //*[@id="form:products_data"]/tr
    FOR    ${rowIndex}    IN RANGE    1    ${rowCount} + 1
        ${amount}    RPA.Browser.Selenium.Get Text    //*[@id="form:products_data"]/tr[${rowIndex}]/td[4]
        ${category}    RPA.Browser.Selenium.Get Text    //*[@id="form:products_data"]/tr[${rowIndex}]/td[3]
        IF    '${category}' == 'Accessories'
            ${sumAccessories}=    Evaluate    ${sumAccessories} + ${amount}
        ELSE IF    "${category}" == "Fitness"
            ${Fitness}=    Evaluate    ${Fitness} + ${amount}
        ELSE IF    "${category}" == "Clothing"
            ${Clothings}=    Evaluate    ${Clothings} + ${amount}
        ELSE IF    "${category}" == "Electronics"
            ${Electronics}=    Evaluate    ${Electronics} + ${amount}
        END
    END
    Set Global Variable    ${sumAccessories}
    Set Global Variable    ${Electronics}
    Set Global Variable    ${Fitness}
    Set Global Variable    ${Clothings}

get Data File JSON
    ${json}=    Load JSON from file    ./app.json
    ${sumAmountAccessories}=    Get value from JSON    ${json}    $.sumAmountAccessories
    Log To Console    from JSON File
    Log To Console    ${sumAmountAccessories}
    ${sumAmountFitness}=    Get value from JSON    ${json}    $.sumAmountFitness
    Log To Console    ${sumAmountFitness}
    ${sumAmountClothing}=    Get value from JSON    ${json}    $.sumAmountClothing
    Log To Console    ${sumAmountClothing}
    ${sumAmountElectronic}=    Get value from JSON    ${json}    $.sumAmountElectronic
    Log To Console    ${sumAmountElectronic}
    Set Global Variable    ${sumAmountAccessories}
    Set Global Variable    ${sumAmountFitness}
    Set Global Variable    ${sumAmountClothing}
    Set Global Variable    ${sumAmountElectronic}

Verifying values of sum Amount
    Log To Console    -----------------------
    Should Be Equal    ${sumAmountAccessories}    ${sumAccessories}
    Should Be Equal    ${sumAmountFitness}    ${Fitness}
    Should Be Equal    ${sumAmountClothing}    ${Clothings}
    Should Be Equal    ${sumAmountElectronic}    ${Electronics}
