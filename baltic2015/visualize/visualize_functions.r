##VISUALIZE PLOT FUNCTIONS ##

## These functions are to create generic plots of raw data inputs for BHI goals to
## visualize the spatial and temporal dimensions of the data used for goal status



## Created by Jennifer Griffiths
## 21 July 2016




##---------------------------------------##
## FUNCTION:  plot_datalocation_latlon
## plot unique lat-lon location of data samples

plot_datalocation_latlon = function(mapdata){
  ##mapdata - dataframe with columns
  ##lat
  ##lon
  ##data_descrip
  ##bhi_goal


  ## get the Baltic Sea map template

  map = get_map(location = c(8.5, 53, 32, 67.5), maptype="hybrid")

  ##set up plot
  plot_map = ggmap(map) +
    geom_point(aes(x=lon, y=lat), colour="yellow", data=mapdata,size = 1.5)

  ##plot the map
  return( plot_map +
            ggtitle(paste(mapdata[1,3],"for goal", mapdata[1,4])) +
            theme(title = element_text(size = 11)))

} ## end function
##---------------------------------------##




##---------------------------------------##
## FUNCTION: plot_datatime
## plot times series data, plots by a facet (basin,station,rgn_id)
## with or without color coding by variable

plot_datatime = function(timedata, facet_type, variable = TRUE){
  ##timedata - dataframe with columns
  ##year
  ##value
  ##unit
  ##station, basin, rgn_id - at least one required
  ##variable - this is for color/shape coding
  ##bhi_goal
  ##data_descrip

  ##facet_type
  ##single character vector describing the facet_wrap option
  ## "station", "basin", "rgn_id"

  ## variable = TRUE if there are different data variables that should be color coded in the plot

  if(variable == FALSE){

    facet = data.frame(facet=timedata[,facet_type])

    timedata = timedata %>%
      select(year,value,unit,bhi_goal,data_descrip)%>%
      bind_cols(.,facet)

    p = ggplot(timedata)+
      geom_point(aes(year,value))+
      facet_wrap(~facet)

    return(p+
             ylab(paste(timedata[1,"unit"]))+
             theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                              hjust=.5, vjust=.5, face = "plain"),
                   strip.text.x = element_text(size = 8))+
             ggtitle(paste(timedata[1,"data_descrip"], "for goal",
                           timedata[1,"bhi_goal"], "by", facet_type )))
  }

  if(variable == TRUE){

    facet = data.frame(facet=timedata[,facet_type])

    timedata = timedata %>%
      select(year,value,unit,bhi_goal,data_descrip,variable)%>%
      bind_cols(.,facet)

    p = ggplot(timedata)+
      geom_point(aes(year,value, colour=as.factor(variable)))+
      facet_wrap(~facet)

    return(p+
             ylab(paste(timedata[1,"unit"]))+
             theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                              hjust=.5, vjust=.5, face = "plain"),
                   strip.text.x = element_text(size = 8))+
             ggtitle(paste(timedata[1,"data_descrip"], "for goal",
                           timedata[1,"bhi_goal"], "by", facet_type )))
  }


}## end function
##---------------------------------------##




##---------------------------------------##
## FUNCTION: plot_datavalue
## plot data value by location (for data without time series), plots by a variable if variable ==TRUE

plot_datavalue = function(valuedata, variable = TRUE){
  ##valuedata - dataframe with columns
  ##value
  ##unit
  ##location - primary location for x axis
  ##variable - this for faceting
  ##bhi_goal
  ##data_descrip

    if(variable == FALSE){

    valuedata = valuedata %>%
      select(location,value,unit,bhi_goal,data_descrip)


    p = ggplot(valuedata)+
      geom_point(aes(location,value))


    return(p+
             ylab(paste(valuedata[1,"unit"]))+
             theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                              hjust=.5, vjust=.5, face = "plain"),
                   strip.text.x = element_text(size = 8))+
             ggtitle(paste(valuedata[1,"data_descrip"], "for goal",
                           valuedata[1,"bhi_goal"])))
  }


  if(variable == TRUE){


    valuedata = valuedata %>%
      select(location,value,unit,bhi_goal,data_descrip,variable)

    p = ggplot(valuedata)+
      geom_point(aes(location,value))+
      facet_wrap(~variable)

    return(p+
             ylab(paste(valuedata[1,"unit"]))+
             theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                              hjust=.5, vjust=.5, face = "plain"),
                   strip.text.x = element_text(size = 8))+
             ggtitle(paste(valuedata[1,"data_descrip"], "for goal",
                           valuedata[1,"bhi_goal"])))
  }


}## end function

##---------------------------------------##




##---------------------------------------##
## FUNCTION: plotScoreTypes
## Plot map of each score type, uses function PlotMap( from baltic2015/PlotMap.r)


plotScoreTypes = function(scores,goal){

PlotMap(filter(scores, dimension=="status"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
        map_title       = paste(goal, "Status Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'status score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)

  PlotMap(filter(scores, dimension=="trend"),        # dataframe with at least 2 columns: rgn_id and scores/values.
          rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
          map_title       = paste(goal, "Trend Score"),
          fld_rgn         = 'region_id',
          fld_score       = 'score',
          scale_label     = 'trend score',
          scale_limits    = c(-1, 1),
          print_fig       = TRUE, ### print to display
          fig_path        = NULL)

##plot pressures map
PlotMap(filter(scores, dimension=="pressures"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
        map_title       =  paste(goal, "Pressures Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'pressures score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)


##plot resilience map
PlotMap(filter(scores, dimension=="resilience"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
        map_title       = paste(goal, "Resilience Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'resilience score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)


##plot future map
PlotMap(filter(scores, dimension=="future"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
        map_title       = paste(goal, "Future Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'future score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)



## plot scores map
PlotMap(filter(scores, dimension=="score"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial('baltic2015/spatial/regions_gcs.geojson'), # default for OHI+
        map_title       = paste(goal, "Overall Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)

}##end plotScoreType

##---------------------------------------##




##---------------------------------------##
## FUNCTION: plotSubgoalRelationship

plotSubgoalRelationship = function(count,scores, subgoal_abb,goal){
    ## count = numeric, number of subgoals, must be > 1
    ## scores, filtered for subgoals
    ## subgoal_abb- subgoal abreviations
    ## goal name

    if(count ==2 ){
      sub1 = noquote(subgoal_abb[1])
      sub2 = noquote(subgoal_abb[2])

      scores_spread = scores%>%
                      spread(goal,score)

      ggplot(scores_spread)+
        geom_point(aes(paste(sub1),paste(sub2),colour=region_id))+
        facet_wrap(~dimension)+
        ylim(0,100)+
        xlim(0,100)+
        xlab(paste(sub1,"score"))+
        xlab(paste(sub2,"score"))+
        ggtitle(paste(goal, "subgoal comparision"))

    }


  if(count ==3 ){
    sub1 = noquote(subgoal_abb[1])
    sub2 = noquote(subgoal_abb[2])
    sub3 = noquote(subgoal_abb[3])

    scores_spread = scores%>%
      spread(goal,score)

    ggplot(scores_spread)+
      geom_point(aes(select(scores_spread, sub1),select(scores_spread, sub2),colour=region_id))+
      facet_wrap(~dimension)+
      ylim(0,100)+
      xlim(0,100)+
      xlab(paste(sub1,"score"))+
      xlab(paste(sub2,"score"))+
      ggtitle(paste(goal, "subgoal comparision"))

  }






}


