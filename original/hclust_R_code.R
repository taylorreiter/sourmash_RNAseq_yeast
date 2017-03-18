# Plot 
    # Heirarchical clustering analysis
    # calculate correlation
    cor_all<-lapply(all_in, cor)
    # cor_all_spearman <- cor(all_in[[1]], method="spearman")
          # Method options: pearson, kendall, spearman. Default pearson.
    # calculate hierarchical cluster
    norm_cor_all<-lapply(cor_all, function(x) {(1-x)})
    dist_cor_all<-lapply(norm_cor_all, function(x) {dist(x)})
    hc_all<-lapply(dist_cor_all, function(x) {hclust(x, method="average")})
    # hc_all<-hclust(dist(1-cor_all_spearman), method="average")
    # Method: complete, average, single, mcquitty, median, centroid, ward.D, ward.D2
    # change labels to only ERR number
              for(i in 1:length(hc_all)) {
              truncate_label_regex<-"(ERR[0-9]{4,8})"
              library(stringr)
              labels_hc<-str_extract(hc_all[[i]]$labels, truncate_label_regex)
              print(labels_hc)
              hc_all[[i]]$labels<-labels_hc}
    # Plot!
    # pick a pretty color for SNF2 and for WT
    color_by_type<-function(names) {
          library(stringr)
          # detect if WT is present in the name
          magenta <-"(ERR458[0-9]{1,6})"
          is_MUT<-str_detect(names, magenta)
          # detect if SNF2 is present in the name
          cyan <-"(ERR459[0-9]{1,6})"
          is_WT<-str_detect(names, cyan)
          # if WT is detected, black, else blue
          ifelse(is_WT==F, "magenta", "cyan")
    }
    
    library(ape)
    par(mfrow=c(1,4)) 
    # Make the plot!
    plots_all<-sapply(hc_all, function(x) {plot.phylo(as.phylo(x), type="fan", no.margin=TRUE, font = 1, cex = 1, tip.color = color_by_type(x$labels))})
    