# dplyr functionality
# Five basic verbs: filter, select, arrange, mutate, summarise (plus: group_by)
# Can work with data stored in databases and data.table
# Joins: inner join, left join, semi-join, anti-join
# Windown functions for calculating ranking, offsets, and more
# Better than plyr if you're only working with data frames

# Loading dplyr and an example dataset
# load packages
library(dplyr)

# explore data
library(hflights)
data(hflights)
head(hflights)

# Convert to local data frame
flights <- tbl_df(hflights)

# printing only shovs 10 rows (defaulf) and as many columns as can fit on your screen
flights
# Source: local data frame [227,496 x 21]

#     Year Month DayofMonth DayOfWeek DepTime ArrTime UniqueCarrier FlightNum
#    (int) (int)      (int)     (int)   (int)   (int)         (chr)     (int)
# 1   2011     1          1         6    1400    1500            AA       428
# 2   2011     1          2         7    1401    1501            AA       428
# 3   2011     1          3         1    1352    1502            AA       428
# 4   2011     1          4         2    1403    1513            AA       428
# 5   2011     1          5         3    1405    1507            AA       428
# 6   2011     1          6         4    1359    1503            AA       428
# 7   2011     1          7         5    1359    1509            AA       428
# 8   2011     1          8         6    1355    1454            AA       428
# 9   2011     1          9         7    1443    1554            AA       428
# 10  2011     1         10         1    1443    1553            AA       428
# ..   ...   ...        ...       ...     ...     ...           ...       ...
# Variables not shown: TailNum (chr), ActualElapsedTime (int), AirTime (int),
#   ArrDelay (int), DepDelay (int), Origin (chr), Dest (chr), Distance (int),
#   TaxiIn (int), TaxiOut (int), Cancelled (int), CancellationCode (chr), Diverted
#   (int)

# You can specify that you want to see more rows
print(flights, n = 20)

# Convert to a normal data frame to see all of the column
data.frame(head(flights))

#--------filter: Keep rows matching criteria-----
#--------filter: Giu lai cac dong theo tieu chi--
# Command structure (for all dplyr verbs):
# 	- first argument is a data frame
#	- return value is a data frame
# 	- nothing is modified in place

# view all flights on January 1

# Use base R
flights[flights$Month == 1 & flights$DayofMonth == 1, ]
# Use dpylr (Note: Ban co the dung dau "," hoac dau "&" de thuc hien phep AND)
filter(flights, Month == 1, DayofMonth == 1)
filter(flights, Month == 1 & DayofMonth == 1)

# Use "|" for OR condition
filter(flights, UniqueCarrier == "AA" | UniqueCarrier == "UA")
# You can also use %in% operator
filter(flights, UniqueCarrier %in% c("AA", "UA"))


#--------select: Pick columns by name------------
#--------select: Chon cot theo ten---------------
# Like a SELECT in SQL

# Select DepTime, ArrTime, and FlightNum columns

# Use base R
flights[, c("DepTime", "ArrTime", "FlightNum")]
# Use dplyr
select(flights, DepTime, ArrTime, FlightNum)

# Source: local data frame [227,496 x 3]
#    DepTime ArrTime FlightNum
#      (int)   (int)     (int)
# 1     1400    1500       428
# 2     1401    1501       428
# 3     1352    1502       428
# 4     1403    1513       428
# 5     1405    1507       428
# 6     1359    1503       428
# 7     1359    1509       428
# 8     1355    1454       428
# 9     1443    1554       428
# 10    1443    1553       428
# ..     ...     ...       ...

# use colon (:) to select multiple contiguous columns (cot lien tiep nhau)
# use 'contains' to match column by name (ten cot co chua noi dung)
select(flights, Year:DayofMonth, contains("Taxi"), contains("Delay"))

# Source: local data frame [227,496 x 7]
#     Year Month DayofMonth TaxiIn TaxiOut ArrDelay DepDelay
#    (int) (int)      (int)  (int)   (int)    (int)    (int)
# 1   2011     1          1      7      13      -10        0
# 2   2011     1          2      6       9       -9        1
# 3   2011     1          3      5      17       -8       -8
# 4   2011     1          4      9      22        3        3
# 5   2011     1          5      9       9       -3        5
# 6   2011     1          6      6      13       -7       -1
# 7   2011     1          7     12      15       -1       -1
# 8   2011     1          8      7      12      -16       -5
# 9   2011     1          9      8      22       44       43
# 10  2011     1         10      6      19       43       43
# ..   ...   ...        ...    ...     ...      ...      ...


##-------Chaining or Pipelining------------------
##-------Thuc hien nhieu tac vu or Pipelining----
# Usual way to perform multiple operations in one line is nesting
# Thuong thi cach thuc hien nhieu tac vu trong 1 lenh la nhom (nesting)
# Can write commands in a natural order by using the %>% infix operator (which
# can be pronounced as "then")
# Co the viet lenh theo mot trat tu bang cach su dung toan tu %>% (<=> then)
# nesting method
filter(select(flights, UniqueCarrier, DepDelay), DepDelay > 60)
# chaining method
flights %>%
	select(UniqueCarrier, DepDelay) %>%
	filter(DepDelay > 60)

