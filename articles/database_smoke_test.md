# Database: Smoke test

This vignette walks through the fastest path to a working local
database: connect, create a project, initialise, run the ETL, and check
that data arrived. It takes about one minute to run on a fresh
installation.

The examples below use an **in-memory SQLite database** and a **built-in
dummy FAIRground**, so no external server or DSN configuration is
needed.

------------------------------------------------------------------------

## 1. Connect to the database

``` r

con <- FAIRgroundConnect(drv = RSQLite::SQLite(), dsn = ":memory:")
```

[`FAIRgroundConnect()`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
stores the connection as the session default. Every subsequent beFAIR
function will use it automatically unless you pass a different
connection explicitly.

> **In production** you would use a DSN instead:
> `FAIRgroundConnect("MY_DSN")`. See
> [`?FAIRgroundConnect`](https://koenastam.github.io/beFAIR/reference/FAIRgroundConnect.md)
> for ODBC options.

------------------------------------------------------------------------

## 2. Create a FAIRground project

``` r

startProject(dir = dir, dummy = TRUE)
list.files(dir)
#> [1] "analyses"           "beFAIR_smoke.Rproj" "codebooks"         
#> [4] "common"             "experiments"        "fairground.yml"    
#> [7] "logs"               "studies"
```

`dummy = TRUE` copies a set of example studies, experiments, and
analyses into the new project directory. These include two clinical
studies and several immunology experiments — enough to demonstrate the
full pipeline.

------------------------------------------------------------------------

## 3. Initialise the database

``` r

databaseInitialize()
DBI::dbListTables(con)
#> [1] "HGNC"             "LUNC"             "table_codebook"   "table_datasource"
#> [5] "table_dependency" "table_project"    "table_script"
```

[`databaseInitialize()`](https://koenastam.github.io/beFAIR/reference/databaseInitialize.md)
creates the two core registry tables (`table_script` and
`table_codebook`) plus reference tables for gene symbols and glycan
nomenclature. No study data yet — that happens in the next step.

------------------------------------------------------------------------

## 4. Run the ETL pipeline

``` r

databaseUpdate()
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:12]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `participant_nr` is of type: integer. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_integer</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_integer" transform="translate(0.000000, 0.413793)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M45.3714224,43.0146694 L45.3714224,29.22756 L47.8723989,29.22756 L47.8723989,43.0146694 L45.3714224,43.0146694 Z M45.3714224,26.7265834 L45.3714224,24.2256069 L47.8723989,24.2256069 L47.8723989,26.7265834 L45.3714224,26.7265834 Z" id="i" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_integer()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="participant_nr" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>participant_nr</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `participant_nr` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Participant nr is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="participant_nr" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>participant_nr</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>37</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>37</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `source_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="source_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>source_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `source_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Source ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="source_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>source_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>37</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>37</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>37</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>37</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:12]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `studyarm_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Studyarm ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>4</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>4</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>4</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>4</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_description` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_description" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_description</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:12]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `studyarm_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Studyarm ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>2</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>2</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>2</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>2</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_description` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_description" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_description</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:12 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:13]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `studyarm_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Studyarm ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>8</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>8</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>8</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>8</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `timepoint` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="timepoint" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>timepoint</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `event_type` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_type" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_type</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">7</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `event_type` should be in the set of `immunization`, `vaccination`, `placebo` (and 4 more). " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_in_set</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_in_set" transform="translate(0.000000, 0.172414)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M44.127969,41.1538382 L31.0814568,41.1538382 C29.9510748,41.1536429 28.8827052,40.9256134 27.9079888,40.5136953 C26.4467442,39.8960136 25.19849,38.8599685 24.3189894,37.5577099 C23.8792391,36.906727 23.5314818,36.1899233 23.2936866,35.4252675 C23.2130217,35.16589 23.1460289,34.9005554 23.0913409,34.6307286 L44.1278714,34.6307286 C45.028466,34.6306309 45.7586488,33.9004481 45.7586488,32.9998535 C45.7586488,32.0992589 45.028466,31.3690761 44.1278714,31.3690761 L23.0905596,31.3690761 C23.1990567,30.8337194 23.3597028,30.3180894 23.5675173,29.8264831 C24.185199,28.3652386 25.2212442,27.1169844 26.5236004,26.2374838 C27.1745833,25.7977334 27.891387,25.4499762 28.6560428,25.2122786 C29.4208939,24.9744833 30.2334994,24.8459665 31.0813591,24.8459665 L44.1277737,24.8459665 C45.0283683,24.8459665 45.7586488,24.1157837 45.7586488,23.2151891 C45.7586488,22.3145945 45.0283683,21.5844117 44.1277737,21.5844117 L31.0813591,21.5844117 C29.5096643,21.5844117 28.0039858,21.9038483 26.6373711,22.4820765 C24.5866678,23.3498583 22.8469049,24.7950871 21.6163267,26.616296 C20.3856508,28.4362354 19.665136,30.6413347 19.6658191,33.0000488 C19.6658191,34.5717436 19.9852563,36.0774222 20.5635822,37.4440369 C21.4312663,39.4947402 22.8765927,41.2345031 24.697704,42.4650813 C26.5176434,43.6957572 28.7227427,44.4155883 31.0814568,44.4155883 L44.1278714,44.4155883 C45.028466,44.4155883 45.7586488,43.6854055 45.7586488,42.7848109 C45.7586488,41.8842163 45.0285636,41.1538382 44.127969,41.1538382 Z" id="set_of" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_vals_in_set()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_type" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_type</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="immunization, vaccination, placebo, challenge, drug, treatment, prophylaxis" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>immunization, vaccination, placebo, challenge, drug, treatment, prophylaxis</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>8</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>8</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">8</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `event_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">9</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `product_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="product_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>product_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">10</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `product_administration` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="product_administration" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>product_administration</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">11</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `dose` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="dose" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>dose</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">12</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `dose_unit` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="dose_unit" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>dose_unit</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:13 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:13 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:13]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `studyarm_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Studyarm ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>12</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>12</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>12</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>12</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `timepoint` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="timepoint" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>timepoint</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `event_type` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_type" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_type</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">7</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `event_type` should be in the set of `immunization`, `vaccination`, `placebo` (and 4 more). " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_in_set</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_in_set" transform="translate(0.000000, 0.172414)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M44.127969,41.1538382 L31.0814568,41.1538382 C29.9510748,41.1536429 28.8827052,40.9256134 27.9079888,40.5136953 C26.4467442,39.8960136 25.19849,38.8599685 24.3189894,37.5577099 C23.8792391,36.906727 23.5314818,36.1899233 23.2936866,35.4252675 C23.2130217,35.16589 23.1460289,34.9005554 23.0913409,34.6307286 L44.1278714,34.6307286 C45.028466,34.6306309 45.7586488,33.9004481 45.7586488,32.9998535 C45.7586488,32.0992589 45.028466,31.3690761 44.1278714,31.3690761 L23.0905596,31.3690761 C23.1990567,30.8337194 23.3597028,30.3180894 23.5675173,29.8264831 C24.185199,28.3652386 25.2212442,27.1169844 26.5236004,26.2374838 C27.1745833,25.7977334 27.891387,25.4499762 28.6560428,25.2122786 C29.4208939,24.9744833 30.2334994,24.8459665 31.0813591,24.8459665 L44.1277737,24.8459665 C45.0283683,24.8459665 45.7586488,24.1157837 45.7586488,23.2151891 C45.7586488,22.3145945 45.0283683,21.5844117 44.1277737,21.5844117 L31.0813591,21.5844117 C29.5096643,21.5844117 28.0039858,21.9038483 26.6373711,22.4820765 C24.5866678,23.3498583 22.8469049,24.7950871 21.6163267,26.616296 C20.3856508,28.4362354 19.665136,30.6413347 19.6658191,33.0000488 C19.6658191,34.5717436 19.9852563,36.0774222 20.5635822,37.4440369 C21.4312663,39.4947402 22.8765927,41.2345031 24.697704,42.4650813 C26.5176434,43.6957572 28.7227427,44.4155883 31.0814568,44.4155883 L44.1278714,44.4155883 C45.028466,44.4155883 45.7586488,43.6854055 45.7586488,42.7848109 C45.7586488,41.8842163 45.0285636,41.1538382 44.127969,41.1538382 Z" id="set_of" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_vals_in_set()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_type" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_type</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="immunization, vaccination, placebo, challenge, drug, treatment, prophylaxis" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>immunization, vaccination, placebo, challenge, drug, treatment, prophylaxis</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>12</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>12</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">8</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `event_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="event_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>event_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">9</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `product_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="product_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>product_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">10</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `product_administration` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="product_administration" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>product_administration</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">11</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `dose` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="dose" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>dose</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">12</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `dose_unit` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="dose_unit" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>dose_unit</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:13 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:13 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:14]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `source_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="source_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>source_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `source_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Source ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="source_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>source_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `study_name` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Study name is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">7</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `studyarm_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="studyarm_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>studyarm_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">8</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `age` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="age" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>age</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">9</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `age` should be between `0` and `120`. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_between</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_between" transform="translate(0.000000, 0.206897)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M11.993484,21.96875 C10.962234,22.082031 10.188797,22.964844 10.212234,24 L10.212234,42 C10.200515,42.722656 10.579422,43.390625 11.204422,43.753906 C11.825515,44.121094 12.598953,44.121094 13.220047,43.753906 C13.845047,43.390625 14.223953,42.722656 14.212234,42 L14.212234,24 C14.220047,23.457031 14.009109,22.9375 13.626297,22.554688 C13.243484,22.171875 12.723953,21.960938 12.180984,21.96875 C12.118484,21.964844 12.055984,21.964844 11.993484,21.96875 Z M55.993484,21.96875 C54.962234,22.082031 54.188797,22.964844 54.212234,24 L54.212234,42 C54.200515,42.722656 54.579422,43.390625 55.204422,43.753906 C55.825515,44.121094 56.598953,44.121094 57.220047,43.753906 C57.845047,43.390625 58.223953,42.722656 58.212234,42 L58.212234,24 C58.220047,23.457031 58.009109,22.9375 57.626297,22.554688 C57.243484,22.171875 56.723953,21.960938 56.180984,21.96875 C56.118484,21.964844 56.055984,21.964844 55.993484,21.96875 Z M16.212234,22 C15.661453,22 15.212234,22.449219 15.212234,23 C15.212234,23.550781 15.661453,24 16.212234,24 C16.763015,24 17.212234,23.550781 17.212234,23 C17.212234,22.449219 16.763015,22 16.212234,22 Z M20.212234,22 C19.661453,22 19.212234,22.449219 19.212234,23 C19.212234,23.550781 19.661453,24 20.212234,24 C20.763015,24 21.212234,23.550781 21.212234,23 C21.212234,22.449219 20.763015,22 20.212234,22 Z M24.212234,22 C23.661453,22 23.212234,22.449219 23.212234,23 C23.212234,23.550781 23.661453,24 24.212234,24 C24.763015,24 25.212234,23.550781 25.212234,23 C25.212234,22.449219 24.763015,22 24.212234,22 Z M28.212234,22 C27.661453,22 27.212234,22.449219 27.212234,23 C27.212234,23.550781 27.661453,24 28.212234,24 C28.763015,24 29.212234,23.550781 29.212234,23 C29.212234,22.449219 28.763015,22 28.212234,22 Z M32.212234,22 C31.661453,22 31.212234,22.449219 31.212234,23 C31.212234,23.550781 31.661453,24 32.212234,24 C32.763015,24 33.212234,23.550781 33.212234,23 C33.212234,22.449219 32.763015,22 32.212234,22 Z M36.212234,22 C35.661453,22 35.212234,22.449219 35.212234,23 C35.212234,23.550781 35.661453,24 36.212234,24 C36.763015,24 37.212234,23.550781 37.212234,23 C37.212234,22.449219 36.763015,22 36.212234,22 Z M40.212234,22 C39.661453,22 39.212234,22.449219 39.212234,23 C39.212234,23.550781 39.661453,24 40.212234,24 C40.763015,24 41.212234,23.550781 41.212234,23 C41.212234,22.449219 40.763015,22 40.212234,22 Z M44.212234,22 C43.661453,22 43.212234,22.449219 43.212234,23 C43.212234,23.550781 43.661453,24 44.212234,24 C44.763015,24 45.212234,23.550781 45.212234,23 C45.212234,22.449219 44.763015,22 44.212234,22 Z M48.212234,22 C47.661453,22 47.212234,22.449219 47.212234,23 C47.212234,23.550781 47.661453,24 48.212234,24 C48.763015,24 49.212234,23.550781 49.212234,23 C49.212234,22.449219 48.763015,22 48.212234,22 Z M52.212234,22 C51.661453,22 51.212234,22.449219 51.212234,23 C51.212234,23.550781 51.661453,24 52.212234,24 C52.763015,24 53.212234,23.550781 53.212234,23 C53.212234,22.449219 52.763015,22 52.212234,22 Z M21.462234,27.96875 C21.419265,27.976563 21.376297,27.988281 21.337234,28 C21.177078,28.027344 21.02864,28.089844 20.899734,28.1875 L15.618484,32.1875 C15.356765,32.375 15.200515,32.679688 15.200515,33 C15.200515,33.320313 15.356765,33.625 15.618484,33.8125 L20.899734,37.8125 C21.348953,38.148438 21.985672,38.058594 22.321609,37.609375 C22.657547,37.160156 22.567703,36.523438 22.118484,36.1875 L19.212234,34 L49.212234,34 L46.305984,36.1875 C45.856765,36.523438 45.766922,37.160156 46.102859,37.609375 C46.438797,38.058594 47.075515,38.148438 47.524734,37.8125 L52.805984,33.8125 C53.067703,33.625 53.223953,33.320313 53.223953,33 C53.223953,32.679688 53.067703,32.375 52.805984,32.1875 L47.524734,28.1875 C47.30989,28.027344 47.040359,27.960938 46.774734,28 C46.743484,28 46.712234,28 46.680984,28 C46.282547,28.074219 45.96614,28.382813 45.884109,28.78125 C45.802078,29.179688 45.970047,29.585938 46.305984,29.8125 L49.212234,32 L19.212234,32 L22.118484,29.8125 C22.520828,29.566406 22.696609,29.070313 22.536453,28.625 C22.380203,28.179688 21.930984,27.90625 21.462234,27.96875 Z M16.212234,42 C15.661453,42 15.212234,42.449219 15.212234,43 C15.212234,43.550781 15.661453,44 16.212234,44 C16.763015,44 17.212234,43.550781 17.212234,43 C17.212234,42.449219 16.763015,42 16.212234,42 Z M20.212234,42 C19.661453,42 19.212234,42.449219 19.212234,43 C19.212234,43.550781 19.661453,44 20.212234,44 C20.763015,44 21.212234,43.550781 21.212234,43 C21.212234,42.449219 20.763015,42 20.212234,42 Z M24.212234,42 C23.661453,42 23.212234,42.449219 23.212234,43 C23.212234,43.550781 23.661453,44 24.212234,44 C24.763015,44 25.212234,43.550781 25.212234,43 C25.212234,42.449219 24.763015,42 24.212234,42 Z M28.212234,42 C27.661453,42 27.212234,42.449219 27.212234,43 C27.212234,43.550781 27.661453,44 28.212234,44 C28.763015,44 29.212234,43.550781 29.212234,43 C29.212234,42.449219 28.763015,42 28.212234,42 Z M32.212234,42 C31.661453,42 31.212234,42.449219 31.212234,43 C31.212234,43.550781 31.661453,44 32.212234,44 C32.763015,44 33.212234,43.550781 33.212234,43 C33.212234,42.449219 32.763015,42 32.212234,42 Z M36.212234,42 C35.661453,42 35.212234,42.449219 35.212234,43 C35.212234,43.550781 35.661453,44 36.212234,44 C36.763015,44 37.212234,43.550781 37.212234,43 C37.212234,42.449219 36.763015,42 36.212234,42 Z M40.212234,42 C39.661453,42 39.212234,42.449219 39.212234,43 C39.212234,43.550781 39.661453,44 40.212234,44 C40.763015,44 41.212234,43.550781 41.212234,43 C41.212234,42.449219 40.763015,42 40.212234,42 Z M44.212234,42 C43.661453,42 43.212234,42.449219 43.212234,43 C43.212234,43.550781 43.661453,44 44.212234,44 C44.763015,44 45.212234,43.550781 45.212234,43 C45.212234,42.449219 44.763015,42 44.212234,42 Z M48.212234,42 C47.661453,42 47.212234,42.449219 47.212234,43 C47.212234,43.550781 47.661453,44 48.212234,44 C48.763015,44 49.212234,43.550781 49.212234,43 C49.212234,42.449219 48.763015,42 48.212234,42 Z M52.212234,42 C51.661453,42 51.212234,42.449219 51.212234,43 C51.212234,43.550781 51.661453,44 52.212234,44 C52.763015,44 53.212234,43.550781 53.212234,43 C53.212234,42.449219 52.763015,42 52.212234,42 Z" id="inside_range" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Age in years should fall within specified range</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_between()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="age" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>age</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="[0L, 120L]" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>[0, 120]</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">10</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `sex` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="sex" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>sex</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">11</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `sex` should be in the set of `M`, `F`, `NA`. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_in_set</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_in_set" transform="translate(0.000000, 0.172414)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M44.127969,41.1538382 L31.0814568,41.1538382 C29.9510748,41.1536429 28.8827052,40.9256134 27.9079888,40.5136953 C26.4467442,39.8960136 25.19849,38.8599685 24.3189894,37.5577099 C23.8792391,36.906727 23.5314818,36.1899233 23.2936866,35.4252675 C23.2130217,35.16589 23.1460289,34.9005554 23.0913409,34.6307286 L44.1278714,34.6307286 C45.028466,34.6306309 45.7586488,33.9004481 45.7586488,32.9998535 C45.7586488,32.0992589 45.028466,31.3690761 44.1278714,31.3690761 L23.0905596,31.3690761 C23.1990567,30.8337194 23.3597028,30.3180894 23.5675173,29.8264831 C24.185199,28.3652386 25.2212442,27.1169844 26.5236004,26.2374838 C27.1745833,25.7977334 27.891387,25.4499762 28.6560428,25.2122786 C29.4208939,24.9744833 30.2334994,24.8459665 31.0813591,24.8459665 L44.1277737,24.8459665 C45.0283683,24.8459665 45.7586488,24.1157837 45.7586488,23.2151891 C45.7586488,22.3145945 45.0283683,21.5844117 44.1277737,21.5844117 L31.0813591,21.5844117 C29.5096643,21.5844117 28.0039858,21.9038483 26.6373711,22.4820765 C24.5866678,23.3498583 22.8469049,24.7950871 21.6163267,26.616296 C20.3856508,28.4362354 19.665136,30.6413347 19.6658191,33.0000488 C19.6658191,34.5717436 19.9852563,36.0774222 20.5635822,37.4440369 C21.4312663,39.4947402 22.8765927,41.2345031 24.697704,42.4650813 C26.5176434,43.6957572 28.7227427,44.4155883 31.0814568,44.4155883 L44.1278714,44.4155883 C45.028466,44.4155883 45.7586488,43.6854055 45.7586488,42.7848109 C45.7586488,41.8842163 45.0285636,41.1538382 44.127969,41.1538382 Z" id="set_of" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Sex values should be one of the specified options</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_in_set()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="sex" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>sex</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="M, F, NA" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>M, F, NA</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">12</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `ethnicity` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="ethnicity" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>ethnicity</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">13</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `height` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="height" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>height</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">14</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `height` should be between `50` and `250`. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_between</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_between" transform="translate(0.000000, 0.206897)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M11.993484,21.96875 C10.962234,22.082031 10.188797,22.964844 10.212234,24 L10.212234,42 C10.200515,42.722656 10.579422,43.390625 11.204422,43.753906 C11.825515,44.121094 12.598953,44.121094 13.220047,43.753906 C13.845047,43.390625 14.223953,42.722656 14.212234,42 L14.212234,24 C14.220047,23.457031 14.009109,22.9375 13.626297,22.554688 C13.243484,22.171875 12.723953,21.960938 12.180984,21.96875 C12.118484,21.964844 12.055984,21.964844 11.993484,21.96875 Z M55.993484,21.96875 C54.962234,22.082031 54.188797,22.964844 54.212234,24 L54.212234,42 C54.200515,42.722656 54.579422,43.390625 55.204422,43.753906 C55.825515,44.121094 56.598953,44.121094 57.220047,43.753906 C57.845047,43.390625 58.223953,42.722656 58.212234,42 L58.212234,24 C58.220047,23.457031 58.009109,22.9375 57.626297,22.554688 C57.243484,22.171875 56.723953,21.960938 56.180984,21.96875 C56.118484,21.964844 56.055984,21.964844 55.993484,21.96875 Z M16.212234,22 C15.661453,22 15.212234,22.449219 15.212234,23 C15.212234,23.550781 15.661453,24 16.212234,24 C16.763015,24 17.212234,23.550781 17.212234,23 C17.212234,22.449219 16.763015,22 16.212234,22 Z M20.212234,22 C19.661453,22 19.212234,22.449219 19.212234,23 C19.212234,23.550781 19.661453,24 20.212234,24 C20.763015,24 21.212234,23.550781 21.212234,23 C21.212234,22.449219 20.763015,22 20.212234,22 Z M24.212234,22 C23.661453,22 23.212234,22.449219 23.212234,23 C23.212234,23.550781 23.661453,24 24.212234,24 C24.763015,24 25.212234,23.550781 25.212234,23 C25.212234,22.449219 24.763015,22 24.212234,22 Z M28.212234,22 C27.661453,22 27.212234,22.449219 27.212234,23 C27.212234,23.550781 27.661453,24 28.212234,24 C28.763015,24 29.212234,23.550781 29.212234,23 C29.212234,22.449219 28.763015,22 28.212234,22 Z M32.212234,22 C31.661453,22 31.212234,22.449219 31.212234,23 C31.212234,23.550781 31.661453,24 32.212234,24 C32.763015,24 33.212234,23.550781 33.212234,23 C33.212234,22.449219 32.763015,22 32.212234,22 Z M36.212234,22 C35.661453,22 35.212234,22.449219 35.212234,23 C35.212234,23.550781 35.661453,24 36.212234,24 C36.763015,24 37.212234,23.550781 37.212234,23 C37.212234,22.449219 36.763015,22 36.212234,22 Z M40.212234,22 C39.661453,22 39.212234,22.449219 39.212234,23 C39.212234,23.550781 39.661453,24 40.212234,24 C40.763015,24 41.212234,23.550781 41.212234,23 C41.212234,22.449219 40.763015,22 40.212234,22 Z M44.212234,22 C43.661453,22 43.212234,22.449219 43.212234,23 C43.212234,23.550781 43.661453,24 44.212234,24 C44.763015,24 45.212234,23.550781 45.212234,23 C45.212234,22.449219 44.763015,22 44.212234,22 Z M48.212234,22 C47.661453,22 47.212234,22.449219 47.212234,23 C47.212234,23.550781 47.661453,24 48.212234,24 C48.763015,24 49.212234,23.550781 49.212234,23 C49.212234,22.449219 48.763015,22 48.212234,22 Z M52.212234,22 C51.661453,22 51.212234,22.449219 51.212234,23 C51.212234,23.550781 51.661453,24 52.212234,24 C52.763015,24 53.212234,23.550781 53.212234,23 C53.212234,22.449219 52.763015,22 52.212234,22 Z M21.462234,27.96875 C21.419265,27.976563 21.376297,27.988281 21.337234,28 C21.177078,28.027344 21.02864,28.089844 20.899734,28.1875 L15.618484,32.1875 C15.356765,32.375 15.200515,32.679688 15.200515,33 C15.200515,33.320313 15.356765,33.625 15.618484,33.8125 L20.899734,37.8125 C21.348953,38.148438 21.985672,38.058594 22.321609,37.609375 C22.657547,37.160156 22.567703,36.523438 22.118484,36.1875 L19.212234,34 L49.212234,34 L46.305984,36.1875 C45.856765,36.523438 45.766922,37.160156 46.102859,37.609375 C46.438797,38.058594 47.075515,38.148438 47.524734,37.8125 L52.805984,33.8125 C53.067703,33.625 53.223953,33.320313 53.223953,33 C53.223953,32.679688 53.067703,32.375 52.805984,32.1875 L47.524734,28.1875 C47.30989,28.027344 47.040359,27.960938 46.774734,28 C46.743484,28 46.712234,28 46.680984,28 C46.282547,28.074219 45.96614,28.382813 45.884109,28.78125 C45.802078,29.179688 45.970047,29.585938 46.305984,29.8125 L49.212234,32 L19.212234,32 L22.118484,29.8125 C22.520828,29.566406 22.696609,29.070313 22.536453,28.625 C22.380203,28.179688 21.930984,27.90625 21.462234,27.96875 Z M16.212234,42 C15.661453,42 15.212234,42.449219 15.212234,43 C15.212234,43.550781 15.661453,44 16.212234,44 C16.763015,44 17.212234,43.550781 17.212234,43 C17.212234,42.449219 16.763015,42 16.212234,42 Z M20.212234,42 C19.661453,42 19.212234,42.449219 19.212234,43 C19.212234,43.550781 19.661453,44 20.212234,44 C20.763015,44 21.212234,43.550781 21.212234,43 C21.212234,42.449219 20.763015,42 20.212234,42 Z M24.212234,42 C23.661453,42 23.212234,42.449219 23.212234,43 C23.212234,43.550781 23.661453,44 24.212234,44 C24.763015,44 25.212234,43.550781 25.212234,43 C25.212234,42.449219 24.763015,42 24.212234,42 Z M28.212234,42 C27.661453,42 27.212234,42.449219 27.212234,43 C27.212234,43.550781 27.661453,44 28.212234,44 C28.763015,44 29.212234,43.550781 29.212234,43 C29.212234,42.449219 28.763015,42 28.212234,42 Z M32.212234,42 C31.661453,42 31.212234,42.449219 31.212234,43 C31.212234,43.550781 31.661453,44 32.212234,44 C32.763015,44 33.212234,43.550781 33.212234,43 C33.212234,42.449219 32.763015,42 32.212234,42 Z M36.212234,42 C35.661453,42 35.212234,42.449219 35.212234,43 C35.212234,43.550781 35.661453,44 36.212234,44 C36.763015,44 37.212234,43.550781 37.212234,43 C37.212234,42.449219 36.763015,42 36.212234,42 Z M40.212234,42 C39.661453,42 39.212234,42.449219 39.212234,43 C39.212234,43.550781 39.661453,44 40.212234,44 C40.763015,44 41.212234,43.550781 41.212234,43 C41.212234,42.449219 40.763015,42 40.212234,42 Z M44.212234,42 C43.661453,42 43.212234,42.449219 43.212234,43 C43.212234,43.550781 43.661453,44 44.212234,44 C44.763015,44 45.212234,43.550781 45.212234,43 C45.212234,42.449219 44.763015,42 44.212234,42 Z M48.212234,42 C47.661453,42 47.212234,42.449219 47.212234,43 C47.212234,43.550781 47.661453,44 48.212234,44 C48.763015,44 49.212234,43.550781 49.212234,43 C49.212234,42.449219 48.763015,42 48.212234,42 Z M52.212234,42 C51.661453,42 51.212234,42.449219 51.212234,43 C51.212234,43.550781 51.661453,44 52.212234,44 C52.763015,44 53.212234,43.550781 53.212234,43 C53.212234,42.449219 52.763015,42 52.212234,42 Z" id="inside_range" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Height in centimeter values should be within specified range</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_between()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="height" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>height</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="[50L, 250L]" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>[50, 250]</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">15</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `weight` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="weight" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>weight</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">16</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `weight` should be between `4` and `150`. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_between</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_between" transform="translate(0.000000, 0.206897)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M11.993484,21.96875 C10.962234,22.082031 10.188797,22.964844 10.212234,24 L10.212234,42 C10.200515,42.722656 10.579422,43.390625 11.204422,43.753906 C11.825515,44.121094 12.598953,44.121094 13.220047,43.753906 C13.845047,43.390625 14.223953,42.722656 14.212234,42 L14.212234,24 C14.220047,23.457031 14.009109,22.9375 13.626297,22.554688 C13.243484,22.171875 12.723953,21.960938 12.180984,21.96875 C12.118484,21.964844 12.055984,21.964844 11.993484,21.96875 Z M55.993484,21.96875 C54.962234,22.082031 54.188797,22.964844 54.212234,24 L54.212234,42 C54.200515,42.722656 54.579422,43.390625 55.204422,43.753906 C55.825515,44.121094 56.598953,44.121094 57.220047,43.753906 C57.845047,43.390625 58.223953,42.722656 58.212234,42 L58.212234,24 C58.220047,23.457031 58.009109,22.9375 57.626297,22.554688 C57.243484,22.171875 56.723953,21.960938 56.180984,21.96875 C56.118484,21.964844 56.055984,21.964844 55.993484,21.96875 Z M16.212234,22 C15.661453,22 15.212234,22.449219 15.212234,23 C15.212234,23.550781 15.661453,24 16.212234,24 C16.763015,24 17.212234,23.550781 17.212234,23 C17.212234,22.449219 16.763015,22 16.212234,22 Z M20.212234,22 C19.661453,22 19.212234,22.449219 19.212234,23 C19.212234,23.550781 19.661453,24 20.212234,24 C20.763015,24 21.212234,23.550781 21.212234,23 C21.212234,22.449219 20.763015,22 20.212234,22 Z M24.212234,22 C23.661453,22 23.212234,22.449219 23.212234,23 C23.212234,23.550781 23.661453,24 24.212234,24 C24.763015,24 25.212234,23.550781 25.212234,23 C25.212234,22.449219 24.763015,22 24.212234,22 Z M28.212234,22 C27.661453,22 27.212234,22.449219 27.212234,23 C27.212234,23.550781 27.661453,24 28.212234,24 C28.763015,24 29.212234,23.550781 29.212234,23 C29.212234,22.449219 28.763015,22 28.212234,22 Z M32.212234,22 C31.661453,22 31.212234,22.449219 31.212234,23 C31.212234,23.550781 31.661453,24 32.212234,24 C32.763015,24 33.212234,23.550781 33.212234,23 C33.212234,22.449219 32.763015,22 32.212234,22 Z M36.212234,22 C35.661453,22 35.212234,22.449219 35.212234,23 C35.212234,23.550781 35.661453,24 36.212234,24 C36.763015,24 37.212234,23.550781 37.212234,23 C37.212234,22.449219 36.763015,22 36.212234,22 Z M40.212234,22 C39.661453,22 39.212234,22.449219 39.212234,23 C39.212234,23.550781 39.661453,24 40.212234,24 C40.763015,24 41.212234,23.550781 41.212234,23 C41.212234,22.449219 40.763015,22 40.212234,22 Z M44.212234,22 C43.661453,22 43.212234,22.449219 43.212234,23 C43.212234,23.550781 43.661453,24 44.212234,24 C44.763015,24 45.212234,23.550781 45.212234,23 C45.212234,22.449219 44.763015,22 44.212234,22 Z M48.212234,22 C47.661453,22 47.212234,22.449219 47.212234,23 C47.212234,23.550781 47.661453,24 48.212234,24 C48.763015,24 49.212234,23.550781 49.212234,23 C49.212234,22.449219 48.763015,22 48.212234,22 Z M52.212234,22 C51.661453,22 51.212234,22.449219 51.212234,23 C51.212234,23.550781 51.661453,24 52.212234,24 C52.763015,24 53.212234,23.550781 53.212234,23 C53.212234,22.449219 52.763015,22 52.212234,22 Z M21.462234,27.96875 C21.419265,27.976563 21.376297,27.988281 21.337234,28 C21.177078,28.027344 21.02864,28.089844 20.899734,28.1875 L15.618484,32.1875 C15.356765,32.375 15.200515,32.679688 15.200515,33 C15.200515,33.320313 15.356765,33.625 15.618484,33.8125 L20.899734,37.8125 C21.348953,38.148438 21.985672,38.058594 22.321609,37.609375 C22.657547,37.160156 22.567703,36.523438 22.118484,36.1875 L19.212234,34 L49.212234,34 L46.305984,36.1875 C45.856765,36.523438 45.766922,37.160156 46.102859,37.609375 C46.438797,38.058594 47.075515,38.148438 47.524734,37.8125 L52.805984,33.8125 C53.067703,33.625 53.223953,33.320313 53.223953,33 C53.223953,32.679688 53.067703,32.375 52.805984,32.1875 L47.524734,28.1875 C47.30989,28.027344 47.040359,27.960938 46.774734,28 C46.743484,28 46.712234,28 46.680984,28 C46.282547,28.074219 45.96614,28.382813 45.884109,28.78125 C45.802078,29.179688 45.970047,29.585938 46.305984,29.8125 L49.212234,32 L19.212234,32 L22.118484,29.8125 C22.520828,29.566406 22.696609,29.070313 22.536453,28.625 C22.380203,28.179688 21.930984,27.90625 21.462234,27.96875 Z M16.212234,42 C15.661453,42 15.212234,42.449219 15.212234,43 C15.212234,43.550781 15.661453,44 16.212234,44 C16.763015,44 17.212234,43.550781 17.212234,43 C17.212234,42.449219 16.763015,42 16.212234,42 Z M20.212234,42 C19.661453,42 19.212234,42.449219 19.212234,43 C19.212234,43.550781 19.661453,44 20.212234,44 C20.763015,44 21.212234,43.550781 21.212234,43 C21.212234,42.449219 20.763015,42 20.212234,42 Z M24.212234,42 C23.661453,42 23.212234,42.449219 23.212234,43 C23.212234,43.550781 23.661453,44 24.212234,44 C24.763015,44 25.212234,43.550781 25.212234,43 C25.212234,42.449219 24.763015,42 24.212234,42 Z M28.212234,42 C27.661453,42 27.212234,42.449219 27.212234,43 C27.212234,43.550781 27.661453,44 28.212234,44 C28.763015,44 29.212234,43.550781 29.212234,43 C29.212234,42.449219 28.763015,42 28.212234,42 Z M32.212234,42 C31.661453,42 31.212234,42.449219 31.212234,43 C31.212234,43.550781 31.661453,44 32.212234,44 C32.763015,44 33.212234,43.550781 33.212234,43 C33.212234,42.449219 32.763015,42 32.212234,42 Z M36.212234,42 C35.661453,42 35.212234,42.449219 35.212234,43 C35.212234,43.550781 35.661453,44 36.212234,44 C36.763015,44 37.212234,43.550781 37.212234,43 C37.212234,42.449219 36.763015,42 36.212234,42 Z M40.212234,42 C39.661453,42 39.212234,42.449219 39.212234,43 C39.212234,43.550781 39.661453,44 40.212234,44 C40.763015,44 41.212234,43.550781 41.212234,43 C41.212234,42.449219 40.763015,42 40.212234,42 Z M44.212234,42 C43.661453,42 43.212234,42.449219 43.212234,43 C43.212234,43.550781 43.661453,44 44.212234,44 C44.763015,44 45.212234,43.550781 45.212234,43 C45.212234,42.449219 44.763015,42 44.212234,42 Z M48.212234,42 C47.661453,42 47.212234,42.449219 47.212234,43 C47.212234,43.550781 47.661453,44 48.212234,44 C48.763015,44 49.212234,43.550781 49.212234,43 C49.212234,42.449219 48.763015,42 48.212234,42 Z M52.212234,42 C51.661453,42 51.212234,42.449219 51.212234,43 C51.212234,43.550781 51.661453,44 52.212234,44 C52.763015,44 53.212234,43.550781 53.212234,43 C53.212234,42.449219 52.763015,42 52.212234,42 Z" id="inside_range" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Weight in kg values should be within specified range</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_between()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="weight" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>weight</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="[4L, 150L]" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>[4, 150]</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">17</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `bmi` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="bmi" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>bmi</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">18</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `bmi` should be between `10` and `44`. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_between</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_between" transform="translate(0.000000, 0.206897)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M11.993484,21.96875 C10.962234,22.082031 10.188797,22.964844 10.212234,24 L10.212234,42 C10.200515,42.722656 10.579422,43.390625 11.204422,43.753906 C11.825515,44.121094 12.598953,44.121094 13.220047,43.753906 C13.845047,43.390625 14.223953,42.722656 14.212234,42 L14.212234,24 C14.220047,23.457031 14.009109,22.9375 13.626297,22.554688 C13.243484,22.171875 12.723953,21.960938 12.180984,21.96875 C12.118484,21.964844 12.055984,21.964844 11.993484,21.96875 Z M55.993484,21.96875 C54.962234,22.082031 54.188797,22.964844 54.212234,24 L54.212234,42 C54.200515,42.722656 54.579422,43.390625 55.204422,43.753906 C55.825515,44.121094 56.598953,44.121094 57.220047,43.753906 C57.845047,43.390625 58.223953,42.722656 58.212234,42 L58.212234,24 C58.220047,23.457031 58.009109,22.9375 57.626297,22.554688 C57.243484,22.171875 56.723953,21.960938 56.180984,21.96875 C56.118484,21.964844 56.055984,21.964844 55.993484,21.96875 Z M16.212234,22 C15.661453,22 15.212234,22.449219 15.212234,23 C15.212234,23.550781 15.661453,24 16.212234,24 C16.763015,24 17.212234,23.550781 17.212234,23 C17.212234,22.449219 16.763015,22 16.212234,22 Z M20.212234,22 C19.661453,22 19.212234,22.449219 19.212234,23 C19.212234,23.550781 19.661453,24 20.212234,24 C20.763015,24 21.212234,23.550781 21.212234,23 C21.212234,22.449219 20.763015,22 20.212234,22 Z M24.212234,22 C23.661453,22 23.212234,22.449219 23.212234,23 C23.212234,23.550781 23.661453,24 24.212234,24 C24.763015,24 25.212234,23.550781 25.212234,23 C25.212234,22.449219 24.763015,22 24.212234,22 Z M28.212234,22 C27.661453,22 27.212234,22.449219 27.212234,23 C27.212234,23.550781 27.661453,24 28.212234,24 C28.763015,24 29.212234,23.550781 29.212234,23 C29.212234,22.449219 28.763015,22 28.212234,22 Z M32.212234,22 C31.661453,22 31.212234,22.449219 31.212234,23 C31.212234,23.550781 31.661453,24 32.212234,24 C32.763015,24 33.212234,23.550781 33.212234,23 C33.212234,22.449219 32.763015,22 32.212234,22 Z M36.212234,22 C35.661453,22 35.212234,22.449219 35.212234,23 C35.212234,23.550781 35.661453,24 36.212234,24 C36.763015,24 37.212234,23.550781 37.212234,23 C37.212234,22.449219 36.763015,22 36.212234,22 Z M40.212234,22 C39.661453,22 39.212234,22.449219 39.212234,23 C39.212234,23.550781 39.661453,24 40.212234,24 C40.763015,24 41.212234,23.550781 41.212234,23 C41.212234,22.449219 40.763015,22 40.212234,22 Z M44.212234,22 C43.661453,22 43.212234,22.449219 43.212234,23 C43.212234,23.550781 43.661453,24 44.212234,24 C44.763015,24 45.212234,23.550781 45.212234,23 C45.212234,22.449219 44.763015,22 44.212234,22 Z M48.212234,22 C47.661453,22 47.212234,22.449219 47.212234,23 C47.212234,23.550781 47.661453,24 48.212234,24 C48.763015,24 49.212234,23.550781 49.212234,23 C49.212234,22.449219 48.763015,22 48.212234,22 Z M52.212234,22 C51.661453,22 51.212234,22.449219 51.212234,23 C51.212234,23.550781 51.661453,24 52.212234,24 C52.763015,24 53.212234,23.550781 53.212234,23 C53.212234,22.449219 52.763015,22 52.212234,22 Z M21.462234,27.96875 C21.419265,27.976563 21.376297,27.988281 21.337234,28 C21.177078,28.027344 21.02864,28.089844 20.899734,28.1875 L15.618484,32.1875 C15.356765,32.375 15.200515,32.679688 15.200515,33 C15.200515,33.320313 15.356765,33.625 15.618484,33.8125 L20.899734,37.8125 C21.348953,38.148438 21.985672,38.058594 22.321609,37.609375 C22.657547,37.160156 22.567703,36.523438 22.118484,36.1875 L19.212234,34 L49.212234,34 L46.305984,36.1875 C45.856765,36.523438 45.766922,37.160156 46.102859,37.609375 C46.438797,38.058594 47.075515,38.148438 47.524734,37.8125 L52.805984,33.8125 C53.067703,33.625 53.223953,33.320313 53.223953,33 C53.223953,32.679688 53.067703,32.375 52.805984,32.1875 L47.524734,28.1875 C47.30989,28.027344 47.040359,27.960938 46.774734,28 C46.743484,28 46.712234,28 46.680984,28 C46.282547,28.074219 45.96614,28.382813 45.884109,28.78125 C45.802078,29.179688 45.970047,29.585938 46.305984,29.8125 L49.212234,32 L19.212234,32 L22.118484,29.8125 C22.520828,29.566406 22.696609,29.070313 22.536453,28.625 C22.380203,28.179688 21.930984,27.90625 21.462234,27.96875 Z M16.212234,42 C15.661453,42 15.212234,42.449219 15.212234,43 C15.212234,43.550781 15.661453,44 16.212234,44 C16.763015,44 17.212234,43.550781 17.212234,43 C17.212234,42.449219 16.763015,42 16.212234,42 Z M20.212234,42 C19.661453,42 19.212234,42.449219 19.212234,43 C19.212234,43.550781 19.661453,44 20.212234,44 C20.763015,44 21.212234,43.550781 21.212234,43 C21.212234,42.449219 20.763015,42 20.212234,42 Z M24.212234,42 C23.661453,42 23.212234,42.449219 23.212234,43 C23.212234,43.550781 23.661453,44 24.212234,44 C24.763015,44 25.212234,43.550781 25.212234,43 C25.212234,42.449219 24.763015,42 24.212234,42 Z M28.212234,42 C27.661453,42 27.212234,42.449219 27.212234,43 C27.212234,43.550781 27.661453,44 28.212234,44 C28.763015,44 29.212234,43.550781 29.212234,43 C29.212234,42.449219 28.763015,42 28.212234,42 Z M32.212234,42 C31.661453,42 31.212234,42.449219 31.212234,43 C31.212234,43.550781 31.661453,44 32.212234,44 C32.763015,44 33.212234,43.550781 33.212234,43 C33.212234,42.449219 32.763015,42 32.212234,42 Z M36.212234,42 C35.661453,42 35.212234,42.449219 35.212234,43 C35.212234,43.550781 35.661453,44 36.212234,44 C36.763015,44 37.212234,43.550781 37.212234,43 C37.212234,42.449219 36.763015,42 36.212234,42 Z M40.212234,42 C39.661453,42 39.212234,42.449219 39.212234,43 C39.212234,43.550781 39.661453,44 40.212234,44 C40.763015,44 41.212234,43.550781 41.212234,43 C41.212234,42.449219 40.763015,42 40.212234,42 Z M44.212234,42 C43.661453,42 43.212234,42.449219 43.212234,43 C43.212234,43.550781 43.661453,44 44.212234,44 C44.763015,44 45.212234,43.550781 45.212234,43 C45.212234,42.449219 44.763015,42 44.212234,42 Z M48.212234,42 C47.661453,42 47.212234,42.449219 47.212234,43 C47.212234,43.550781 47.661453,44 48.212234,44 C48.763015,44 49.212234,43.550781 49.212234,43 C49.212234,42.449219 48.763015,42 48.212234,42 Z M52.212234,42 C51.661453,42 51.212234,42.449219 51.212234,43 C51.212234,43.550781 51.661453,44 52.212234,44 C52.763015,44 53.212234,43.550781 53.212234,43 C53.212234,42.449219 52.763015,42 52.212234,42 Z" id="inside_range" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">BMI values should be within specified range</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_between()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="bmi" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>bmi</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="[10L, 44L]" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>[10, 44]</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">19</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `residence` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="residence" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>residence</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">20</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `site` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="site" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>site</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">21</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `reference_date` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="reference_date" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>reference_date</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">22</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_status` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_status" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_status</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">23</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `study_status` should be in the set of `completed`, `ongoing`, `discontinued` (and 1 more). " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_in_set</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_in_set" transform="translate(0.000000, 0.172414)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M44.127969,41.1538382 L31.0814568,41.1538382 C29.9510748,41.1536429 28.8827052,40.9256134 27.9079888,40.5136953 C26.4467442,39.8960136 25.19849,38.8599685 24.3189894,37.5577099 C23.8792391,36.906727 23.5314818,36.1899233 23.2936866,35.4252675 C23.2130217,35.16589 23.1460289,34.9005554 23.0913409,34.6307286 L44.1278714,34.6307286 C45.028466,34.6306309 45.7586488,33.9004481 45.7586488,32.9998535 C45.7586488,32.0992589 45.028466,31.3690761 44.1278714,31.3690761 L23.0905596,31.3690761 C23.1990567,30.8337194 23.3597028,30.3180894 23.5675173,29.8264831 C24.185199,28.3652386 25.2212442,27.1169844 26.5236004,26.2374838 C27.1745833,25.7977334 27.891387,25.4499762 28.6560428,25.2122786 C29.4208939,24.9744833 30.2334994,24.8459665 31.0813591,24.8459665 L44.1277737,24.8459665 C45.0283683,24.8459665 45.7586488,24.1157837 45.7586488,23.2151891 C45.7586488,22.3145945 45.0283683,21.5844117 44.1277737,21.5844117 L31.0813591,21.5844117 C29.5096643,21.5844117 28.0039858,21.9038483 26.6373711,22.4820765 C24.5866678,23.3498583 22.8469049,24.7950871 21.6163267,26.616296 C20.3856508,28.4362354 19.665136,30.6413347 19.6658191,33.0000488 C19.6658191,34.5717436 19.9852563,36.0774222 20.5635822,37.4440369 C21.4312663,39.4947402 22.8765927,41.2345031 24.697704,42.4650813 C26.5176434,43.6957572 28.7227427,44.4155883 31.0814568,44.4155883 L44.1278714,44.4155883 C45.028466,44.4155883 45.7586488,43.6854055 45.7586488,42.7848109 C45.7586488,41.8842163 45.0285636,41.1538382 44.127969,41.1538382 Z" id="set_of" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Values should be one of the specified options</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_in_set()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_status" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_status</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="completed, ongoing, discontinued, NA" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>completed, ongoing, discontinued, NA</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>17</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>17</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">24</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `discontinuation_reason` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="discontinuation_reason" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>discontinuation_reason</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">25</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `discontinuation_timepoint` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="discontinuation_timepoint" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>discontinuation_timepoint</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:14 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:14 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:15]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `experiment_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="experiment_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>experiment_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `experiment_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Experiment ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="experiment_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>experiment_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>2K</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>2K</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `source_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="source_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>source_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `study_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="study_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>study_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `timepoint` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="timepoint" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>timepoint</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `target_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="target_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>target_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">7</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `npx` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="npx" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>npx</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">8</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `condition` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="condition" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>condition</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:15 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:15 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> <div id="pb_agent" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#> @import url("https://unpkg.com/balloon-css/balloon.min.css");
#> #pb_agent table {
#>   font-family: 'IBM Plex Sans', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #pb_agent thead, #pb_agent tbody, #pb_agent tfoot, #pb_agent tr, #pb_agent td, #pb_agent th {
#>   border-style: none;
#> }
#> 
#> #pb_agent p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #pb_agent .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 90%;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #pb_agent .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #pb_agent .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #pb_agent .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #pb_agent .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #pb_agent .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #pb_agent .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #pb_agent .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #pb_agent .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #pb_agent .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #pb_agent .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #pb_agent .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #pb_agent .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #pb_agent .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #pb_agent .gt_left {
#>   text-align: left;
#> }
#> 
#> #pb_agent .gt_center {
#>   text-align: center;
#> }
#> 
#> #pb_agent .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #pb_agent .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #pb_agent .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #pb_agent .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #pb_agent .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #pb_agent .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #pb_agent .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #pb_agent .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #pb_agent .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #pb_agent .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #pb_agent .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #pb_agent .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #pb_agent .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #pb_agent div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> 
#> #pb_agent {
#>   -webkit-font-smoothing: antialiased;
#> }
#> 
#> #pb_agent .gt_row {
#>   overflow: visible;
#> }
#> 
#> #pb_agent .gt_sourcenote {
#>   height: 35px;
#>   padding: 0;
#> }
#> 
#> #pb_agent code {
#>   font-family: 'IBM Plex Mono', monospace, courier;
#>   color: black;
#>   background-color: transparent;
#>   padding: 0;
#> }
#> </style>
#>   <table class="gt_table" style="table-layout:fixed;width:0px;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <colgroup>
#>     <col style="width:6px;"/>
#>     <col style="width:35px;"/>
#>     <col style="width:190px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:120px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:50px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:30px;"/>
#>     <col style="width:65px;"/>
#>   </colgroup>
#>   <thead>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_title gt_font_normal" style="color: #444444; font-size: 28px; text-align: left; font-weight: 500;">Pointblank Validation</td>
#>     </tr>
#>     <tr class="gt_heading">
#>       <td colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style="font-size: 12px; text-align: left;"><span class='gt_from_md'><span style="text-decoration-style:solid;text-decoration-color:#ADD8E6;text-decoration-line:underline;text-underline-position:under;color:#333333;font-variant-numeric:tabular-nums;padding-left:4px;margin-right:5px;padding-right:2px;">[2026-11-12|14:45:15]</span></p>
#> <div style="height:25px;padding-top:10px;"><span style="background-color:#9933CC;color:#FFFFFF;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 0px 5px 5px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">data frame</span>
#> <span style="background-color:none;color:#222222;padding:0.5em 0.5em;position:inherit;margin:5px 10px 5px -4px;font-weight:bold;border:solid 1px #9933CC;padding:2px 15px 2px 15px;font-size:smaller;">databook$data</span></div>
#> </span></td>
#>     </tr>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="status_color"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="i"></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="type">STEP</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="columns">COLUMNS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="values">VALUES</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="precon">TBL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="eval_sym">EVAL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="units">UNITS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_pass">PASS</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="n_fail">FAIL</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="W">W</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="S">S</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="N">N</th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #666666; font-weight: bold;" scope="col" id="extract">EXT</th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">1</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `analysis_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="analysis_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>analysis_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">2</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that all values in `analysis_id` should not be NULL. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="float:left;width:30px;"><div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_not_null</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_not_null" transform="translate(0.000000, 0.551724)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M40.6120805,47.037834 C37.4692348,47.037834 35.0126139,45.9348613 33.712234,44.0140597 C32.4118541,45.9348613 29.9552331,47.037834 26.8123883,47.037834 C22.6574397,47.037834 16.0646712,43.4437723 16.0646712,33.8021619 C16.0646712,29.3401361 17.4715879,18.962166 30.5035862,18.962166 C30.9454018,18.962166 31.3057481,19.3225124 31.3057481,19.7643279 L31.3057481,21.3686518 C31.3057481,21.8104674 30.9454018,22.1708138 30.5035862,22.1708138 C26.6400486,22.1708138 22.4819668,25.8118774 22.4819668,33.8021619 C22.4819668,37.5090277 23.7635456,43.0270243 27.2949384,43.0270243 C29.795428,43.0270243 31.224279,40.4231312 32.0985095,38.2861221 C30.5067194,35.6101596 29.7014243,33.1034035 29.7014243,30.8347892 C29.7014243,25.6238707 31.8603677,23.7751377 33.712234,23.7751377 C35.5641002,23.7751377 37.7230437,25.6238707 37.7230437,30.8347892 C37.7230437,33.1347383 36.9396828,35.5788255 35.3290916,38.2861221 C36.6294715,41.4321009 38.243196,43.0270243 40.1295295,43.0270243 C43.6609223,43.0270243 44.9425012,37.5090277 44.9425012,33.8021619 C44.9425012,25.8118774 40.7844193,22.1708138 36.9208817,22.1708138 C36.4759329,22.1708138 36.1187198,21.8104674 36.1187198,21.3686518 L36.1187198,19.7643279 C36.1187198,19.3225124 36.4759329,18.962166 36.9208817,18.962166 C49.9528801,18.962166 51.3597967,29.3401361 51.3597967,33.8021619 C51.3597967,43.4437723 44.7670282,47.037834 40.6120805,47.037834 Z" id="omega" fill="#000000" fill-rule="nonzero"></path>            <path d="M33,7.93597705 C33.2761424,7.93597705 33.5,8.15983467 33.5,8.43597705 L33.5,57.564023 C33.5,57.8401653 33.2761424,58.064023 33,58.064023 C32.7238576,58.064023 32.5,57.8401653 32.5,57.564023 L32.5,8.43597705 C32.5,8.15983467 32.7238576,7.93597705 33,7.93597705 Z" id="line_black" fill="#000000" transform="translate(33.000000, 33.000000) rotate(-320.000000) translate(-33.000000, -33.000000) "></path>            <polygon id="line_white" fill="#FFFFFF" transform="translate(34.899496, 32.153303) rotate(-320.000000) translate(-34.899496, -32.153303) " points="34.3994962 8.54160469 35.3994962 8.54160469 35.3994962 55.7650019 34.3994962 55.7650019"></polygon>        </g>    </g></svg></div></div>
#>   <div style="line-height:0.7em;margin-left:32px;padding-left:3px;">
#>     <p style="margin:0;padding-top:4px;font-size:9px;">Analysis ID is required</p>
#>     <p style="margin:0;">
#>       <code style="font-size:11px;">col_vals_not_null()</code>
#>     </p>
#>   </div>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="analysis_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>analysis_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>11K</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>11K</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">3</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `cluster_id` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="cluster_id" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>cluster_id</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">4</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `marker_name` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="marker_name" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>marker_name</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">5</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `measurement` is of type: character. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_character</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_character" transform="translate(0.000000, 0.448276)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M47.853356,43.3320522 C45.9913675,43.3320522 44.4467866,42.6422804 43.2195669,41.2627162 C41.9923472,39.883152 41.3787466,38.1439116 41.3787466,36.0449428 C41.3787466,33.802093 41.9859996,32.0543892 43.2005239,30.8017787 C44.4150482,29.5491683 46.1098555,28.9228725 48.2849966,28.9228725 C49.3598718,28.9228725 50.5616827,29.070983 51.8904653,29.3672084 L51.8904653,31.461935 C50.4770468,31.0472194 49.3260167,30.8398647 48.4373403,30.8398647 C47.1593392,30.8398647 46.133145,31.3201659 45.3587271,32.2807826 C44.5843091,33.2413994 44.197106,34.5214973 44.197106,36.1211147 C44.197106,37.6699505 44.5948884,38.9225422 45.3904653,39.8789272 C46.1860422,40.8353122 47.2270474,41.3134975 48.5135122,41.3134975 C49.6560961,41.3134975 50.8325166,41.0215082 52.0428091,40.4375209 L52.0428091,42.595724 C50.4262645,43.0866119 49.0297941,43.3320522 47.853356,43.3320522 Z" id="c" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:10px;">&nbsp;col_is_character()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="measurement" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>measurement</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">6</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that values in `measurement` should be in the set of `phenotype`, `median`, `ptile_80` (and 5 more). " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_vals_in_set</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_vals_in_set" transform="translate(0.000000, 0.172414)">            <path d="M56.712234,1 C59.1975153,1 61.4475153,2.00735931 63.076195,3.63603897 C64.7048747,5.26471863 65.712234,7.51471863 65.712234,10 L65.712234,10 L65.712234,65 L10.712234,65 C8.22695259,65 5.97695259,63.9926407 4.34827294,62.363961 C2.71959328,60.7352814 1.71223397,58.4852814 1.71223397,56 L1.71223397,56 L1.71223397,10 C1.71223397,7.51471863 2.71959328,5.26471863 4.34827294,3.63603897 C5.97695259,2.00735931 8.22695259,1 10.712234,1 L10.712234,1 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <path d="M44.127969,41.1538382 L31.0814568,41.1538382 C29.9510748,41.1536429 28.8827052,40.9256134 27.9079888,40.5136953 C26.4467442,39.8960136 25.19849,38.8599685 24.3189894,37.5577099 C23.8792391,36.906727 23.5314818,36.1899233 23.2936866,35.4252675 C23.2130217,35.16589 23.1460289,34.9005554 23.0913409,34.6307286 L44.1278714,34.6307286 C45.028466,34.6306309 45.7586488,33.9004481 45.7586488,32.9998535 C45.7586488,32.0992589 45.028466,31.3690761 44.1278714,31.3690761 L23.0905596,31.3690761 C23.1990567,30.8337194 23.3597028,30.3180894 23.5675173,29.8264831 C24.185199,28.3652386 25.2212442,27.1169844 26.5236004,26.2374838 C27.1745833,25.7977334 27.891387,25.4499762 28.6560428,25.2122786 C29.4208939,24.9744833 30.2334994,24.8459665 31.0813591,24.8459665 L44.1277737,24.8459665 C45.0283683,24.8459665 45.7586488,24.1157837 45.7586488,23.2151891 C45.7586488,22.3145945 45.0283683,21.5844117 44.1277737,21.5844117 L31.0813591,21.5844117 C29.5096643,21.5844117 28.0039858,21.9038483 26.6373711,22.4820765 C24.5866678,23.3498583 22.8469049,24.7950871 21.6163267,26.616296 C20.3856508,28.4362354 19.665136,30.6413347 19.6658191,33.0000488 C19.6658191,34.5717436 19.9852563,36.0774222 20.5635822,37.4440369 C21.4312663,39.4947402 22.8765927,41.2345031 24.697704,42.4650813 C26.5176434,43.6957572 28.7227427,44.4155883 31.0814568,44.4155883 L44.1278714,44.4155883 C45.028466,44.4155883 45.7586488,43.6854055 45.7586488,42.7848109 C45.7586488,41.8842163 45.0285636,41.1538382 44.127969,41.1538382 Z" id="set_of" fill="#000000" fill-rule="nonzero"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_vals_in_set()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="measurement" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>measurement</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="phenotype, median, ptile_80, ptile_95, ptile_99, min, max, std" data-balloon-pos="left"><p style="margin-top: 0px; margin-bottom: 0px; font-size: 11px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;"><code>phenotype, median, ptile_80, ptile_95, ptile_99, min, max, std</code></p></div>
#> </span></td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>11K</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>11K</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>     <tr><td headers="status_color" class="gt_row gt_left" style="background-color: #4CA64C; height: 40px"><br /></td>
#> <td headers="i" class="gt_row gt_right" style="color: #666666; font-size: 13px; font-weight: bold; height: 40px">7</td>
#> <td headers="type" class="gt_row gt_left" style="height: 40px"><span class='gt_from_md'><div aria-label="Expect that column `value` is of type: numeric. " data-balloon-pos="right" style="width:fit-content;">
#>   <div style="margin:0;padding:0;display:inline-block;height:30px;vertical-align:middle;"><?xml version="1.0" encoding="UTF-8"?><svg width="30px" height="30px" viewBox="0 0 67 67" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">    <title>col_is_numeric</title>    <g id="All-Icons" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="col_is_numeric" transform="translate(0.000000, 0.931034)">            <path d="M56.712234,1.01466935 C59.1975153,1.01466935 61.4475153,2.02202867 63.076195,3.65070832 C64.7048747,5.27938798 65.712234,7.52938798 65.712234,10.0146694 L65.712234,10.0146694 L65.712234,65.0146694 L10.712234,65.0146694 C8.22695259,65.0146694 5.97695259,64.00731 4.34827294,62.3786304 C2.71959328,60.7499507 1.71223397,58.4999507 1.71223397,56.0146694 L1.71223397,56.0146694 L1.71223397,10.0146694 C1.71223397,7.52938798 2.71959328,5.27938798 4.34827294,3.65070832 C5.97695259,2.02202867 8.22695259,1.01466935 10.712234,1.01466935 L10.712234,1.01466935 Z" id="rectangle" stroke="#000000" stroke-width="2" fill="#FFFFFF"></path>            <rect id="column" fill="#000000" x="12.2117153" y="12.0146694" width="20" height="42" rx="1"></rect>            <path d="M49.7957388,43.0146694 L49.7957388,40.4248256 C48.7801087,42.3629863 47.248223,43.3320522 45.2000357,43.3320522 C43.5411732,43.3320522 42.2356849,42.726915 41.2835317,41.5166225 C40.3313785,40.30633 39.8553091,38.6517241 39.8553091,36.5527553 C39.8553091,34.259124 40.3948545,32.4140904 41.4739614,31.017599 C42.5530684,29.6211077 43.9728133,28.9228725 45.7332388,28.9228725 C47.3667105,28.9228725 48.7208636,29.5491683 49.7957388,30.8017787 L49.7957388,22.9687709 L52.3094107,22.9687709 L52.3094107,43.0146694 L49.7957388,43.0146694 Z M49.7957388,32.5156459 C48.5008104,31.3730621 47.2736092,30.8017787 46.1140982,30.8017787 C43.7189039,30.8017787 42.5213247,32.6341172 42.5213247,36.298849 C42.5213247,39.5234745 43.5877203,41.1357631 45.7205435,41.1357631 C47.1085712,41.1357631 48.4669561,40.3782837 49.7957388,38.8633022 L49.7957388,32.5156459 Z" id="d" fill="#000000"></path>        </g>    </g></svg></div>
#>   <code style="font-size:11px;">&nbsp;col_is_numeric()</code>
#> </div>
#> </span></td>
#> <td headers="columns" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px"><span class='gt_from_md'><div aria-label="value" data-balloon-pos="left">
#>   <p style="margin-top:0;margin-bottom:0;font-size:11px;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;line-height:2em;">
#>     <code><span style="color:purple;">&marker;</span>value</code>
#>   </p>
#> </div>
#> </span></td>
#> <td headers="values" class="gt_row gt_left" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; height: 40px">—</td>
#> <td headers="precon" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:0;color:#333333;vertical-align:middle;font-size:10px;border:none;border-radius:4px;" aria-label="No modifications of the table." data-balloon-pos="left"><svg width="25px" height="25px" viewBox="0 0 25 25" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="vertical-align: middle;">    <g id="unchanged" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">        <g id="unchanged" transform="translate(0.500000, 0.570147)">            <rect id="Rectangle" x="0.125132506" y="0" width="23.749735" height="23.7894737"></rect>            <path d="M5.80375046,8.18194736 C3.77191832,8.18194736 2.11875046,9.83495328 2.11875046,11.8669474 C2.11875046,13.8989414 3.77191832,15.5519474 5.80375046,15.5519474 C7.8355826,15.5519474 9.48875046,13.8989414 9.48875046,11.8669474 C9.48875046,9.83495328 7.83552863,8.18194736 5.80375046,8.18194736 Z M5.80375046,14.814915 C4.17821997,14.814915 2.85578285,13.4924778 2.85578285,11.8669474 C2.85578285,10.2414169 4.17821997,8.91897975 5.80375046,8.91897975 C7.42928095,8.91897975 8.75171807,10.2414169 8.75171807,11.8669474 C8.75171807,13.4924778 7.42928095,14.814915 5.80375046,14.814915 Z" id="Shape" fill="#000000" fill-rule="nonzero"></path>            <path d="M13.9638189,8.699335 C13.9364621,8.70430925 13.9091059,8.71176968 13.8842359,8.71923074 C13.7822704,8.73663967 13.6877654,8.77643115 13.6056956,8.83860518 L10.2433156,11.3852598 C10.0766886,11.5046343 9.97720993,11.6986181 9.97720993,11.9025491 C9.97720993,12.1064807 10.0766886,12.3004639 10.2433156,12.4198383 L13.6056956,14.966493 C13.891697,15.1803725 14.2970729,15.1231721 14.5109517,14.8371707 C14.7248313,14.5511692 14.6676309,14.145794 14.3816294,13.9319145 L12.5313257,12.5392127 L21.8812495,12.5392127 L21.8812495,11.2658854 L12.5313257,11.2658854 L14.3816294,9.87318364 C14.6377872,9.71650453 14.7497006,9.40066014 14.6477351,9.11714553 C14.5482564,8.83363156 14.262255,8.65954352 13.9638189,8.699335 Z" id="arrow" fill="#000000" transform="translate(15.929230, 11.894737) rotate(-180.000000) translate(-15.929230, -11.894737) "></path>        </g>    </g></svg></span></span></td>
#> <td headers="eval_sym" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="background:transparent;padding:5px;color:#4CA64C;vertical-align:middle;font-size:15px;border:none;" aria-label="No evaluation issues." data-balloon-pos="left">✓</span></span></td>
#> <td headers="units" class="gt_row gt_right" style="font-size: 11px; height: 40px"><code>1</code></td>
#> <td headers="n_pass" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>1</code><br><code>1.00</code></td>
#> <td headers="n_fail" class="gt_row gt_right" style="border-left-width: 1px; border-left-style: dashed; border-left-color: #E5E5E5; font-size: 11px; height: 40px"><code>0</code><br><code>0.00</code></td>
#> <td headers="W" class="gt_row gt_center" style="border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'><span style="color: #E5AB00;">○</span></span></td>
#> <td headers="S" class="gt_row gt_center" style="background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="N" class="gt_row gt_center" style="border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; background-color: #FCFCFC; height: 40px"><span class='gt_from_md'>—</span></td>
#> <td headers="extract" class="gt_row gt_center" style="height: 40px"><span class='gt_from_md'>—</span></td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_sourcenotes">
#>       <td class="gt_sourcenote" colspan="14"><span class='gt_from_md'><span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin-left:10px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;padding:2px 10px 2px 10px;">2026-11-12 14:45:15 UTC</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;margin:5px 1px 5px 0;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">&lt; 1 s</span>
#> <span style="background-color:#FFF;color:#444;padding:0.5em 0.5em;position:inherit;text-transform:uppercase;margin:5px 1px 5px -1px;border:solid 1px #999999;font-variant-numeric:tabular-nums;border-radius:0;padding:2px 10px 2px 10px;">2026-11-12 14:45:15 UTC</span></span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
#> [1] "study"
#> [1] "experiment"
#> [1] "experiment_array"
#> [1] "experiment_aurora"
#> [1] "experiment_cytof"
#> [1] "experiment_elisa"
#> [1] "experiment_LCMS"
#> [1] "experiment_luminex"
#> [1] "experiment_olink"
#> [1] "experiment_UPLC"
#> [1] "analysis"
#> [1] "analysis_array"
#> [1] "analysis_elisa"
#> [1] "analysis_glycoprofiling"
#> [1] "analysis_luminex"
#> [1] "analysis_omiq"
#> [1] "analysis_som"
```

[`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md)
scans the project directory for ETL scripts, runs each one, validates
the output against its codebook, and loads the results into the
database. It is the single function you call whenever scripts or data
change.

