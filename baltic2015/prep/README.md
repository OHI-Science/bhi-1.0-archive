# README

This folder is to prepare data for the Toolbox. Files within this `prep` folder will also sync with GitHub. 

Avoid .xls and .doc files if possible, as GitHub has trouble with large files 

## Layer prep workflow 

- use `README.md`s within each prep folder (eg prep/LIV) to identify data source, brief description of the goal model, and other considerations/2.0

1. copy `prep/data_prep_template.rmd` into a prep directory, rename `.rmd` and rename line 2 
2. data prep in your `.rmd`
3. knit as .html file (push 'knit HTML' button at top of the screen); this will also create a README.md
4. commit and push
5. view the rendered .html file using the link in the README (displayed at the bottom of the repo). 