# Example about chaning method: %>%
x1 <- 1:5 ; x2 <- 2:6 ;
# normal method
sqrt(sum((x1 - x2)^2))
# chaining method
(x1 - x2)^2 %>% sum() %>% sqrt()


##-------arrange: Reorder rows-------------------
##-------arrange: Sap xep lai hang---------------

# Select UniqueCarrier and DepDelay columns and sort by DepDelay

# Use base R
flights[order(flights$DepDelay), c("UniqueCarrier", "DepDelay")]
# Use dplyr
flights %>%
	select(UniqueCarrier, DepDelay) %>%
	arrange(DepDelay)
# Use "desc" for descending
flights %>%
	select(UniqueCarrier, DepDelay) %>%
	arrange(desc(DepDelay))


##-------mutate: Add new variables---------------
##-------mutate: Them bien moi-------------------

# Create a new variable Speed (in mph)

# Use base R
flights$Speed <- flights$Distance / flights$AirTime * 60
flights[, c("Distance", "AirTime", "Speed")]
# Use dplyr (But not stored it, print only)
flights %>%
	select(Distance, AirTime) %>%
	mutate(Speed = Distance / AirTime * 60)


##-------summarise: Reduce variables to values---
##-------summarise: Tom tat gia tri cua bien-----
# group_by: creates the group that will be operated on
# summarise: uses the provided aggregation function to summarise each group

# Calculation the average arrival delay to each destination
# Use base R
head(with(flights, tapply(ArrDelay, Dest, mean, na.rm = TRUE)))		# or
head(aggregate(ArrDelay ~ Dest, flights, mean))
# Use dplyr
flights %>% group_by(Dest) %>% 
	summarise(avg_delay = mean(ArrDelay, na.rm = TRUE))
# summarise_each: allows you to apply the same summary function to multiple
# cloumn at once (cho phep ap dung cac ham tren nhieu cot)
# ex: for each carrier, calculate the percentage of flights cancelled or diverted
flights %>%
	group_by(UniqueCarrier) %>%
	summarise_each(funs(mean), Cancelled, Diverted)
# mutate_each: is also available

# for each carrier, calculate the minimum and maximum arrival and departure delays
flights %>%
	group_by(UniqueCarrier) %>%
	summarise_each(funs(min(., na.rm = TRUE), max(., na.rm = TRUE)), matches("Delay"))

flights %>%
	group_by(UniqueCarrier) %>%
	summarise_each(funs(min(., na.rm = TRUE), max(., na.rm = TRUE), mean(., na.rm = TRUE)),
                   matches("ArrDelay"))
# function n() count the number of rows in a group
# function n_distinct(vector) counts the number of unique items in that vector

# count the total number of flights and sort in descending order
flights %>%
	group_by(Month, DayofMonth) %>%
	summarise(flight_count = n() ) %>%			# count
	arrange(desc(flight_count))					# sort

# rewrite more simple with the "tally" function (Viet lai don gian hon vs tapply)
flights %>%
	group_by(Month, DayofMonth) %>%
	tapply(sort = TRUE)

# for each destination, count the total number of flights and the number of distinct
# planes that flew there
flights %>%
	group_by(Dest) %>%
	summarise(flight_count = n(), plane_count = n_distinct(TailNum))

# for each destination, show the number of cancelled and not cancelled flights
# Voi moi destination, show ra so chuyen bay bi huy va khong bi huy
flights %>% 
	group_by(Dest) %>%
	select(Cancelled) %>% 
	table() %>%
	head()

##-------Windown Functions-----------------------
# Aggregation function (Ham tong hop) (like: mean) takes n inputs and return 1 value
# Windown function takes n inputs and return n values
# - Includes ranking and ordering functions (like: min_rank), offset functions
#(lead and lag), and cumulative aggregates (like cummean)

# for each carrier, calculate which two days of the year they had their longest
#departure delays
# Note: smallest (not largest) value is ranked as 1, so you have to use desc to 
#rank by largest value

flights %>%
	group_by(UniqueCarrier) %>%
	select(Month, DayofMonth, DepDelay) %>%
	filter(min_rank(desc(DepDelay)) <= 2) %>%
	arrange(UniqueCarrier, desc(DepDelay))

# rewrite more simple with the "top_n" function
flights %>%
	group_by(UniqueCarrier) %>%
	select(Month, DayofMonth, DepDelay) %>%
	top_n(2) %>%
	arrange(UniqueCarrier, desc(DepDelay))

# for each month, calculate the number of flights and the change from the previou
# month
flights %>%
	group_by(Month) %>%
	summarise(flight_count = n()) %>%
	mutate(change = flight_count - lag(flight_count))
# rewrite more simply with the 'tally' function
flights %>%
	group_by(Month) %>%
	tally()	%>%
	mutate(change = n - lag(n))
	

##-------Other Useful Convenience Functions------
# randomly sample a fixed number of rows, without replacement
flights %>% sample_n(5)

# randomly sample a fractions of rows, with replacement
# lay mau ngau nhien, voi kich co bang 1 phan so tong the 
flights %>% sample_frac(0.25, replace = TRUE)

# View the structure of an object
# Use base R
str(flights)
# Use dplyr
glimpse(flights)