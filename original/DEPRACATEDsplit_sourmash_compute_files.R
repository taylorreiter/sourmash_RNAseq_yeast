# Code to separate sourmash compare files that have 7 ERR... signatures in each. Write each to its' own file, with *.sig as the appended name. Add ERR... accession to the beginning of each file, and keep the rest of the original file name the same. 

setwd("/Users/taylorreiter/Desktop/Titus_Brown/yeast_raw_fastq/SNF2_BR13/")

separate_sourmash_compute<-function(sourmash_compute_output, original_file_name) {

  # regex for name of individual files
  library(stringr)
  find_names<-"(ERR)([0-9]{4,6})"
  # subset to lines that contain the SRA accession number
  name_strings<-str_subset(sourmash_compute_output[,1], find_names)
  # extract only the SRA accession number
  name_strings_isolated<-str_extract(name_strings, find_names)
  
  # regex for "class"; location where to subset file
  start_of_sig_regex<-"([class]{5})"
  grab_lines<-grep(start_of_sig_regex, sourmash_compute_output[,1])
  # save as a vector; subtract one to include "{"
  start_of_sig_line<-grab_lines-1
  
  # split files into individual data frames inside list
  split_files<-split(sourmash_compute_output, findInterval(1:nrow(sourmash_compute_output), start_of_sig_line))
  
  # assign names 
  names(split_files)<-(name_strings_isolated)
  
  # export as individual txt files
  sapply(names(split_files), function (x) write.table(split_files[[x]], file=paste(x, original_file_name, "sig", sep="."), quote=FALSE, row.names=FALSE, col.names=FALSE))
}


#list files in directory to be separated

SNF2_files<-sapply(SNF2_file_names, read.delim)
length(SNF2_files)
names(SNF2_files)[1]
SNF2_files[1]
split(SNF2_files)

names


separate_sourmash_compute(SNF2_BR13_k27_s20000, "SNF2_BR13_k27_s20000")

separate_sourmash_compute(SNF2_files[[1]], "SNF2_BR13_k12_s1000")



# Read file names
SNF2_file_names<-list.files(".","^SNF2")

# Load all files
for(i in SNF2_file_names){
  filepath <- file.path(".",paste(i))
  assign(i, read.delim(filepath))
}

# List objects in R session and subset to only file names
ls()
objects<-ls()
file_names<-objects[11:91]

# Export to excel, and write commands by combining columns
write.csv(file_names, "SNF2_file_names.csv")

