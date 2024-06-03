############


library(limma)


# 1 

myDataSet = readLines("GDS6010.soft")
myDCleaned = myDataSet[!grepl("[!^#]",myDataSet)]
writeLines(myDCleaned,"GDS6010.soft")


newTb = read.table("GDS6010.soft", sep = "\t", header=T, na.strings="null")

exps = newTb[ , 3:ncol(newTb)]


selected_samples = exps[ , c(1:6, 13:18)]

time_points = c(rep(6,6), rep(24,5))
time_factor = factor(time_points, levels=c(6,24))
time_factor

infection_status = c(rep("infection", 3), rep("control", 3), rep("infection", 3), rep("control", 3))
infection_factor = factor(infection_status, levels = c("infection", "control"))
infection_factor