------------------------------------------------------------------------

## 5. Verify data loaded

Check which tables now exist:

``` r

DBI::dbListTables(con)
#>  [1] "HGNC"                       "LCMS_layout"               
#>  [3] "LUNC"                       "UPLC_layout"               
#>  [5] "adverse_event"              "analysis"                  
#>  [7] "analysis_array"             "analysis_elisa"            
#>  [9] "analysis_glycoprofiling"    "analysis_luminex"          
#> [11] "analysis_omiq"              "analysis_som"              
#> [13] "array_measurement"          "arrayexpression"           
#> [15] "arraypanel"                 "aurorabarcodingscheme"     
#> [17] "aurorapanel"                "cytofbarcodingscheme"      
#> [19] "cytofpanel"                 "cytofspillover"            
#> [21] "elisa_absorbance"           "elisa_layout"              
#> [23] "elisa_measurement"          "elisa_result"              
#> [25] "elisastandards"             "experiment"                
#> [27] "experiment_LCMS"            "experiment_UPLC"           
#> [29] "experiment_array"           "experiment_aurora"         
#> [31] "experiment_cytof"           "experiment_elisa"          
#> [33] "experiment_luminex"         "experiment_olink"          
#> [35] "glycanarraypanel"           "glycoprofiling_measurement"
#> [37] "id_mapping"                 "luminex_measurement"       
#> [39] "luminexexpression"          "olinkexpression"           
#> [41] "omiq_gatingphenotype"       "omiq_measurement"          
#> [43] "participant"                "publications"              
#> [45] "sample"                     "som_clusterphenotype"      
#> [47] "som_codes"                  "som_measurement"           
#> [49] "study"                      "studyarm"                  
#> [51] "studydesign"                "table_codebook"            
#> [53] "table_datasource"           "table_dependency"          
#> [55] "table_project"              "table_script"
```

