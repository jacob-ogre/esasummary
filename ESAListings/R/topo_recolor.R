#' change color scales by 'count' value in topoJson
#'
#' @param topo topoJSON character vector with \code{count} attribute
#' @param max maximum value of \code{count} attribute
#' @param function defining color mapping such as \code{leaflet::colorNumeric}
#' @return topoJSON character vector
#' @examples
#'topo_recolor(topo_prac, 300, palfx)
topo_recolor <- function(topo, max, FUN){
 for(i in 1:max){
  str_replace_all(topo,
                  sprintf("\"count\":\\[%s\\],\"style\":\\{\"fillColor\":\\[\"#[:alnum:]*",i),
                  sprintf("\"count\":\\[%s\\],\"style\":\\{\"fillColor\":\\[\"%s",i,FUN(i)))
 }
}
