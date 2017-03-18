# Code to visualize numpy output from sourmash compare
# NB output was saved to csv file from python using the command:
          # sourmash compare -o yeast_syrah_L2 ./*sig  # completed in terminal
          # import numpy
          # from sourmash_lib import fig
          # import pylab
          # D, labels = fig.load_matrix_and_labels('yeast_syrah_L2')
          # D = (D + D.T) / 2.0
          # numpy.savetxt("L2_numpy.csv", D, delimiter=",")
# Orrrrrr
          # for i in glob.glob('compared*'):
          #   if i.endswith("labels.txt") or i.endswith(".csv"):
          #   continue
          # print i
          # D, labels = fig.load_matrix_and_labels(i)
          # D = (D + D.T) / 2.0
          # numpy.savetxt("{}.csv".format(i), D, delimiter=",")
# label.txt files were saved as output from sourmash compute
-------------------------------------------------------------
# Functions for importing and formating data 
        # Function to import numpy txt file
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
          # Process files for downstream application
                # determine k sizes used for sourmash compute and compare (regex that acts on file name)
                determine_k_size<-function(input_csv_file){
                  library(stringr)
                  # regex for k size:
                  k_size_regex<-"\\.[0-9]{1,2}\\."
                  k_extraction_one<-str_extract(input_csv_file, k_size_regex)
                  k_size_regex2<-"[0-9]{1,2}"
                  k_size<-str_extract(k_extraction_one, k_size_regex2) 
                }
                
                # determine scale sizes used for sourmash compute (regex that acts on file name)
                determine_scale_size<-function(input_csv_file){
                  library(stringr)
                  # regex for --scale parameter:
                  scale_size_regex<-"\\.[0-9]{3,6}\\."
                  scale_extraction_one<-str_extract(input_csv_file, scale_size_regex)
                  scale_size_regex2<-"[0-9]{3,6}"
                  scale_size_regex2<-str_extract(scale_extraction_one, scale_size_regex2)
                }
          
