## code to prepare `DATASET` dataset goes here
ami <- read.table("http://static.lib.virginia.edu/statlab/materials/data/ami_data.DAT")
names(ami) <- c("TOT","AMI","GEN","AMT","PR","DIAP","QRS")
usethis::use_data(ami, overwrite = TRUE)
