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
## need to have dir_baltic created


plotScoreTypes = function(scores,goal){

PlotMap(filter(scores, dimension=="status"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
        map_title       = paste(goal, "Status Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'status score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)

  PlotMap(filter(scores, dimension=="trend"),        # dataframe with at least 2 columns: rgn_id and scores/values.
          rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
          map_title       = paste(goal, "Trend Score"),
          fld_rgn         = 'region_id',
          fld_score       = 'score',
          scale_label     = 'trend score',
          scale_limits    = c(-1, 1),
          print_fig       = TRUE, ### print to display
          fig_path        = NULL)

##plot pressures map
PlotMap(filter(scores, dimension=="pressures"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
        map_title       = paste(goal, "Pressures Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'pressures score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)


##plot resilience map
PlotMap(filter(scores, dimension=="resilience"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
        map_title       = paste(goal, "Resilience Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'resilience score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)


##plot future map
PlotMap(filter(scores, dimension=="future"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
        map_title       = paste(goal, "Future Score"),
        fld_rgn         = 'region_id',
        fld_score       = 'score',
        scale_label     = 'future score',
        scale_limits    = c(0, 100),
        print_fig       = TRUE, ### print to display
        fig_path        = NULL)



## plot scores map
PlotMap(filter(scores, dimension=="score"),        # dataframe with at least 2 columns: rgn_id and scores/values.
        rgn_poly        = PrepSpatial(file.path(dir_baltic, 'spatial/regions_gcs.geojson')),
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
## FUNCTION: plotSubgoalsGoal
## Plot all dimensions by subgoal and goal across region ID
## for all goals with 2 or more subgoals

plotSubgoalsGoal = function(count_goals,scores, subgoal_abb,goal_name){

  ## count_goals = numeric, number of subgoals, must be > 1
  ## scores, the complete scores csv
  ## subgoal_abb- subgoal abreviations
  ## goal_name

  ## 2 subgoals
  if(count_goals ==2 ){

    ## filter score data for subgoals and goals
    scores_sub= scores %>% filter(goal %in% subgoal_abb)
    scores_goal = scores %>% filter(goal == goal_name )

    ## combine score data
    scores_plot = bind_rows(scores_sub,scores_goal)%>%
      filter(region_id !=0)

    ## get subgoal names
    sub1 = subgoal_abb[1]
    sub2 = subgoal_abb[2]

    ##--------------------------------------------------##

    ## plot scores separately
    ## set goal order
    plot_order = c(rep(sub1,42),rep(sub2,42),rep(goal_name,42))
    scores_plot$goal = with(scores_plot, factor(goal, levels = c(subgoal_abb,goal_name)))

    #plot
    p1 =ggplot(scores_plot)+
      geom_point(aes(region_id,score,colour=goal,shape = goal))+
      scale_colour_manual(name="Goal Name",values=c("dark blue", "light blue",
                                                    "black"))+
      facet_wrap(~dimension, scales = "free_y")+
      scale_shape_manual(values=c(1,1,19), guide=FALSE)+
      xlab("BHI region")+
      ylab("score")+
      ggtitle(paste(goal_name , "Subgoal and Goal scores"))


    return(p1)
  }## end 2 subgoals


  if(count_goals ==3 ){

    ## filter score data for subgoals and goals
    scores_sub= scores %>% filter(goal %in% subgoal_abb)
    scores_goal = scores %>% filter(goal == goal_name )

    ## combine score data
    scores_plot = bind_rows(scores_sub,scores_goal) %>%
      filter(region_id !=0)

    ## get subgoal names
    sub1 = subgoal_abb[1]
    sub2 = subgoal_abb[2]
    sub3 = subgoal_abb[3]

    ##--------------------------------------------------##
    ## plot scores separately
    ## set goal order
    plot_order = c(rep(sub1,42),rep(sub2,42),rep(sub3,42),rep(goal_name,42))
    scores_plot$goal = with(scores_plot, factor(goal, levels = c(subgoal_abb,goal_name)))

    #plot
    p1= ggplot(scores_plot)+
      geom_point(aes(region_id,score,colour=goal,shape = goal))+
      scale_colour_manual(name="Goal Name",values=c("dark blue", "light blue",
                                                    "gray","black"))+
      scale_shape_manual(values=c(1,1,1,19), guide=FALSE)+
      facet_wrap(~dimension, scales = "free_y")+
      xlab("BHI region")+
      ylab("score")+
      ggtitle(paste(goal_name , "Subgoal and Goal scores"))

    return(p1)

  } ## end 3 subgoals

}## end function
#---------------------------------------##


##---------------------------------------##
## FUNCTION: plotSubgoalsGoal_bar
## Plot all dimensions by subgoal and goal across region ID as bar plot
## for all goals with 2 or more subgoals


plotSubgoalsGoal_bar = function(count_goals,scores, subgoal_abb,goal_name){

  ## count_goals = numeric, number of subgoals, must be > 1
  ## scores, the complete scores csv
  ## subgoal_abb- subgoal abreviations
  ## goal_name

  ## 2 subgoals
  if(count_goals ==2 ){

    ## filter score data for subgoals and goals
    scores_sub= scores %>% filter(goal %in% subgoal_abb)
    scores_goal = scores %>% filter(goal == goal_name )

    ## combine score data
    scores_plot = bind_rows(scores_sub,scores_goal)%>%
      filter(region_id !=0)

    ## get subgoal names
    sub1 = subgoal_abb[1]
    sub2 = subgoal_abb[2]

    ##--------------------------------------------------##

    ## plot scores separately
    ## set goal order
    plot_order = c(rep(sub1,42),rep(sub2,42),rep(goal_name,42))
    scores_plot$goal = with(scores_plot, factor(goal, levels = c(subgoal_abb,goal_name)))

    #plot
    p1 =ggplot(scores_plot,aes(x=region_id,y=score, colour=goal))+
      geom_bar(stat="identity", position="dodge", fill="white")+
      scale_colour_manual(name="Goal Name",values=c("dark blue", "light blue",
                                                    "black"))+
      facet_wrap(~dimension, scales = "free_y")+
      xlab("BHI region")+
      ylab("score")+
      ggtitle(paste(goal_name , "Subgoal and Goal scores"))


    return(p1)
  }## end 2 subgoals




  if(count_goals ==3 ){

    ## filter score data for subgoals and goals
    scores_sub= scores %>% filter(goal %in% subgoal_abb)
    scores_goal = scores %>% filter(goal == goal_name )

    ## combine score data
    scores_plot = bind_rows(scores_sub,scores_goal) %>%
      filter(region_id !=0)

    ## get subgoal names
    sub1 = subgoal_abb[1]
    sub2 = subgoal_abb[2]
    sub3 = subgoal_abb[3]

    ##--------------------------------------------------##
    ## plot scores separately
    ## set goal order
    plot_order = c(rep(sub1,42),rep(sub2,42),rep(sub3,42),rep(goal_name,42))
    scores_plot$goal = with(scores_plot, factor(goal, levels = c(subgoal_abb,goal_name)))

    #plot
    p1= ggplot(scores_plot,aes(x=region_id,y=score, colour=goal))+
      geom_bar(stat="identity", position="dodge", fill="white")+
      scale_colour_manual(name="Goal Name",values=c("dark blue", "light blue","gray",
                                                    "black"))+
      facet_wrap(~dimension, scales = "free_y")+
      xlab("BHI region")+
      ylab("score")+
      ggtitle(paste(goal_name , "Subgoal and Goal scores"))

    return(p1)

  } ## end 3 subgoals

}## end function
##---------------------------------------##


##---------------------------------------##
## FUNCTION: plotSubgoalRelationship
## plot relationship between subgoals for  goals with 2 or 3 subgoals
## (if one subgoal, do not need to plot comparison for goal)
## NOTE:  IF there are NA values for one of the subgoals, the others do not plot!

plotSubgoalRelationship = function(count_goals,scores, subgoal_abb,goal_name){
    ## count_goals = numeric, number of subgoals, must be > 1
    ## scores, the complete scores csv
    ## subgoal_abb- subgoal abreviations
    ## goal_name

    ## 2 subgoals
    if(count_goals ==2 ){

     ## filter score data for subgoals and goals
      scores_sub= scores %>% filter(goal %in% subgoal_abb)
      scores_goal = scores %>% filter(goal == goal_name )

      ## combine score data
      scores_plot = bind_rows(scores_sub,scores_goal)%>%
        filter(region_id !=0)

     ## get subgoal names
      sub1 = subgoal_abb[1]
      sub2 = subgoal_abb[2]

      ##--------------------------------------------------##
      ## plot comparison scores

      ## rename subgoals to generic names and spread data
      scores_spread = scores_plot %>%
                      mutate(goal= ifelse(goal == sub1,"sub1",
                                   ifelse(goal == sub2, "sub2","goal"))) %>%
                      spread(goal,score)


      ## plot subgoal 1 (x-axis)  and subgoal 2 (y-axis)
      p2= ggplot(scores_spread)+
        geom_jitter(aes(sub1,sub2, colour = as.factor(region_id)))+
        facet_wrap(~dimension, scales="free")+
        xlab(paste(sub1,"score"))+
        ylab(paste(sub2,"score"))+
        guides(colour = guide_legend(title = "BHI region"),
               legend.key.size=1,
               override.aes = list(size=1))+
        theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                         hjust=.5, vjust=.5, face = "plain"),
              axis.text.y = element_text(size =8),
              legend.text = element_text(size=6),
              legend.key.size = unit(.25, "cm"))+
        ggtitle(paste(goal_name , "subgoal comparision (points jittered)"))


      return(p2)

    }## end subgoals
  ##--------------------------------------------------##
  ## 3 subgoals
  if(count_goals ==3 ){

    ## filter score data for subgoals and goals
    scores_sub= scores %>% filter(goal %in% subgoal_abb)
    scores_goal = scores %>% filter(goal == goal_name )

    ## combine score data
    scores_plot = bind_rows(scores_sub,scores_goal) %>%
                  filter(region_id !=0)

    ## get subgoal names
    sub1 = subgoal_abb[1]
    sub2 = subgoal_abb[2]
    sub3 = subgoal_abb[3]

    ##--------------------------------------------------##
    ## plot comparison scores

    ## rename subgoals to generic names and spread data
    scores_spread = scores_plot %>%
                    mutate(goal= ifelse(goal == sub1,"sub1",
                                 ifelse(goal == sub2, "sub2",
                                 ifelse(goal == sub3, "sub3",
                                 ifelse(goal == goal_name,"goal",""))))) %>%
                    spread(goal,score)

     ## plot subgoal 1 (x-axis)  and subgoal 2 (y-axis) and subgoal3 (size).This is a problem if NA does not plot)
    p2=ggplot(scores_spread)+
      geom_jitter(aes(sub1,sub2, size= sub3, colour = as.factor(region_id)))+
      facet_wrap(~dimension, scales="free")+
      xlab(paste(sub1,"score"))+
      ylab(paste(sub2,"score"))+
      guides(colour = guide_legend(title = "BHI region",
                                   legend.key.size=1,
                                   override.aes = list(size=1)),
             size = guide_legend(title = sub3))+
      theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                       hjust=.5, vjust=.5, face = "plain"),
            axis.text.y = element_text(size =8),
            legend.text = element_text(size=6),
            legend.key.size = unit(.25, "cm"))+
      ggtitle(paste(goal_name , "subgoal comparision (points jittered)"))

    return(p2)

  } ## end three subgoals

}## end function




##---------------------------------------##
## FUNCTION: plotPressuresResilience
##plot the values of the pressure and resilience data layers by BHI region

plotPressuresResilience = function(type){
  ## type = "pressures" or "resilience"

  if(type == "pressures"){


    ## read in pressure layers (some maybe proxy files)
    cc_sal_surf      =read.csv(file.path(dir_layers,'cc_sal_surf_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sal_surf"      )%>% arrange(rgn_id)
    cc_sal_deep      =read.csv(file.path(dir_layers,'cc_sal_deep_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sal_deep"      )%>% arrange(rgn_id)
    cc_sst           =read.csv(file.path(dir_layers,'cc_sst_bhi2015.csv'           ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sst"           )%>% arrange(rgn_id)
    po_nload         =read.csv(file.path(dir_layers,'po_nload_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_nload"         )%>% arrange(rgn_id)
    ss_wgi           =read.csv(file.path(dir_layers,'ss_wgi_bhi2015.csv'           ),stringsAsFactors =FALSE )  %>% mutate( pressure = "ss_wgi"           )%>% arrange(rgn_id)
    po_atmos_pcb153  =read.csv(file.path(dir_layers,'po_atmos_pcb153_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_atmos_pcb153"  )%>% arrange(rgn_id)
    po_atmos_pcddf   =read.csv(file.path(dir_layers,'po_atmos_pcddf_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_atmos_pcddf"   )%>% arrange(rgn_id)
    po_pload         =read.csv(file.path(dir_layers,'po_pload_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_pload"         )%>% arrange(rgn_id)
    hab_anoxia       =read.csv(file.path(dir_layers,'hab_anoxia_bhi2015.csv'       ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_anoxia"       )%>% arrange(rgn_id)
    hab_illegal_oil  =read.csv(file.path(dir_layers,'hab_illegal_oil_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_illegal_oil"  )%>% arrange(rgn_id)
    hab_coastal_pop  =read.csv(file.path(dir_layers,'hab_coastal_pop_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_coastal_pop"  )%>% arrange(rgn_id)
    hab_bottom_trawl =read.csv(file.path(dir_layers,'hab_bottom_trawl_bhi2015.csv' ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_bottom_trawl" )%>% arrange(rgn_id)
    fp_over_harvest  =read.csv(file.path(dir_layers,'fp_over_harvest_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "fp_over_harvest"  )%>% arrange(rgn_id)
    sp_invasives     =read.csv(file.path(dir_layers,'sp_invasives_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( pressure = "sp_invasives"     )%>% arrange(rgn_id)
    po_inverse_secchi=read.csv(file.path(dir_layers,'po_inverse_secchi_bhi2015.csv'),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_inverse_secchi")%>% arrange(rgn_id)
    po_trash         =read.csv(file.path(dir_layers,'po_trash_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_trash"         )%>% dplyr::rename(pressure_score =score) %>%arrange(rgn_id)

    ##
    pressure_plot = bind_rows(cc_sal_surf      ,
                              cc_sal_deep      ,
                              cc_sst           ,
                              po_nload         ,
                              ss_wgi           ,
                              po_atmos_pcb153  ,
                              po_atmos_pcddf   ,
                              po_pload         ,
                              hab_anoxia       ,
                              hab_illegal_oil  ,
                              hab_coastal_pop  ,
                              hab_bottom_trawl ,
                              fp_over_harvest  ,
                              sp_invasives     ,
                              po_inverse_secchi,
                              po_trash         )

    ## plot
    p1 = ggplot(pressure_plot)+
      geom_point(aes(rgn_id,pressure_score),size=1)+
      facet_wrap(~pressure)+
      ylim(0,1)+
      ylab("Score")+
      xlab("BHI region")+
      ggtitle(paste(type, " Score"))

    return(p1)

  }## end pressures


  if(type == "resilience"){


    ## read in resilience layers (some maybe proxy files)
    res_reg_birds   =read.csv(file.path(dir_layers,'res_reg_birds_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_birds"   )%>% arrange(rgn_id)
    res_reg_bsap    =read.csv(file.path(dir_layers,'res_reg_bsap_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_bsap"     )%>% arrange(rgn_id)
    res_reg_bwd     =read.csv(file.path(dir_layers,'res_reg_bwd_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_bwd"     )%>% arrange(rgn_id)
    res_reg_cbd     =read.csv(file.path(dir_layers,'res_reg_cbd_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cbd"     )%>% arrange(rgn_id)
    res_reg_cfp     =read.csv(file.path(dir_layers,'res_reg_cfp_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cfp"     )%>% arrange(rgn_id)
    res_reg_cites   =read.csv(file.path(dir_layers,'res_reg_cites_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cites"   )%>% arrange(rgn_id)
    res_reg_cop21   =read.csv(file.path(dir_layers,'res_reg_cop21_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cop21"   )%>% arrange(rgn_id)
    res_reg_hd      =read.csv(file.path(dir_layers,'res_reg_hd_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_hd"      )%>% arrange(rgn_id)
    res_reg_helcom  =read.csv(file.path(dir_layers,'res_reg_helcom_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_helcom"  )%>% arrange(rgn_id)
    res_reg_ied     =read.csv(file.path(dir_layers,'res_reg_ied_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_ied"      )%>% arrange(rgn_id)
    res_reg_msfd    =read.csv(file.path(dir_layers,'res_reg_msfd_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_msfd"    )%>% arrange(rgn_id)
    res_reg_mspd    =read.csv(file.path(dir_layers,'res_reg_mspd_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_mspd"    )%>% arrange(rgn_id)
    res_reg_nd      =read.csv(file.path(dir_layers,'res_reg_nd_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_nd"      )%>% arrange(rgn_id)
    res_reg_nec     =read.csv(file.path(dir_layers,'res_reg_nec_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_nec"     )%>% arrange(rgn_id)
    res_reg_pop     =read.csv(file.path(dir_layers,'res_reg_pop_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_pop"     )%>% arrange(rgn_id)
    res_reg_reach   =read.csv(file.path(dir_layers,'res_reg_reach_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_reach"   )%>% arrange(rgn_id)
    res_reg_uwwtd    =read.csv(file.path(dir_layers,'res_reg_uwwtd_bhi2015.csv'   ),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_reg_uwwtd"    )%>% arrange(rgn_id)
    res_reg_wfd      =read.csv(file.path(dir_layers,'res_reg_wfd_bhi2015.csv'     ),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_reg_wfd"      )%>% arrange(rgn_id)
    wgi_all          =read.csv(file.path(dir_layers,'wgi_all_bhi2015.csv'         ),stringsAsFactors =FALSE ) %>% mutate(resilience ="wgi_all"          )%>% arrange(rgn_id)
    res_biodiversity =read.csv(file.path(dir_layers,'res_biodiversity_bhi2015.csv'),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_biodiversity" )%>% arrange(rgn_id)
    ##
    resilience_plot = bind_rows(res_reg_birds  ,
                                res_reg_bsap   ,
                                res_reg_bwd    ,
                                res_reg_cbd    ,
                                res_reg_cfp    ,
                                res_reg_cites  ,
                                res_reg_cop21  ,
                                res_reg_hd     ,
                                res_reg_helcom ,
                                res_reg_ied    ,
                                res_reg_msfd   ,
                                res_reg_mspd   ,
                                res_reg_nd     ,
                                res_reg_nec    ,
                                res_reg_pop    ,
                                res_reg_reach  ,
                                res_reg_uwwtd  ,
                                res_reg_wfd    ,
                                wgi_all        ,
                                res_biodiversity)


    ## plot
    p1 = ggplot(resilience_plot)+
      geom_point(aes(rgn_id,resilience_score),size=1)+
      facet_wrap(~resilience)+
      ylim(0,1)+
      ylab("Score")+
      xlab("BHI region")+
      ggtitle(paste(type, " Score"))


    return(p1)

}# end resilience

}## end function


##---------------------------------------##
## FUNCTION: plotPressuresResilienceGoal
##plot goal specific pressure and resilience measures

##

plotPressuresResilienceGoal = function(type, goal_select){

  if(type == "pressures"){


    ## read in pressure layers (some maybe proxy files)
    cc_sal_surf      =read.csv(file.path(dir_layers,'cc_sal_surf_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sal_surf"      )%>% arrange(rgn_id)
    cc_sal_deep      =read.csv(file.path(dir_layers,'cc_sal_deep_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sal_deep"      )%>% arrange(rgn_id)
    cc_sst           =read.csv(file.path(dir_layers,'cc_sst_bhi2015.csv'           ),stringsAsFactors =FALSE )  %>% mutate( pressure = "cc_sst"           )%>% arrange(rgn_id)
    po_nload         =read.csv(file.path(dir_layers,'po_nload_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_nload"         )%>% arrange(rgn_id)
    ss_wgi           =read.csv(file.path(dir_layers,'ss_wgi_bhi2015.csv'           ),stringsAsFactors =FALSE )  %>% mutate( pressure = "ss_wgi"           )%>% arrange(rgn_id)
    po_atmos_pcb153  =read.csv(file.path(dir_layers,'po_atmos_pcb153_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_atmos_pcb153"  )%>% arrange(rgn_id)
    po_atmos_pcddf   =read.csv(file.path(dir_layers,'po_atmos_pcddf_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_atmos_pcddf"   )%>% arrange(rgn_id)
    po_pload         =read.csv(file.path(dir_layers,'po_pload_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_pload"         )%>% arrange(rgn_id)
    hab_anoxia       =read.csv(file.path(dir_layers,'hab_anoxia_bhi2015.csv'       ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_anoxia"       )%>% arrange(rgn_id)
    hab_illegal_oil  =read.csv(file.path(dir_layers,'hab_illegal_oil_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_illegal_oil"  )%>% arrange(rgn_id)
    hab_coastal_pop  =read.csv(file.path(dir_layers,'hab_coastal_pop_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_coastal_pop"  )%>% arrange(rgn_id)
    hab_bottom_trawl =read.csv(file.path(dir_layers,'hab_bottom_trawl_bhi2015.csv' ),stringsAsFactors =FALSE )  %>% mutate( pressure = "hab_bottom_trawl" )%>% arrange(rgn_id)
    fp_over_harvest  =read.csv(file.path(dir_layers,'fp_over_harvest_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( pressure = "fp_over_harvest"  )%>% arrange(rgn_id)
    sp_invasives     =read.csv(file.path(dir_layers,'sp_invasives_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( pressure = "sp_invasives"     )%>% arrange(rgn_id)
    po_inverse_secchi=read.csv(file.path(dir_layers,'po_inverse_secchi_bhi2015.csv'),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_inverse_secchi")%>% arrange(rgn_id)
    po_trash         =read.csv(file.path(dir_layers,'po_trash_bhi2015.csv'         ),stringsAsFactors =FALSE )  %>% mutate( pressure = "po_trash"         )%>% dplyr::rename(pressure_score =score) %>%arrange(rgn_id)

    ##read in pressure matrix
    pressure_matrix = read.csv(file.path(dir_baltic,'conf/pressures_matrix.csv'), stringsAsFactors = FALSE)


    ##
    pressure_plot = bind_rows(cc_sal_surf      ,
                              cc_sal_deep      ,
                              cc_sst           ,
                              po_nload         ,
                              ss_wgi           ,
                              po_atmos_pcb153  ,
                              po_atmos_pcddf   ,
                              po_pload         ,
                              hab_anoxia       ,
                              hab_illegal_oil  ,
                              hab_coastal_pop  ,
                              hab_bottom_trawl ,
                              fp_over_harvest  ,
                              sp_invasives     ,
                              po_inverse_secchi,
                              po_trash         )



    ##
    pressure_goal = pressure_matrix %>%
                    filter(goal == goal_select) %>%
                    gather(pressure, weight, -goal)%>%
                    filter(!is.na(weight))



    pressure_join = inner_join(pressure_goal, pressure_plot,
                               by="pressure")



    ## plot
    p1 = ggplot(pressure_join)+
      geom_point(aes(rgn_id,pressure_score, size=weight,colour=pressure))+
      scale_size(range = c(0, 3),breaks=c(1, 2,3))+
      ylim(0,1)+
      ylab("Score")+
      xlab("BHI region")+
      ggtitle(paste(goal_select, type, "scores and weights"))

  return(p1)

}## end pressures




  if(type == "resilience"){


    ## read in resilience layers (some maybe proxy files)
    res_reg_birds   =read.csv(file.path(dir_layers,'res_reg_birds_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_birds"   )%>% arrange(rgn_id)
    res_reg_bsap    =read.csv(file.path(dir_layers,'res_reg_bsap_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_bsap"     )%>% arrange(rgn_id)
    res_reg_bwd     =read.csv(file.path(dir_layers,'res_reg_bwd_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_bwd"     )%>% arrange(rgn_id)
    res_reg_cbd     =read.csv(file.path(dir_layers,'res_reg_cbd_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cbd"     )%>% arrange(rgn_id)
    res_reg_cfp     =read.csv(file.path(dir_layers,'res_reg_cfp_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cfp"     )%>% arrange(rgn_id)
    res_reg_cites   =read.csv(file.path(dir_layers,'res_reg_cites_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cites"   )%>% arrange(rgn_id)
    res_reg_cop21   =read.csv(file.path(dir_layers,'res_reg_cop21_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_cop21"   )%>% arrange(rgn_id)
    res_reg_hd      =read.csv(file.path(dir_layers,'res_reg_hd_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_hd"      )%>% arrange(rgn_id)
    res_reg_helcom  =read.csv(file.path(dir_layers,'res_reg_helcom_bhi2015.csv'  ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_helcom"  )%>% arrange(rgn_id)
    res_reg_ied     =read.csv(file.path(dir_layers,'res_reg_ied_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_ied"      )%>% arrange(rgn_id)
    res_reg_msfd    =read.csv(file.path(dir_layers,'res_reg_msfd_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_msfd"    )%>% arrange(rgn_id)
    res_reg_mspd    =read.csv(file.path(dir_layers,'res_reg_mspd_bhi2015.csv'    ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_mspd"    )%>% arrange(rgn_id)
    res_reg_nd      =read.csv(file.path(dir_layers,'res_reg_nd_bhi2015.csv'      ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_nd"      )%>% arrange(rgn_id)
    res_reg_nec     =read.csv(file.path(dir_layers,'res_reg_nec_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_nec"     )%>% arrange(rgn_id)
    res_reg_pop     =read.csv(file.path(dir_layers,'res_reg_pop_bhi2015.csv'     ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_pop"     )%>% arrange(rgn_id)
    res_reg_reach   =read.csv(file.path(dir_layers,'res_reg_reach_bhi2015.csv'   ),stringsAsFactors =FALSE )  %>% mutate( resilience = "res_reg_reach"   )%>% arrange(rgn_id)
    res_reg_uwwtd    =read.csv(file.path(dir_layers,'res_reg_uwwtd_bhi2015.csv'   ),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_reg_uwwtd"    )%>% arrange(rgn_id)
    res_reg_wfd      =read.csv(file.path(dir_layers,'res_reg_wfd_bhi2015.csv'     ),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_reg_wfd"      )%>% arrange(rgn_id)
    wgi_all          =read.csv(file.path(dir_layers,'wgi_all_bhi2015.csv'         ),stringsAsFactors =FALSE ) %>% mutate(resilience ="wgi_all"          )%>% arrange(rgn_id)
    res_biodiversity =read.csv(file.path(dir_layers,'res_biodiversity_bhi2015.csv'),stringsAsFactors =FALSE ) %>% mutate(resilience ="res_biodiversity" )%>% arrange(rgn_id)
    ##
    resilience_plot = bind_rows(res_reg_birds  ,
                                res_reg_bsap   ,
                                res_reg_bwd    ,
                                res_reg_cbd    ,
                                res_reg_cfp    ,
                                res_reg_cites  ,
                                res_reg_cop21  ,
                                res_reg_hd     ,
                                res_reg_helcom ,
                                res_reg_ied    ,
                                res_reg_msfd   ,
                                res_reg_mspd   ,
                                res_reg_nd     ,
                                res_reg_nec    ,
                                res_reg_pop    ,
                                res_reg_reach  ,
                                res_reg_uwwtd  ,
                                res_reg_wfd    ,
                                wgi_all        ,
                                res_biodiversity)


    ##read in resilience matrix and categories

    resilience_matrix =  read.csv(file.path(dir_baltic,'conf/resilience_matrix.csv'), stringsAsFactors = FALSE)

    resilience_weight = read.csv(file.path(dir_baltic,'conf/resilience_categories.csv'), stringsAsFactors = FALSE)%>%
                        select(layer, weight)%>%
                        dplyr::rename(resilience=layer)



    ##
    resilience_goal =resilience_matrix %>%
                    filter(goal == goal_select) %>%
                    gather(resilience, select, -goal)%>%
                    mutate(select = ifelse(select =="x",1, NA),
                           select = as.numeric(select))%>%
                    filter(!is.na(select))%>%
                    select(-select)%>%
                    inner_join(.,resilience_weight,
                               by="resilience")



    resilience_join = inner_join(resilience_goal, resilience_plot,
                               by="resilience")



    ## plot
    p1 = ggplot(resilience_join)+
      geom_point(aes(rgn_id,resilience_score, size=weight,colour=resilience))+
      scale_size(range = c(0, 3),breaks=c(1, 2,3))+
      ylim(0,1)+
      ylab("Score")+
      xlab("BHI region")+
      ggtitle(paste(goal_select, type, "scores and weights"))

    return(p1)


  }##end resilience
}#end function
