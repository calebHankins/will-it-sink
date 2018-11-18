###testing loading a shapefile and seeing if an arbitrary gps coord is within its boundries

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
filen <- "./data/TM_WORLD_BORDERS-0.2.shp"


#read shape file into a spatial data frame
spatial_df <- readShapeSpatial(filen, repair=FALSE)

summary(spatial_df$ISO3)
unique(spatial_df$ISO3)

#subset to just US for debugging
us_spatial_df <- subset(spatial_df, subset=spatial_df$ISO3 == "USA"   )

us_spatial_df$ISO3
#[1] USA
#246 Levels: ABW AFG AGO AIA ALA ALB AND ANT ARE ARG ARM ASM ATA ATF ATG AUS AUT AZE BDI BEL BEN BFA BGD BGR BHR BHS BIH BLM BLR BLZ BMU ... ZWE

summary(us_spatial_df)
us_spatial_df

class(us_spatial_df)
#[1] "SpatialPolygonsDataFrame"
#attr(,"package")
#[1] "sp"

#x = "SpatialPoints", y = "SpatialPolygonsDataFrame"
#returns a data.frame of the second argument with row entries corresponding to the first argument
#over(x, y, returnList = FALSE, fn = NULL, ...)

?SpatialPoints

conway_df_coords <- data.frame(x = c(-92.4421231), y = c(35.0886823))
conway_df_coords <- data.frame(LON = c(-92.4421231), LAT = c(35.0886823))
conway_sp_coords <-  SpatialPoints(coords=conway_df_coords)
over(x=conway_sp_coords,y=us_spatial_df )
#FIPS ISO2 ISO3  UN          NAME   AREA   POP2005 REGION SUBREGION     LON    LAT
#1   US   US  USA 840 United States 915896 299846449     19        21 -98.606 39.622

over(x=conway_sp_coords,y=spatial_df )
FIPS ISO2 ISO3  UN          NAME   AREA   POP2005 REGION SUBREGION     LON    LAT
1   US   US  USA 840 United States 915896 299846449     19        21 -98.606 39.622

# test points
empire_state_bld_coords <- c( 40.748379, -73.985565)
st_louis_arch_coords <- c(38.624659, -90.184698)
key_west_coords <- c(24.555840, -81.782712)
conway_coords <-  c(35.0886823, -92.4421231)
caspian_sea_coords <- c(41.935044, 50.668937)
sydney_coords <- c(-33.874233, 151.212739)
nyc_coords <- c( 40.71448, -74.00598) #these points yeild NA, research
yellow_stone_coords <- c(44.4623, -110.6427)
deepwater_spill_coords <- c(28.736723, -88.387169)

#test df

water_df_coords <- data.frame(LON = c(50.668937, -88.387169 ),LAT = c(41.935044,28.736723)        )
water_sp_coords <-  SpatialPoints(coords=water_df_coords)
results <- over(x=water_sp_coords,y=spatial_df )

land_df_coords <- data.frame(LON = c(-73.985565, -90.184698, -81.782712,-92.4421231,151.212739,-74.00598,-110.6427),LAT = c(40.748379,38.624659,24.555840,35.0886823,-33.874233,40.71448,44.4623)        )
land_sp_coords <-  SpatialPoints(coords=land_df_coords)
results <- over(x=land_sp_coords,y=spatial_df )

summary(land_sp_coords)

#correct
point.in.polygon(point.x=st_louis_arch_coords[2], point.y=st_louis_arch_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)
point.in.polygon(point.x=nyc_coords[2], point.y=nyc_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)
point.in.polygon(point.x=deepwater_spill_coords[2], point.y=deepwater_spill_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)
point.in.polygon(point.x=empire_state_bld_coords[2], point.y=empire_state_bld_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)

#incorrect, research
point.in.polygon(point.x=sydney_coords[2], point.y=sydney_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)
point.in.polygon(point.x=conway_coords[2], point.y=conway_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)
point.in.polygon(point.x=yellow_stone_coords[2], point.y=yellow_stone_coords[1], pol.x=us_spatial_df$LON, pol.y=us_spatial_df$LAT, mode.checked=TRUE)

?over

##loaded it up, let's check it out now
class(spatial_df)
  #[1] "SpatialPolygonsDataFrame"
  #attr(,"package")
  #[1] "sp"
summary(spatial_df) # data seems to have been loaded correctly

if (empire_state_bld_coords[1] )
spatial_df$

#let's see what one of these things looks like
head(spatial_df, n=1)

?SpatialPolygonsDataFrame
?"SpatialPolygonsDataFrame-class"
?sp
??rgdal
?over
?coordinates