Pull the participant table to confirm real rows arrived:

``` r

participants <- collectTable("participant")
nrow(participants)
#> [1] 17
head(participants[, c("participant_id", "study_id", "age", "sex")])
#>   participant_id study_id age sex
#> 1   CHSI1_16e879    CHSI1  19   F
#> 2   CHSI1_da37e0    CHSI1  30   M
#> 3   CHSI1_c86d33    CHSI1  31   M
#> 4   CHSI1_b5c72a    CHSI1  24   M
#> 5   CHSI1_24929e    CHSI1  19   F
#> 6   CHSI1_6cc05c    CHSI1  24   F
```

You can explore any other table the same way:

``` r

collectTable("studyarm")[, c("studyarm_id", "study_id", "studyarm_name")]
#>         studyarm_id study_id studyarm_name
#> 1        CHSI1_grA1    CHSI1          <NA>
#> 2        CHSI1_grA2    CHSI1          <NA>
#> 3        CHSI1_grA3    CHSI1          <NA>
#> 4        CHSI1_grB3    CHSI1          <NA>
#> 5 RCHSI_reinfection    RCHSI          <NA>
#> 6     RCHSI_control    RCHSI          <NA>
```

------------------------------------------------------------------------

## What’s next

The smoke test confirms the pipeline works end-to-end. From here:

| Guide | What you will learn |
|----|----|
| [Starting a project](https://koenastam.github.io/beFAIR/articles/starting_a_project.md) | Set up a FAIRground for your own data and register your first study |
| [Adding a study](https://koenastam.github.io/beFAIR/articles/adding_a_study.md) | Write and fill in the four study ETL scripts |
| [Adding an experiment](https://koenastam.github.io/beFAIR/articles/adding_an_experiment.md) | Register an experiment and complete the experiment ETL scripts |
| [Developer internals](https://koenastam.github.io/beFAIR/articles/developer_internals.md) | Understand what [`databaseUpdate()`](https://koenastam.github.io/beFAIR/reference/databaseUpdate.md) does under the hood |
