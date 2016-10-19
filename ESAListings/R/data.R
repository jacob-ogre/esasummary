#' Data.frame of base information for domestic ECOS species
#'
#' The data is the table is the \link{TECP} data filtered for domestic species.
#'
#' @format A data frame with 1835 rows and 10 variables
#' \itemize{
#'   \item{Scientific_Name}{The scientific name, as recorded in ECOS}
#'   \item{Common_Name}{The common name, as recorded in ECOS}
#'   \item{Species_Code}{The four-character code assigned to species in ECOS}
#'   \item{Critical_Habitat}{CFR section under which CH was declared}
#'   \item{Species_Group}{Taxonomic group of species, as recorded in ECOS}
#'   \item{Lead_Region}{FWS region responsible for recovery}
#'   \item{Federal_Listing_Status}{At time of scraping}
#'   \item{Special_Rules}{CFR section under which any special rules were made}
#'   \item{Where_Listed}{Geographic extent of listed entity}
#'   \item{Species_Page}{URL dedicated to the species on ECOS}
#' }
#' @source \link{http://ecos.fws.gov/tess_public}
"TECP_domestic"

#' Data.frame identical to \link{TECP_domestic} with date of first listing added
#'
#' The data is the table is the \link{TECP} data filtered for domestic species. Using
#' the \code{get_tecp_table} function from the 'ecosscraper' package.  Created from
#' scrape run 10-12-16.
#'
#' @format A data frame with 1835 rows and 10 variables
#' \itemize{
#'   \item{Scientific_Name}{The scientific name, as recorded in ECOS}
#'   \item{Common_Name}{The common name, as recorded in ECOS}
#'   \item{Species_Code}{The four-character code assigned to species in ECOS}
#'   \item{Critical_Habitat}{CFR section under which CH was declared}
#'   \item{Species_Group}{Taxonomic group of species, as recorded in ECOS}
#'   \item{Lead_Region}{FWS region responsible for recovery}
#'   \item{Federal_Listing_Status}{At time of scraping}
#'   \item{Special_Rules}{CFR section under which any special rules were made}
#'   \item{Where_Listed}{Geographic extent of listed entity}
#'   \item{Species_Page}{URL dedicated to the species on ECOS}
#' }
#' @source \link{http://ecos.fws.gov/tess_public}
"TECP_date"

#'TopoJSON file displaying georeferenced boundaries of U.S. Counties.
#'
#'Description
#'
#'@format A TopoJSON characer vector
#'@source \url{}
"county_topo"

#' County-level occurrence of ESA-listed species
#'
#' The most-refined occurrence data available from the Fish and Wildlife Service
#' (FWS) for most species listed under the US Endangered Species Act (ESA) is
#' county-level data. This data was scraped from FWS's \href{http://ecos.fws.gov}{ECOS website}
#' and curated (checked, completed) by referencing other sources such as
#' \href{gbif.org}{GBIF} and \href{www.natureserve.org}{NatureServe}.
#'
#' @format A data frame with 24617 rows and 15 variables
#' \describe{
#' \item{\code{Scientific}}{The scientific name of the taxon}
#' \item{\code{Genus}}{The genus of the taxon}
#' \item{\code{Species}}{The specific epithet of the taxon}
#' \item{\code{Subspecies}}{The sub-specific epithet of the taxon}
#' \item{\code{Common}}{The common name of the taxon, if available}
#' \item{\code{Common_group}}{The broad group common name, if available}
#' \item{\code{Common_specific}}{The specific common name, if available}
#' \item{\code{Common_alt}}{An alternate common name, if available}
#' \item{\code{STATEFP}}{The two-digit state FIPS code}
#' \item{\code{COUNTYFP}}{The three-digit county FIPS code}
#' \item{\code{County_name}}{Text name of the county of occurrence}
#' \item{\code{State_abbrev}}{Abbreviation of the State of occurrence}
#' \item{\code{State_name}}{Text name of the State of occurrence}
#' \item{\code{COUNTYNS}}{The 6- to 7-digit county NS code}
#' \item{\code{GEOID}}{The 6- to 7-digit county NS code}
#' }
#' @source Scraped from \href{http://ecos.fws.gov}{FWS's ECOS website}.
"esacounties"