#do point(s) fall in a given polygon?
?point.in.polygon



plot(spatial_df) #this works :)

#load up gps coords of empire state bld to test
empire_state_bld_coords <- c( 40.748379, -73.985565)
empire_state_bld_coords[1]
empire_state_bld_coords[2]

# gateway arch in st louis
st_louis_arch_coords <- c(38.624659, -90.184698)
st_louis_arch_coords[1]
st_louis_arch_coords[2]
    
key_west_coords <- c(24.555840, -81.782712)
key_west_coords[1]
key_west_coords[2]

#conway
conway_coords <-  c(35.0886823, -92.4421231)
conway_coords[1]
conway_coords[2]


caspian_sea_coords <- c(41.935044, 50.668937)

#sydney
sydney_coords <- c(-33.874233, 151.212739)

#GPS Coordinates Of New York City, New York - Latitude And Longitude Of New York City, New York
nyc_coords <- c( 40.71448, -74.00598)

#GPS Coordinates Of Yellowstone National Park, Wyoming - Latitude And Longitude Of Yellowstone National Park, Wyoming
yellow_stone_coords <- c(44.4623, -110.6427)

# GPS Coordinates Of Deepwater Horizon Oil Spill - Latitude And Longitude Of Deepwater Horizon Oil Spill
deepwater_spill_coords <- c(28.736723, -88.387169)



coordinates(conway_coords) <- c("longitude", "latitude")
proj4string(conway_coords) <- proj4string(us_spatial_df)
test <- as(us_spatial_df, "SpatialPolygons")


inside.park <- !is.na(over(conway_coords, as(us_spatial_df, "SpatialPolygons")))

#convert to something that spatstat can use
y <- as(spatial_df, "SpatialPolygons")
class(y)
#[1] "SpatialPolygons"
#attr(,"package")
#[1] "sp

head(y, n= 1)


#attempt to check within the polygons for a specific point

#correct
point.in.polygon(point.x=st_louis_arch_coords[1], point.y=st_louis_arch_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=nyc_coords[1], point.y=nyc_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=deepwater_spill_coords[1], point.y=deepwater_spill_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)



#incorrect, research
point.in.polygon(point.x=conway_coords[1], point.y=conway_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=empire_state_bld_coords[1], point.y=empire_state_bld_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=yellow_stone_coords[1], point.y=yellow_stone_coords[2], pol.x=spatial_df$LAT, pol.y=spatial_df$LON, mode.checked=TRUE)


## check these cases with just the us data frame
#correct
point.in.polygon(point.x=st_louis_arch_coords[1], point.y=st_louis_arch_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=nyc_coords[1], point.y=nyc_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=deepwater_spill_coords[1], point.y=deepwater_spill_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)



#incorrect, research
point.in.polygon(point.x=conway_coords[1], point.y=conway_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=empire_state_bld_coords[1], point.y=empire_state_bld_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)
point.in.polygon(point.x=yellow_stone_coords[1], point.y=yellow_stone_coords[2], pol.x=us_spatial_df$LAT, pol.y=us_spatial_df$LON, mode.checked=TRUE)

class(us_spatial_df)
    
plot(us_spatial_df)
points(empire_state_bld_coords)
points(st_louis_arch_coords)
points(yellow_stone_coords)

dev.off()
par(bg="blue")
plot(spatial_df, col="green" )
    
points(x=st_louis_arch_coords[2], y=st_louis_arch_coords[1], col="yellow", pch=19) 
points(x=empire_state_bld_coords[2], y=empire_state_bld_coords[1], col="pink", pch=19) 
points(x=key_west_coords[2], y=key_west_coords[1], col="orange", pch=19) 
points(x=yellow_stone_coords[2], y=yellow_stone_coords[1], col="orange", pch=19) 
points(x=deepwater_spill_coords[2], y=deepwater_spill_coords[1], col="black", pch=19)
points(x=sydney_coords[2], y=sydney_coords[1], col="white", pch=20)
points(x=nyc_coords[2], y=nyc_coords[1], col="white", pch=20)

nyc_coords



points( x=19.017598, y=72.855980, col="pink", pch=19) #mumbai, india

print(empire_state_bld_coords[1] * -1)
print(empire_state_bld_coords[1])
    
    
point.in.polygon(1:10,1:10,c(3,5,5,3),c(3,3,5,5))

head(y, n=1)

spatial_df$LAT

cregions <- slot(y, "polygons")
cregions <- lapply(cregions, function(x) { SpatialPolygons(list(x)) })
cwindows <- lapply(cregions, as.owin)

??as.owin

spatial_df

