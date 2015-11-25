Updating nutrient load pressures.
Introduced two nutrient pressures, nload.csv and pload.csv.

changes in pressures_matrix.csv
removed old po_nutrients and po_nutrients_3nmm from pressures_matirix.csv and kept the weighting from po_nutrients_3nm for both.

changes in layers.csv:
changed layer names po_nutrients_3nm and po_nutrients to nload and pload and filenames to nload.csv and pload.csv
changed description to match the data used.

then ran calculate_scores

NA at region ID 30, copied pressure score from region 36 to region 30 (Finland archipelago sea and finland northern baltic proper)

Got the following error message:

Error in CalculatePressuresAll(layers, conf, gamma = conf$config$pressures_gamma,  : 
  
In addition: Warning messages:
1: In CheckLayers("layers.csv", "layers", flds_id = conf$config$layers_id_fields) :
  Missing fields...
    nload: NA pressure_score
    pload: NA pressure_score
2: In eval(expr, envir, enclos) : NAs introduced by coercion
3: In left_join_impl(x, y, by$x, by$y) :
  joining factors with different levels, coercing to character vector
4: Grouping rowwise data frame strips rowwise nature 
5: In left_join_impl(x, y, by$x, by$y) :
  joining factor and character vector, coercing into character vector
6: In left_join_impl(x, y, by$x, by$y) :
  joining factors with different levels, coercing to character vector
7: In left_join_impl(x, y, by$x, by$y) :
  joining factor and character vector, coercing into character vector
8: In left_join_impl(x, y, by$x, by$y) :
  joining factors with different levels, coercing to character vector
9: In left_join_impl(x, y, by$x, by$y) :
  joining factor and character vector, coercing into character vector
10: In CalculatePressuresAll(layers, conf, gamma = conf$config$pressures_gamma,  :
  Error: Not all pressures layers range in value from 0 to 1!

Still same error when up-dating all layers.csv files in bhi repo. 
Could be that the problem is that the new .csv pressure files are does not have the pressure category prefix po_.
Changing their names to po_pload and po_nload in:
pressures_matrix.csv
layers.csv 
and the in the names of the .csv files 

--> same error message

Change header in .csv pressure files to pressure_score

--> that did the trick!