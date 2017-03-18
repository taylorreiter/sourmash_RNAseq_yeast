# Code to visualize numpy output from sourmash compare
# NB output was saved to csv file from python using the command:
  # numpy.savecsv("L2_numpy.csv", D)
# Labels were saved during some sourmash process...likely sourmash compute, but perhaps sourmash compare

# function to import numpy txt file
numpy_in<-function(row) {
    csv_filename = row[1]
    labels_filename = row[2]
    # read in numpy matrix
    numpy_mat<-read.csv(csv_filename, header= F)
    # import labels
    numpy_labs<-read.delim(labels_filename, header = F)
    # add labels to matrix 
    numpy_obj<-cbind(numpy_labs, numpy_mat)
    numpy_obj <- data.frame(numpy_obj[,-1], row.names=numpy_obj[,1])
    numpy_labs<-as.vector(numpy_labs[,1])
    colnames(numpy_obj) <- numpy_labs
    return(numpy_obj)
} 

# # import lane 2 signature (test the function)
# L2_sourmash_comp<-numpy_in("/Users/taylorreiter/Desktop/Titus_Brown/yeast_syrah/L2/L2_numpy.csv", "/Users/taylorreiter/Desktop/Titus_Brown/yeast_syrah/L2/yeast_syrah_L2.labels.txt")
# # check file integrity
# head(L2_sourmash_comp)

# Read in files from SNF2 BR 13 full run
    setwd("/Users/taylorreiter/Desktop/Titus_Brown/yeast_raw_fastq/SNF2_BR13/sourmash_compare_output/")
    # Read in csv files of comparisons
          # Read  csv file names
          csv_files<-list.files(".","csv$")
          # Read label file names (txt)
          csv_labels<-list.files(".", "txt$")
          
          # subset to remove the file names that are not comparison files
          csv_files<-csv_files[1:90]
          # Remove k = 1000--unidentified error, being ignored right now
          library(stringr)
          regex_eliminate_k1000<-"^((?!.1000.).)*$"  # mimicing 'does not contain' in regex
          csv_files_no_k1000<-str_extract(csv_files, regex_eliminate_k1000)
          csv_files_no_k1000<-csv_files_no_k1000[!is.na(csv_files_no_k1000)]
          #
          csv_labels_no_k1000<-str_extract(csv_labels, regex_eliminate_k1000)
          csv_labels_no_k1000<-csv_labels_no_k1000[!is.na(csv_labels_no_k1000)]
      # bind vectors for input into numpy_in function
          snf2_br13_numpy_in<-cbind(csv_files_no_k1000, csv_labels_no_k1000)
        
    #Import files
          all_snf2_br13<-apply(snf2_br13_numpy_in, 1, numpy_in)  
          # Check format
          head(all_snf2_br13)
          all_snf2_br13[[68]]
      
