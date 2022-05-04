###### ###### ###### ###### ###### ######
###### ###### process phase ###### ######
###### ###### ###### ###### ###### ######

## showing NA-values
is.na(activity)
which(is.na(activity))

is.na(sleep)
which(is.na(sleep))
### count the number of NA values ---> (There are 0 NA-Values in the datasets)
sum(is.na(activity))
sum(is.na(sleep))

## Remove duplicates 
# First summarize duplicates
sum(duplicated(activity))
sum(duplicated(sleep)) # There are 3 duplicates in the sleep_day dataset
## remove the duplicates with the unique-function
sleep <- unique(sleep)

# rename columns for avoiding problems with case-sensitivity in R to lower case
activity <- rename_with(activity, tolower)
sleep <- rename_with(sleep, tolower)

# Now I'll use the clean names function in the Janitor package. This will automatically make sure that the 
# column names are unique and consistent. 
clean_names(activity)
clean_names(sleep)

## Time formatting
activity$activitydate=as.POSIXct(activity$activitydate, format="%m/%d/%Y", tz=Sys.timezone())
activity$dt <- format(activity$activitydate, format = "%m/%d/%y")
# sleep
sleep$sleepday=as.POSIXct(sleep$sleepday, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
sleep$dt <- format(sleep$sleepday, format = "%m/%d/%y")

# Describe the datasets for getting an overview (seperate results of the single values)
# Variable = totalsteps from activity-dataset
mean(activity$totalsteps)
median(activity$totalsteps)
range(activity$totalsteps)
IQR(activity$totalsteps)

# Variable = totalminutesasleep from the sleep-dataset
## also show the average time in hours with "totalhoursasleep"

sleep %>% 
  mutate(totalhoursasleep=totalminutesasleep/60) %>% 
  summarise(mean(totalhoursasleep))

mean(sleep$totalminutesasleep)
median(sleep$totalminutesasleep)
range(sleep$totalminutesasleep)
IQR(sleep$totalminutesasleep)

# Summarise the data
summary(sleep)
summary(activity)

## Merging the datasets now
activity_sleep_merged <- merge(activity, sleep, by=c("id", "dt"))
View(activity_sleep_merged[1:20,1:20])
str(activity)

# creating a subset of the dataset for analyzing the variables I am interested in
df_as <- subset(activity_sleep_merged, select=c("id","dt","totalsteps","totaldistance",
                                                "veryactivedistance", "calories", "totalminutesasleep"))
nrow(df_as) # only 410 rows left

### Save final data set
setwd(path3)
getwd()
save(df_as,file="activity_sleep.Rda")