# Functions to enable standard curve plots
          
          similarity<-function(sourmash_compare_matrix){
              sum(sourmash_compare_matrix[upper.tri(sourmash_compare_matrix, diag=T)])/
              (length(sourmash_compare_matrix[upper.tri(sourmash_compare_matrix, diag=T)]))
          }
         
          standard_error<-function(sourmash_compare_matrix) {
          scm = sourmash_compare_matrix[upper.tri(sourmash_compare_matrix, diag = TRUE)]
          sd(scm)/sqrt(length(scm))
          }

  # Apply to snf2 br13 data
          
          # Read in files from SNF2 BR 13 full run
          setwd("/Users/taylorreiter/Desktop/DIB/yeast_raw_fastq/SNF2_BR13/sourmash_compare_output/")
          # Read in csv files of comparisons
          # Read  csv file names
          csv_files<-list.files(".","csv$")
          length(csv_files)
          # Read label file names (txt)
          csv_labels<-list.files(".", "txt$")
          length(csv_labels)
          
          # bind vectors for input into numpy_in function
          snf2_br13_numpy_in<-cbind(csv_files, csv_labels)
          
          #Import files
          all_snf2_br13<-apply(snf2_br13_numpy_in, 1, numpy_in)  
  
          similarity_snf2_br13<-sapply(all_snf2_br13, similarity)
          standard_err_snf2_br13<-sapply(all_snf2_br13, standard_error)
          k_size_snf2_br13<-sapply(csv_files, determine_k_size)
          scale_size_snf2_br13<-sapply(csv_files, determine_scale_size)
          
          # Bind numeric columns together 
          snf2_br13_sim_stderr<-cbind(similarity_snf2_br13, standard_err_snf2_br13, k_size_snf2_br13, scale_size_snf2_br13)

          # convert from factor/character to numeric 
          snf2_br13_sim_stderr <- data.frame(apply(snf2_br13_sim_stderr, 2, function(x) as.numeric(as.character(x))))
          # bind csv_file_name (character) column 
          snf2_br13_sim_stderr <-cbind(csv_files, snf2_br13_sim_stderr)
        
          
          ---------------------------------------------
          # apply to all
          # Read in files from SNF2 BR 13 full run
          setwd("/Users/taylorreiter/Desktop/all/")
          # Read in csv files of comparisons
          # Read  csv file names
          csv_files<-list.files(".","csv$")
          length(csv_files)
          # Read label file names (txt)
          csv_labels<-list.files(".", "txt$")
          length(csv_labels)
          
          # bind vectors for input into numpy_in function
          all_numpy_in<-cbind(csv_files, csv_labels)
          
          #Import files
          all_in<-apply(all_numpy_in, 1, numpy_in)  
          
          similarity_all_in<-sapply(all_in, similarity)
          standard_err_all_in<-sapply(all_in, standard_error)
          k_size_all_in<-sapply(csv_files, determine_k_size)
          scale_size_all_in<-sapply(csv_files, determine_scale_size)
          
          # Bind numeric columns together 
          all_in_sim_stderr<-cbind(similarity_all_in, standard_err_all_in, k_size_all_in, scale_size_all_in)
          
          # convert from factor/character to numeric 
          all_in_sim_stderr <- data.frame(apply(all_in_sim_stderr, 2, function(x) as.numeric(as.character(x))))
          # bind csv_file_name (character) column 
          all_in_sim_stderr <-cbind(csv_files, all_in_sim_stderr)
          
          head(all_in_sim_stderr)
          
          # Plot all data, faceted on k size
          library(ggplot2)
          snf2_br13_sim_stderr_plot<-ggplot(snf2_br13_sim_stderr, aes(x = scaled_values, y = similarity_snf2_br13, ymin=similarity_snf2_br13-standard_err_snf2_br13, ymax=similarity_snf2_br13+standard_err_snf2_br13)) + geom_point() + ggtitle("All") + ylim(0,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma) +  geom_errorbar(width=0.2) + facet_wrap(~ k_values)
          
          snf2_br13_sim_stderr_plot<-ggplot(snf2_br13_sim_stderr, aes(x = scaled_values, y = similarity_snf2_br13, ymin=similarity_snf2_br13-standard_err_snf2_br13, ymax=similarity_snf2_br13+standard_err_snf2_br13)) + geom_point() + ggtitle("All") + ylim(0,1) + theme(axis.text.x = element_text(angle=45))  + ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + scale_x_log10(breaks=c(500, 5000, 20000, 40000, 80000, 160000, 240000, 480000), labels = comma) +  geom_errorbar(width=0.2) + facet_wrap(~ k_values)
          
          # # plot all data, faceted on k size
          # plot_all<-function(plot_data){
          #       library(ggplot2)
          #       environment = environment()
          #       plot<-ggplot(plot_data, aes_string(x = colnames(plot_data)[5], y = colnames(plot_data)[2], ymin=(plot_data)[2]-(plot_data)[3], (plot_data)[2]+(plot_data)[3])) + 
          #       geom_point() + ggtitle("All") + ylim(0,1) + 
          #       theme(axis.text.x = element_text(angle=45))  + 
          #       ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter")  + 
          #       scale_x_log10(breaks=colnames(plot_data)[5], labels = comma) +  
          #       geom_errorbar(width=0.2) 
          #       
          #       #plot + facet_wrap(~ names(plot_data)[4])
          # }
          # plot<-plot_all(snf2_br13_sim_stderr)
          
        # function for individual plots
        individual_plots<-function(data_to_be_plotted, title) {
                library(ggplot2)
                require(scales)
            ggplot(data_to_be_plotted, aes(x = scaled_values, y = similarity_snf2_br13, ymin=similarity_snf2_br13-standard_err_snf2_br13, ymax=similarity_snf2_br13+standard_err_snf2_br13)) +
            # Add points to the graph, and title the graph
            geom_point() + ggtitle(sprintf("%s", title)) + 
            # Set the y axis. 
            # If all similarities are above .6, start at .6. If not, start at 0
            ylim((min(ifelse(data_to_be_plotted[,2]>=.6, .6, 0))), 1) + 
            # rotate x axis numbers 45 degrees
            theme(axis.text.x = element_text(angle=45)) + 
            # label y and x axes
            ylab("Average Percent Similarity") + xlab("Sourmash Scaled Parameter") + 
            # use a log scale, with breaks at scaled values
            scale_x_log10(breaks=c(scaled_values), labels = comma) +  
            # Add error bars to graph
            geom_errorbar(width=0.2)
        }
          
          # From matrix, select only rows that correspond to k = 12
          k12<-snf2_br13_sim_stderr[1:8,]
          # make sure/convert factors into numbers in dataframe
          k12[,2]<-as.numeric(as.character(k12[,2]))
          k12[,3]<-as.numeric(as.character(k12[,3]))
          k12[,4]<-as.numeric(as.character(k12[,4]))
          # use function "individual_plots" to make standard curves
          library(ggplot2)
          k12_plot<-individual_plots(k12, "k12")
          

          k15<-snf2_br13_sim_stderr[9:16,]
          k15[,2]<-as.numeric(as.character(k15[,2]))
          k15[,3]<-as.numeric(as.character(k15[,3]))
          k15[,4]<-as.numeric(as.character(k15[,4]))
          library(ggplot2)
          k15_plot<-individual_plots(k15, "k15")
 
          k18<-snf2_br13_sim_stderr[17:24,]
          k18[,2]<-as.numeric(as.character(k18[,2]))
          k18[,3]<-as.numeric(as.character(k18[,3]))
          k18[,4]<-as.numeric(as.character(k18[,4]))
          library(ggplot2)
          k18_plot<-individual_plots(k18, "k18")
          
          k21<-snf2_br13_sim_stderr[25:32,]
          k21[,2]<-as.numeric(as.character(k21[,2]))
          k21[,3]<-as.numeric(as.character(k21[,3]))
          k21[,4]<-as.numeric(as.character(k21[,4]))
          library(ggplot2)
          k21_plot<-individual_plots(k21, "k21")
    
          k24<-snf2_br13_sim_stderr[33:40,]
          k24[,2]<-as.numeric(as.character(k24[,2]))
          k24[,3]<-as.numeric(as.character(k24[,3]))
          k24[,4]<-as.numeric(as.character(k24[,4]))
          library(ggplot2)
          k24_plot<-individual_plots(k24, "k24")
          
          k27<-snf2_br13_sim_stderr[41:48,]
          k27[,2]<-as.numeric(as.character(k27[,2]))
          k27[,3]<-as.numeric(as.character(k27[,3]))
          k27[,4]<-as.numeric(as.character(k27[,4]))
          library(ggplot2)
          k27_plot<-individual_plots(k27, "k27")
         
          k30<-snf2_br13_sim_stderr[49:56,]
          k30[,2]<-as.numeric(as.character(k30[,2]))
          k30[,3]<-as.numeric(as.character(k30[,3]))
          k30[,4]<-as.numeric(as.character(k30[,4]))
          library(ggplot2)
          k30_plot<-individual_plots(k30, "k30")
        
          k6<-snf2_br13_sim_stderr[57:64,]
          k6[,2]<-as.numeric(as.character(k6[,2]))
          k6[,3]<-as.numeric(as.character(k6[,3]))
          k6[,4]<-as.numeric(as.character(k6[,4]))
          library(ggplot2)
          k6_plot<-individual_plots(k6, "k6")
          
          k9<-snf2_br13_sim_stderr[65:72,]
          k9[,2]<-as.numeric(as.character(k9[,2]))
          k9[,3]<-as.numeric(as.character(k9[,3]))
          k9[,4]<-as.numeric(as.character(k9[,4]))
          library(ggplot2)
          k9_plot<-individual_plots(k9, "k9")
          
          
          pdf(file="trial_export_plots.pdf")
          k6_plot; k9_plot; k12_plot; k15_plot; k18_plot; k21_plot; k24_plot; k27_plot; k30_plot
          dev.off()
      
