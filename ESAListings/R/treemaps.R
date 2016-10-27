tm_t <- list()
for(i in unique(regions$Lead_Region)){
  ls1 <- list(name = i, id = i, value = sum(filter(regions, Lead_Region == i)$count), color = NA)
  tm_t[[length(tm_t)+1]] <- ls1

 for(j in unique(filter(regions, Lead_Region==i)$Group)){
   ls2 <- list(name = j, value = sum(filter(regions, Lead_Region == i, Group == j)$count), id =paste(i, j, sep = "_"), parent = i, color = NA )
   tm_t[[length(tm_t)+1]] <- ls2

  for(z in unique(filter(regions, Lead_Region == i, Group == j)$Status)){
    ls3 <- list(parent = paste(i, j, sep = "_"), name = z, value = filter(regions, Lead_Region == i, Group == j, Status == z)$count, color = stat_pal(strsplit(z," ")[[1]][1]))
    tm_t[[length(tm_t)+1]] <- ls3
  }
 }
}

highchart()%>%
  hc_add_series(data = tm_t, type = "treemap", layoutAlgorithm = "squarified", allowDrillToNode = TRUE,
                dataLabels = list(enabled = FALSE),
                levelIsConstant = FALSE,
                levels = list(list(level = 1,
                                   borderColor = "white",
                                   borderWidth = 5,
                                   dataLabels = list(enabled = "true", verticalAlign = "top", align = "left", style = list(fontSize = "12pt"))),
                              list(level = 2,
                                   borderColor = "grey",
                                   borderWidth = 3,
                                   dataLabels = list(enabled = FALSE))
                              #list(level = 3,
                                   #dataLabels = list(enabled = FALSE))
                                   )
  )

maketree <- function(df, levels, value){
tm_rg <- list()

for(i in unique(dat1$Lead_Region)){
  ls1 <- list(name = i, id = i, color = NA)
  tm_rg[[length(tm_rg)+1]] <- ls1
}
for(i in 1:length(df$levels[2])){
  ls2 <- list(parent = dat1$Lead_Region[i], name = dat1$Status[i], value = dat1$count[i], color = stat_pal(strsplit(dat1$Status[i]," ")[[1]][1]))
  tm_rg[[length(tm_rg)+1]] <- ls2
}
}
str(dat)

stat_pal <- function(status){switch(status, Candidate = "yellow", Endangered = "red", Proposed = "green", Threatened = "orange", Experimental = "black", Similarity = "purple")}
