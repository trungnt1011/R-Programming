# Lnherets from data.frame
	# All function that accept data.frame work on data.table
# Wrirren in C so it is much faster.
library(data.table)

# Create data tables just like data frames
set.seed(1)
DF <- data.frame(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z= rnorm(9))
head(DF, 3)	
set.seed(1)
DT <- data.table(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
head(DT, 3)

# See all the date tables in memory
tables()

# Subsetting rows
DT[2,]
DT[DT$y == "a", ]
DT[c(2, 3), ]

# Subsetting columns
DT[, c(1, 2)]  		# Result: 	[1] 1 2  		???
DT[, c("x", "y")]	# Result:	[1] "x" "y"		???
# In data.table(), have a modified (doi moi)
# Select x column, but return it as a vector
test <- DT[, x]
head(test)
# [1] -0.6264538  0.1836433 -0.8356286  1.5952808  0.3295078 -0.8204684
# Select x column, but return as a data.table instead
test <- DT[, list(x)]
head(test)
#            x
# 1: -0.6264538
# 2:  0.1836433
# 3: -0.8356286
# 4:  1.5952808
# 5:  0.3295078
# 6: -0.8204684
# data.table also allows using .(), as list(), they both mean the same.
test <- DT[, .(x, y)]
head(test)
# Select x and y column, and rename them to x1 and x2
test <- DT[, .(x1 = x, y1 = y)]		# Note: Not x = x1 
head(test)
#            x1 y1
# 1: -0.6264538  a
# 2:  0.1836433  a
# 3: -0.8356286  a
# 4:  1.5952808  b
# 5:  0.3295078  b
# 6: -0.8204684  b

# Calculating values for variables with expressions
DT[, list(mean(x), sum(z))]
#          V1        V2
# 1: 0.180824 0.7679388

# Adding new columns
DT2 <- DT[, w := z^2]
head(DT2, 3)
#             x y          z          w
# 1: -0.6264538 a -0.3053884 0.09326207
# 2:  0.1836433 a  1.5117812 2.28548230
# 3: -0.8356286 a  0.3898432 0.15197775
# BUT!!!, if you type
head(DT, 3)		# Result same with DT2??? --> Careful

# Multiple operations
DT[, m := {tmp = (x + z); log(tmp + 5)}]
head(DT, 3)
#             x y          z          w        m
# 1: -0.6264538 a -0.3053884 0.09326207 1.403190
# 2:  0.1836433 a  1.5117812 2.28548230 1.901424
# 3: -0.8356286 a  0.3898432 0.15197775 1.516053

# plyr like operations
DT[, a := x > 0]
head(DT, 3)
#             x y          z          w        m     a
# 1: -0.6264538 a -0.3053884 0.09326207 1.403190 FALSE
# 2:  0.1836433 a  1.5117812 2.28548230 1.901424  TRUE
# 3: -0.8356286 a  0.3898432 0.15197775 1.516053 FALSE

DT[, b := mean(x + w), by = a]
DT
#             x y           z            w        m     a          b
# 1: -0.6264538 a -0.30538839 0.0932620670 1.403190 FALSE -0.2572805
# 2:  0.1836433 a  1.51178117 2.2854823013 1.901424  TRUE  2.0632321
# 3: -0.8356286 a  0.38984324 0.1519777490 1.516053 FALSE -0.2572805
# 4:  1.5952808 b -0.62124058 0.3859398589 1.787423  TRUE  2.0632321
# 5:  0.3295078 b -2.21469989 4.9048955903 1.136167  TRUE  2.0632321
# 6: -0.8204684 b  1.12493092 1.2654695706 1.668548 FALSE -0.2572805
# 7:  0.4874291 c -0.04493361 0.0020190292 1.694238  TRUE  2.0632321
# 8:  0.7383247 c -0.01619026 0.0002621246 1.744342  TRUE  2.0632321
# 9:  0.5757814 c  0.94383621 0.8908267926 1.874816  TRUE  2.0632321
# with a = TRUE/FALE, b = mean(x+w, where a = TRUE/FALE)

# Keys and Merge
DT1 <- data.table(x = c("a","a","b","dt1"), y = 1:4)
DT2 <- data.table(x = c("a","b","dt2"), z = 5:7)
setkey(DT1, x); setkey(DT2, x)
merge(DT1, DT2)
#    x y z
# 1: a 1 5
# 2: a 2 5
# 3: b 3 6

# Read more: https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro.html