------------------------------------------------------------------
# Plot 
    # Heirarchical clustering analysis
    # calculate correlation
    cor_all<-lapply(all_in, function(x) {cor(x, method="spearman")})
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
    
    
    # function for colors of tips (works best of Syrah)
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

plots<-plot.phylo(as.phylo(hc_all), type="fan", no.margin=TRUE, font = 1, cex = 1)
  


# Old trials before code was cleaned
    # # import lane 2 signature (test the function)
    # L2_sourmash_comp<-numpy_in("/Users/taylorreiter/Desktop/Titus_Brown/yeast_syrah/L2/L2_numpy.csv", "/Users/taylorreiter/Desktop/Titus_Brown/yeast_syrah/L2/yeast_syrah_L2.labels.txt")
    # # check file integrity
    # head(L2_sourmash_comp)
    
    # # subset to remove the file names that are not comparison files
    # csv_files<-csv_files[1:90]
    # # Remove k = 1000--unidentified error, being ignored right now
    # library(stringr)
    # regex_eliminate_k1000<-"^((?!.1000.).)*$"  # mimicing 'does not contain' in regex
    # csv_files_no_k1000<-str_extract(csv_files, regex_eliminate_k1000)
    # csv_files_no_k1000<-csv_files_no_k1000[!is.na(csv_files_no_k1000)]
    # csv_labels_no_k1000<-str_extract(csv_labels, regex_eliminate_k1000)
    # csv_labels_no_k1000<-csv_labels_no_k1000[!is.na(csv_labels_no_k1000)]
    
  ---------------------------------------------------------
      # Plot 
      # Heirarchical clustering analysis
      # calculate correlation
    #   cor_L2 <- cor(L2_sourmash_comp, method="spearman")
    # # calculate hierarchical cluster
    # hc_L2<-hclust(dist(1-cor_L2), method="average")
    # 
    # # function for colors of tips
    # color_by_type<-function(names) {
    #   library(stringr)
    #   # detect if WT is present in the name
    #   black <-"(ERR[0-9]{4,8})(\\.)(WT)(\\.)(BR[0-9]{1,2})(\\.)(L[0-9]{1})"
    #   is_WT<-str_detect(names, black)
    #   # detect if SNF2 is present in the name
    #   blue <-"(ERR[0-9]{4,8})(\\.)(SNF2)(\\.)(BR[0-9]{1,2})(\\.)(L[0-9]{1})"
    #   is_MUT<-str_detect(names, blue)
    #   # if WT is detected, black, else blue
    #   ifelse(is_WT==T, "black", "blue")
    # }
    # 
    # # plot
    # library(ape) #package for phylo.plot
    # plot.phylo(as.phylo(hc_L2), type="fan", no.margin=TRUE, font = 1, cex = 1, tip.color = color_by_type(hc_L2$labels))

   
    
    # Plot 
    # Heirarchical clustering analysis
    # calculate correlation
    cor_all <- cor(all_in[[1]], method="spearman")
    # # calculate hierarchical cluster
    hc_all<-hclust(dist(1-cor_all), method="average")

    # plot
    library(ape) #package for phylo.plot
    plot.phylo(as.phylo(hc_all), type="fan", no.margin=TRUE, font = 1, cex = 1)
  