# Make standard curve plots
          
          similarity<- function(x) {(sum(colMeans(x)))/(length(x))}
          standard_error<-function(sourmash_compare_matrix) {
            x = c(sourmash_compare_matrix[1,1], sourmash_compare_matrix[1,2], sourmash_compare_matrix[1,3], sourmash_compare_matrix[1,4], sourmash_compare_matrix[1,5], sourmash_compare_matrix[1,6], sourmash_compare_matrix[1,7], sourmash_compare_matrix[2,2], sourmash_compare_matrix[2,3], sourmash_compare_matrix[2,4], sourmash_compare_matrix[2,5], sourmash_compare_matrix[2,6], sourmash_compare_matrix[2,7], sourmash_compare_matrix[3,3], sourmash_compare_matrix[3,4], sourmash_compare_matrix[3,5], sourmash_compare_matrix[3,6], sourmash_compare_matrix[3,7], sourmash_compare_matrix[4,4], sourmash_compare_matrix[4,5], sourmash_compare_matrix[4,6], sourmash_compare_matrix[4,7], sourmash_compare_matrix[5,5], sourmash_compare_matrix[5,6], sourmash_compare_matrix[5,7], sourmash_compare_matrix[6,6], sourmash_compare_matrix[6,7], sourmash_compare_matrix[7,7])
          sd(x)/sqrt(length(x))}
          
      
          
      
          
          similarity_snf2_br13<-sapply(all_snf2_br13, similarity)
          standard_err_snf2_br13<-sapply(all_snf2_br13,standard_error)
          
          snf2_br13_sim_stderr<-cbind(csv_files_no_k1000, similarity_snf2_br13, standard_err_snf2_br13)
          # make vector with scale 
          scaled_values<-c(160000, 20000, 240000, 40000, 480000, 500, 5000, 80000)
          typeof(scaled_values)
          
          snf2_br13_sim_stderr<-cbind(snf2_br13_sim_stderr, scaled_values)
          snf2_br13_sim_stderr<-as.data.frame(snf2_br13_sim_stderr)
          
      
          par(mfrow=c(3,3))
          k12<-snf2_br13_sim_stderr[1:8,]
          k12[,2]<-as.numeric(as.character(k12[,2]))
          k12[,3]<-as.numeric(as.character(k12[,3]))
          k12[,4]<-as.numeric(as.character(k12[,4]))
          library(plyr)
          arrange(k12, scaled_values)
          library(ggplot2)
          k12_plot<-ggplot(k12) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k12") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
          
          
          k15<-snf2_br13_sim_stderr[9:16,]
          k15[,2]<-as.numeric(as.character(k15[,2]))
          k15[,3]<-as.numeric(as.character(k15[,3]))
          k15[,4]<-as.numeric(as.character(k15[,4]))
          library(plyr)
          arrange(k15, scaled_values)
          library(ggplot2)
          k15_plot<-ggplot(k15) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k15") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
          
          k18<-snf2_br13_sim_stderr[17:24,]
          k18[,2]<-as.numeric(as.character(k18[,2]))
          k18[,3]<-as.numeric(as.character(k18[,3]))
          k18[,4]<-as.numeric(as.character(k18[,4]))
          library(plyr)
          arrange(k18, scaled_values)
          library(ggplot2)
          k18_plot<-ggplot(k18) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k18") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
          
          k21<-snf2_br13_sim_stderr[25:32,]
          k21[,2]<-as.numeric(as.character(k21[,2]))
          k21[,3]<-as.numeric(as.character(k21[,3]))
          k21[,4]<-as.numeric(as.character(k21[,4]))
          library(plyr)
          arrange(k21, scaled_values)
          library(ggplot2)
          k21_plot<-ggplot(k21) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k21") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
    
          k24<-snf2_br13_sim_stderr[33:40,]
          k24[,2]<-as.numeric(as.character(k24[,2]))
          k24[,3]<-as.numeric(as.character(k24[,3]))
          k24[,4]<-as.numeric(as.character(k24[,4]))
          library(plyr)
          arrange(k24, scaled_values)
          library(ggplot2)
          k24_plot<-ggplot(k24) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k24") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
          
          k27<-snf2_br13_sim_stderr[41:48,]
          k27[,2]<-as.numeric(as.character(k27[,2]))
          k27[,3]<-as.numeric(as.character(k27[,3]))
          k27[,4]<-as.numeric(as.character(k27[,4]))
          library(plyr)
          arrange(k27, scaled_values)
          library(ggplot2)
          k27_plot<-ggplot(k27) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k27") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
         
          k30<-snf2_br13_sim_stderr[49:56,]
          k30[,2]<-as.numeric(as.character(k30[,2]))
          k30[,3]<-as.numeric(as.character(k30[,3]))
          k30[,4]<-as.numeric(as.character(k30[,4]))
          library(plyr)
          arrange(k30, scaled_values)
          library(ggplot2)
          k30_plot<-ggplot(k30) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k30") + ylim(.6,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
        
          k6<-snf2_br13_sim_stderr[57:64,]
          k6[,2]<-as.numeric(as.character(k6[,2]))
          k6[,3]<-as.numeric(as.character(k6[,3]))
          k6[,4]<-as.numeric(as.character(k6[,4]))
          library(plyr)
          arrange(k6, scaled_values)
          library(ggplot2)
          k6_plot<-ggplot(k6) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k6") + ylim(0,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
   
          k9<-snf2_br13_sim_stderr[65:72,]
          k9[,2]<-as.numeric(as.character(k9[,2]))
          k9[,3]<-as.numeric(as.character(k9[,3]))
          k9[,4]<-as.numeric(as.character(k9[,4]))
          library(plyr)
          k9<-arrange(k9, scaled_values)
          library(ggplot2)
          require(scales)
          k9_plot<-ggplot(k9) + geom_point(aes(scaled_values, similarity_snf2_br13)) + ggtitle("k9") + ylim(0,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma)
            
          + scale_x_continuous(labels = comma)
                                         
          k9_plot + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000))

          (160000, 20000, 240000, 40000, 480000, 500, 5000, 80000)
          
main=sprintf("Trends in daily %s closing prices", name)

          plots<-c(k6_plot,
          k9_plot,
          k12_plot,
          k15_plot,
          k18_plot,
          k21_plot,
          k24_plot,
          k27_plot,
          k30_plot)
          
          
          l = mget(plots)
          ggsave("arrange.pdf", arrangeGrob(grobs = l))
          
          
          
          pdf(file="trial_export_plots.pdf")
          par(mfrow=c(3,3)) 
          k6_plot
          k9_plot
          k12_plot
          k15_plot
          dev.off()
          
       
          
          
          
       
  
         
        
          
------------------------------------------------------------------
# Plot 
    # Heirarchical clustering analysis
    # calculate correlation
    cor_L2 <- cor(L2_sourmash_comp, method="spearman")
    # calculate hierarchical cluster
    hc_L2<-hclust(dist(1-cor_L2), method="average")
    
    # function for colors of tips
    color_by_type<-function(names) {
      library(stringr)
      # detect if WT is present in the name
      black <-"(ERR[0-9]{4,8})(\\.)(WT)(\\.)(BR[0-9]{1,2})(\\.)(L[0-9]{1})"
      is_WT<-str_detect(names, black)
      # detect if SNF2 is present in the name
      blue <-"(ERR[0-9]{4,8})(\\.)(SNF2)(\\.)(BR[0-9]{1,2})(\\.)(L[0-9]{1})"
      is_MUT<-str_detect(names, blue)
      # if WT is detected, black, else blue
      ifelse(is_WT==T, "black", "blue")
    }
    
    # plot
    library(ape) #package for phylo.plot
    plot.phylo(as.phylo(hc_L2), type="fan", no.margin=TRUE, font = 1, cex = 1, tip.color = color_by_type(hc_L2$labels))

 
    


    
    
    
    
    
    

   
  