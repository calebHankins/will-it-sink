will_it_sink <- function  (
                            sample_file_path = "./data/zip_codes_states.csv", 
                            out_file_path = "./data/will_it_sink_out.csv", 
                            shape_file_path = "./data/TM_WORLD_BORDERS-0.2.shp"
                          ) 
{
  

  #make sure the requires packages are installed
  checkPkgs <- function() {
    pkg.inst <- installed.packages()
    pkgs <- c("maptools", "sp")
    have.pkg <- pkgs %in% rownames(pkg.inst)
    
    if(any(!have.pkg)) {
      cat("Some packages need to be installed\n")
      r <- readline("Install necessary packages [y/n]? ")
      if(tolower(r) == "y") {
        need <- pkgs[!have.pkg]
        message("installing packages ",
                paste(need, collapse = ", "))
        install.packages(need)
      }
      else stop("Missing required packages and user requested to not install them")
    }
  }
  
  checkPkgs()
  
  #now that we know that we have our packages, load them
  library(maptools)
  library(sp)
  
  #attempt to load up the shapefile into R
  #todo feed this from argument
  #shape_file_path <- "./data/TM_WORLD_BORDERS-0.2.shp"
  #sample_file_path <- "./data/zip_codes_states.csv"
  #out_file_path <- "./data/will_it_sink_out.csv"
  
  #read shape file into a spatial data frame
  spatial_df <- readShapeSpatial(shape_file_path, repair=FALSE)
  
  #read in sample data file to check against
  # format zip_code  latitude	longitude	city	state	county
  sample_data <- read.csv(sample_file_path)
  
  sample_df_coords <- subset(x=sample_data,select=c(longitude,latitude), subset=complete.cases(sample_data)) # df with only complete observations. #todo figure out a better way to deal with missing data
  coordinates(sample_df_coords) <- ~longitude+latitude
  sample_sp_coords <-  SpatialPoints(coords=sample_df_coords) #Error in .checkNumericCoerce2double(obj) : non-finite coordinates, had to remove NAs from the data set
  results <- subset(x=over(x=sample_sp_coords,y=spatial_df ), select=LAT )  # this part actually consumes a lil bit of time, research improving todo
  
  
  ##return the read in csv file with a flag appended "will_it_sink"
  # append the flag to the input dataframe using the results list
  sample_df_coords$will_it_sink <- apply(results,1, function(x) {  if (is.na(x)) {    1  }  else {    0  }} )
  
  #write an output file
  write.csv(sample_df_coords, file = out_file_path, row.names=FALSE)
  
} # will_it_sink
  
  
  ## Spare parts and notes 
  #TODO, 
  # VALIDATE RESULTS
  
  #41404/42049
  # 0.9846608
  #98.46% accuaracy? Research failure cases to se why they were marked as water
  # looks like some of the points flagged as water actually are in the water
  