separate_sourmash_compute(SNF2_BR13_k12_s1000, 'SNF2_BR13_k12_s1000')
separate_sourmash_compute(SNF2_BR13_k12_s10000, 'SNF2_BR13_k12_s10000')
separate_sourmash_compute(SNF2_BR13_k12_s160000, 'SNF2_BR13_k12_s160000')
separate_sourmash_compute(SNF2_BR13_k12_s20000, 'SNF2_BR13_k12_s20000')
separate_sourmash_compute(SNF2_BR13_k12_s240000, 'SNF2_BR13_k12_s240000')
separate_sourmash_compute(SNF2_BR13_k12_s40000, 'SNF2_BR13_k12_s40000')
separate_sourmash_compute(SNF2_BR13_k12_s480000, 'SNF2_BR13_k12_s480000')
separate_sourmash_compute(SNF2_BR13_k12_s5000, 'SNF2_BR13_k12_s5000')
separate_sourmash_compute(SNF2_BR13_k12_s80000, 'SNF2_BR13_k12_s80000')
separate_sourmash_compute(SNF2_BR13_k15_s1000, 'SNF2_BR13_k15_s1000')
separate_sourmash_compute(SNF2_BR13_k15_s10000, 'SNF2_BR13_k15_s10000')
separate_sourmash_compute(SNF2_BR13_k15_s160000, 'SNF2_BR13_k15_s160000')
separate_sourmash_compute(SNF2_BR13_k15_s20000, 'SNF2_BR13_k15_s20000')
separate_sourmash_compute(SNF2_BR13_k15_s240000, 'SNF2_BR13_k15_s240000')
separate_sourmash_compute(SNF2_BR13_k15_s40000, 'SNF2_BR13_k15_s40000')
separate_sourmash_compute(SNF2_BR13_k15_s480000, 'SNF2_BR13_k15_s480000')
separate_sourmash_compute(SNF2_BR13_k15_s5000, 'SNF2_BR13_k15_s5000')
separate_sourmash_compute(SNF2_BR13_k15_s80000, 'SNF2_BR13_k15_s80000')
separate_sourmash_compute(SNF2_BR13_k18_s1000, 'SNF2_BR13_k18_s1000')
separate_sourmash_compute(SNF2_BR13_k18_s10000, 'SNF2_BR13_k18_s10000')
separate_sourmash_compute(SNF2_BR13_k18_s160000, 'SNF2_BR13_k18_s160000')
separate_sourmash_compute(SNF2_BR13_k18_s20000, 'SNF2_BR13_k18_s20000')
separate_sourmash_compute(SNF2_BR13_k18_s240000, 'SNF2_BR13_k18_s240000')
separate_sourmash_compute(SNF2_BR13_k18_s40000, 'SNF2_BR13_k18_s40000')
separate_sourmash_compute(SNF2_BR13_k18_s480000, 'SNF2_BR13_k18_s480000')
separate_sourmash_compute(SNF2_BR13_k18_s5000, 'SNF2_BR13_k18_s5000')
separate_sourmash_compute(SNF2_BR13_k18_s80000, 'SNF2_BR13_k18_s80000')
separate_sourmash_compute(SNF2_BR13_k21_s1000, 'SNF2_BR13_k21_s1000')
separate_sourmash_compute(SNF2_BR13_k21_s10000, 'SNF2_BR13_k21_s10000')
separate_sourmash_compute(SNF2_BR13_k21_s160000, 'SNF2_BR13_k21_s160000')
separate_sourmash_compute(SNF2_BR13_k21_s20000, 'SNF2_BR13_k21_s20000')
separate_sourmash_compute(SNF2_BR13_k21_s240000, 'SNF2_BR13_k21_s240000')
separate_sourmash_compute(SNF2_BR13_k21_s40000, 'SNF2_BR13_k21_s40000')
separate_sourmash_compute(SNF2_BR13_k21_s480000, 'SNF2_BR13_k21_s480000')
separate_sourmash_compute(SNF2_BR13_k21_s5000, 'SNF2_BR13_k21_s5000')
separate_sourmash_compute(SNF2_BR13_k21_s80000, 'SNF2_BR13_k21_s80000')
separate_sourmash_compute(SNF2_BR13_k24_s1000, 'SNF2_BR13_k24_s1000')
separate_sourmash_compute(SNF2_BR13_k24_s10000, 'SNF2_BR13_k24_s10000')
separate_sourmash_compute(SNF2_BR13_k24_s160000, 'SNF2_BR13_k24_s160000')
separate_sourmash_compute(SNF2_BR13_k24_s20000, 'SNF2_BR13_k24_s20000')
separate_sourmash_compute(SNF2_BR13_k24_s240000, 'SNF2_BR13_k24_s240000')
separate_sourmash_compute(SNF2_BR13_k24_s40000, 'SNF2_BR13_k24_s40000')
separate_sourmash_compute(SNF2_BR13_k24_s480000, 'SNF2_BR13_k24_s480000')
separate_sourmash_compute(SNF2_BR13_k24_s5000, 'SNF2_BR13_k24_s5000')
separate_sourmash_compute(SNF2_BR13_k24_s80000, 'SNF2_BR13_k24_s80000')
separate_sourmash_compute(SNF2_BR13_k27_s1000, 'SNF2_BR13_k27_s1000')
separate_sourmash_compute(SNF2_BR13_k27_s10000, 'SNF2_BR13_k27_s10000')
separate_sourmash_compute(SNF2_BR13_k27_s160000, 'SNF2_BR13_k27_s160000')
separate_sourmash_compute(SNF2_BR13_k27_s20000, 'SNF2_BR13_k27_s20000')
separate_sourmash_compute(SNF2_BR13_k27_s240000, 'SNF2_BR13_k27_s240000')
separate_sourmash_compute(SNF2_BR13_k27_s40000, 'SNF2_BR13_k27_s40000')
separate_sourmash_compute(SNF2_BR13_k27_s480000, 'SNF2_BR13_k27_s480000')
separate_sourmash_compute(SNF2_BR13_k27_s5000, 'SNF2_BR13_k27_s5000')
separate_sourmash_compute(SNF2_BR13_k27_s80000, 'SNF2_BR13_k27_s80000')
separate_sourmash_compute(SNF2_BR13_k30_s1000, 'SNF2_BR13_k30_s1000')
separate_sourmash_compute(SNF2_BR13_k30_s10000, 'SNF2_BR13_k30_s10000')
separate_sourmash_compute(SNF2_BR13_k30_s160000, 'SNF2_BR13_k30_s160000')
separate_sourmash_compute(SNF2_BR13_k30_s20000, 'SNF2_BR13_k30_s20000')
separate_sourmash_compute(SNF2_BR13_k30_s240000, 'SNF2_BR13_k30_s240000')
separate_sourmash_compute(SNF2_BR13_k30_s40000, 'SNF2_BR13_k30_s40000')
separate_sourmash_compute(SNF2_BR13_k30_s480000, 'SNF2_BR13_k30_s480000')
separate_sourmash_compute(SNF2_BR13_k30_s5000, 'SNF2_BR13_k30_s5000')
separate_sourmash_compute(SNF2_BR13_k30_s80000, 'SNF2_BR13_k30_s80000')
separate_sourmash_compute(SNF2_BR13_k6_s1000, 'SNF2_BR13_k6_s1000')
separate_sourmash_compute(SNF2_BR13_k6_s10000, 'SNF2_BR13_k6_s10000')
separate_sourmash_compute(SNF2_BR13_k6_s160000, 'SNF2_BR13_k6_s160000')
separate_sourmash_compute(SNF2_BR13_k6_s20000, 'SNF2_BR13_k6_s20000')
separate_sourmash_compute(SNF2_BR13_k6_s240000, 'SNF2_BR13_k6_s240000')
separate_sourmash_compute(SNF2_BR13_k6_s40000, 'SNF2_BR13_k6_s40000')
separate_sourmash_compute(SNF2_BR13_k6_s480000, 'SNF2_BR13_k6_s480000')
separate_sourmash_compute(SNF2_BR13_k6_s5000, 'SNF2_BR13_k6_s5000')
separate_sourmash_compute(SNF2_BR13_k6_s80000, 'SNF2_BR13_k6_s80000')
separate_sourmash_compute(SNF2_BR13_k9_s1000, 'SNF2_BR13_k9_s1000')
separate_sourmash_compute(SNF2_BR13_k9_s10000, 'SNF2_BR13_k9_s10000')
separate_sourmash_compute(SNF2_BR13_k9_s160000, 'SNF2_BR13_k9_s160000')
separate_sourmash_compute(SNF2_BR13_k9_s20000, 'SNF2_BR13_k9_s20000')
separate_sourmash_compute(SNF2_BR13_k9_s240000, 'SNF2_BR13_k9_s240000')
separate_sourmash_compute(SNF2_BR13_k9_s40000, 'SNF2_BR13_k9_s40000')
separate_sourmash_compute(SNF2_BR13_k9_s480000, 'SNF2_BR13_k9_s480000')
separate_sourmash_compute(SNF2_BR13_k9_s5000, 'SNF2_BR13_k9_s5000')
separate_sourmash_compute(SNF2_BR13_k9_s80000, 'SNF2_BR13_k9_s80000')




# Failed attempts at doing the things I wanted to do
# original_name<- c()
#   for (i in length(names(SNF2_files))) {
#   original_name<-names(SNF2_files)[[i]]
#   return(original_name)
# }
