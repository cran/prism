## ----echo = FALSE-------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = Sys.getenv("PRISM_AUTHOR") == "true"
)

# knitr hook to truncate long output. See:
# https://stackoverflow.com/q/23114654/3362993
hook_output <- knitr::knit_hooks$get("output")
knitr::knit_hooks$set(output = function(x, options) {
  if (!is.null(n <- options$out.lines)) {
    x <- unlist(strsplit(x, "\n"))
    if (length(x) > n) {
      # truncate the output
      x <- c(head(x, n), "....\n")
    }
    x <- paste(x, collapse = "\n")
  }
  hook_output(x, options)
})

## ----eval=FALSE---------------------------------------------------------------
# install.packages("prism")

## ----start, eval=FALSE--------------------------------------------------------
# # install.packages("devtools")
# library(devtools)
# install_github("ropensci/prism")

## ----prism setup--------------------------------------------------------------
# library(prism)
# prism_set_dl_dir("~/prismtmp")

## ----get normals,results=FALSE, eval=FALSE------------------------------------
# # Download the January - June 30-year averages at 4km resolution
# get_prism_normals(type="tmean", resolution = "4km", mon = 1:6, keepZip = FALSE)
# 
# # Download the 30-year annual average precip and annual average temperature
# get_prism_normals("ppt", "4km", annual = TRUE, keepZip = FALSE)
# get_prism_normals("tmean", "4km", annual = TRUE, keepZip = FALSE)

## ----get daily monthly, message=FALSE, results=FALSE, eval=FALSE--------------
# get_prism_dailys(
#   type = "tmean",
#   minDate = "2013-06-01",
#   maxDate = "2013-06-14",
#   keepZip = FALSE
# )
# get_prism_monthlys(type = "tmean", year = 1982:2014, mon = 1, keepZip = FALSE)
# get_prism_annual("ppt", years = 2000:2015, keepZip = FALSE)

## ----listingFiles, out.lines=10-----------------------------------------------
# ## Truncated to keep file list short
# prism_archive_ls()

## ----moreListing, out.lines=5-------------------------------------------------
# ## Truncated to keep file list short
# pd_to_file(prism_archive_ls())
# 
# pd_get_name(prism_archive_ls())

## -----------------------------------------------------------------------------
# # we know we have downloaded June 2013 daily data, so lets search for those
# prism_archive_subset("tmean", "daily", mon = 6, resolution = "4km")
# 
# # or we can look for days between June 7 and June 10
# prism_archive_subset(
#   "tmean", "daily", minDate = "2013-06-07", maxDate = "2013-06-10", resolution = "4km"
# )

## ----quick_plot,fig.height=5,fig.width=7--------------------------------------
# # Plot the precipitation in 2000
# 
# ppt2002 <- prism_archive_subset(
#   "ppt", "annual", year = 2002, resolution = "4km"
# )
# pd_image(ppt2002)

## ----raster_math,fig.height=5,fig.width=7-------------------------------------
# library(raster)
# # knowing the name of the files you are after allows you to find them in the
# # list of all files that exist
# # ppt2002 <- "prism_ppt_us_25m_2002"
# # ppt2011 <- "prism_ppt_us_25m_2011"
# # but we will use prism_archive_subset() to find the files we need
# 
# ppt2002_name <- prism_archive_subset(
#   "ppt", "annual", year = 2002, resolution = "4km"
# )
# ppt2011_name <- prism_archive_subset(
#   "ppt", "annual", year = 2011, resolution = "4km"
# )
# 
# # raster needs a full path, not the "short" prism data name
# ppt2002 <- pd_to_file(ppt2002_name)
# ppt2011 <- pd_to_file(ppt2011_name)
# 
# ## Now we'll load the rasters.
# ppt2002_rast <- raster(ppt2002)
# ppt2011_rast <- raster(ppt2011)
# 
# # Now we can do simple subtraction to get the anomaly by subtracting 2014
# # from the 30 year normal map
# diff_calc <- function(x, y) {
#   return(x - y)
# }
# 
# anom_rast <- raster::overlay(ppt2002_rast, ppt2011_rast, fun = diff_calc)
# 
# plot(anom_rast)

## ----plot_Boulder,fig.height=5,fig.width=7, results=FALSE---------------------
# library(ggplot2)
# # data already exist in the prism dl dir
# boulder <- c(-105.2797, 40.0176)
# 
# # prism_archive_subset() will return prism data that matches the specified
# # variable, time step, years, months, days, etc.
# to_slice <- prism_archive_subset("tmean", "monthly", mon = 1, resolution = "4km")
# p <- pd_plot_slice(to_slice, boulder)
# 
# # add a linear average and title
# p +
#   stat_smooth(method="lm", se = FALSE) +
#   theme_bw() +
#   ggtitle("Average January temperature in Boulder, CO 1982-2014")

## ----leaflet,eval=F-----------------------------------------------------------
# library(leaflet)
# library(raster)
# library(prism)
# 
# # January 2002 average temperature has already been downloaded
# norm <- prism_archive_subset(
#   "tmean", "monthly", mon = 1, year = 2002, resolution = "4km"
# )
# rast <- raster(pd_to_file(norm))
# 
# # Create color palette and plot
# pal <- colorNumeric(
#   c("#0000FF", "#FFFF00", "#FF0000"),
#   values(rast),
#   na.color = "transparent"
# )
# 
# leaflet() %>%
#   addTiles(
#     urlTemplate = 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
#   ) %>%
#   addRasterImage(rast, colors = pal, opacity=.65) %>%
#   addLegend(pal = pal, values = values(rast), title = "Deg C")

