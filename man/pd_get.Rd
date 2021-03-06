% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pd_get.R
\name{pd_get_name}
\alias{pd_get_name}
\alias{pd_get_date}
\alias{pd_get_type}
\alias{prism_md}
\alias{pd_to_file}
\title{Perform action on "prism data"}
\usage{
pd_get_name(pd)

pd_get_date(pd)

pd_get_type(pd)

prism_md(f, returnDate = FALSE)

pd_to_file(pd)
}
\arguments{
\item{pd}{prism data character vector.}

\item{f}{1 or more prism directories name or .bil files.}

\item{returnDate}{TRUE or FALSE. If TRUE, an ISO date is returned.  By
default years will come back with YYYY-01-01 and months as YYYY-MM-01}
}
\value{
\code{pd_get_name()} and \code{pd_get_date()} return a character vector of
names/dates.
}
\description{
"prism data", i.e., \code{pd} are the folder names returned by
\code{\link[=prism_archive_ls]{prism_archive_ls()}} or \code{\link[=prism_archive_subset]{prism_archive_subset()}}. These functions get the
name or date from these data, or convert these data to a file name.

\code{pd_get_date()} extracts the date from the prism data.
Date is returned in yyyy-mm-dd format. For monthly data, dd is 01 and
for annual data mm is also 01. For normals, an empty character is returned.

\code{pd_get_type()} parses the variable from the prism data.

\code{prism_md()} is a deprecated function that has been replaced with
\code{pd_get_name()} and \code{pd_get_date()}

\code{pd_to_file()} converts prism data  to a fully specified .bil file, i.e., the
full path to the file in the prism archive. A warning is posted if the
file does not exist in the local prism archive.
}
\details{
\code{pd_get_name()} extracts a long, human readable name from the prism
data.
}
