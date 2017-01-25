# README

This folder is to prepare data for the Toolbox. Files within this `prep` folder will also sync with GitHub. 

Avoid .xls and .doc files if possible, as GitHub has trouble with large files 

## Layer prep workflow 

1. copy `prep/data_prep_template.rmd` into a prep directory, rename `.rmd` and rename line 2. Note that `output: github_document`: this means the `.rmd` will knit as a `.md` that github can render, so you won't need an `.html` document at all.
2. data prep in your `.rmd`
3. knit as `.md` file (push 'knit' button at top of the screen); the outputs will be a new `.md` file with the same name and a folder of images to be displayed. Knitting will also create a README.md with the url to view the rendered `.md` file. 
4. add any additional notes to the README
5. commit and push
6. view the rendered `.md` file using the link in the README (displayed at the bottom of the repo). 
