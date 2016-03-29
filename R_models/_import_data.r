dataframe.drop <- function(df,drops) { df[,!(names(df) %in% drops)] }

require(readr)
set.seed(1)

train <- read_csv("../input/train.csv")
test  <- read_csv("../input/test.csv")

train[is.na(train)]   <- -1
test[is.na(test)]   <- -1

constant_columns <- names(which(apply(train, 2, var, na.rm=TRUE) == 0))

# seperating out the elements of the date column for the train set
train$month <- as.integer(format(train$Original_Quote_Date, "%m"))
train$year <- as.integer(format(train$Original_Quote_Date, "%y"))
train$day <- weekdays(as.Date(train$Original_Quote_Date))

test$month <- as.integer(format(test$Original_Quote_Date, "%m"))
test$year <- as.integer(format(test$Original_Quote_Date, "%y"))
test$day <- weekdays(as.Date(test$Original_Quote_Date))

test_quote_number <- test$QuoteNumber

y <- train$QuoteConversion_Flag
# removing the date column
train <- dataframe.drop(train,c("Original_Quote_Date","QuoteNumber","QuoteConversion_Flag",constant_columns))
test <- dataframe.drop(test,c("Original_Quote_Date","QuoteNumber","QuoteConversion_Flag",constant_columns))

train$NumMinusOne <- apply(train, 1, function(z) sum(z==-1))
train$NumZeroes <- apply(train, 1, function(z) sum(z==0))
train$NumUnique <- apply(train, 1, function(z) length(unique(z)))

test$NumMinusOne <- apply(test, 1, function(z) sum(z==-1))
test$NumZeroes <- apply(test, 1, function(z) sum(z==0))
test$NumUnique <- apply(test, 1, function(z) length(unique(z)))

to_factor <- c('day','month',
   paste0('Field',6:11),
   paste0('SalesField',4:7),
   paste0("CoverageField",c("5A","5B","6A","6B","8","9")),
   paste0("PersonalField",c(8,11,12,13,22,68)))

for (f in names(train)) {
    if (class(train[[f]])=="character" || f %in% to_factor) {
        levels <- unique(c(train[[f]],test[[f]]))
        if(length(levels)>1){
          train[[f]] <- factor(train[[f]], levels=levels)
          test[[f]] <- factor(test[[f]], levels=levels)
        }
        else{
          train[[f]] <- NULL
          test[[f]] <- NULL
        }
    }
}

train$PersonalField39[train$PersonalField39>3]<-3
train$PersonalField40[train$PersonalField40>3]<-3
train$PersonalField41[train$PersonalField41>3]<-3
train$PersonalField42[train$PersonalField42>3]<-3

train$PersonalField44[train$PersonalField44>5]<-5
train$PersonalField45[train$PersonalField45>5]<-5
train$PersonalField46[train$PersonalField46>5]<-5
train$PersonalField47[train$PersonalField47>5]<-5

train$PersonalField49[train$PersonalField49>3]<-3
train$PersonalField50[train$PersonalField50>3]<-3
train$PersonalField51[train$PersonalField51>3]<-3
train$PersonalField52[train$PersonalField52>3]<-3

train$PersonalField53[train$PersonalField53>5]<-5

train$PersonalField54[train$PersonalField54>4]<-4
train$PersonalField55[train$PersonalField55>4]<-4
train$PersonalField56[train$PersonalField56>4]<-4
train$PersonalField57[train$PersonalField57>4]<-4

test$PersonalField39[test$PersonalField39>3]<-3
test$PersonalField40[test$PersonalField40>3]<-3
test$PersonalField41[test$PersonalField41>3]<-3
test$PersonalField42[test$PersonalField42>3]<-3

test$PersonalField44[test$PersonalField44>5]<-5
test$PersonalField45[test$PersonalField45>5]<-5
test$PersonalField46[test$PersonalField46>5]<-5
test$PersonalField47[test$PersonalField47>5]<-5

test$PersonalField49[test$PersonalField49>3]<-3
test$PersonalField50[test$PersonalField50>3]<-3
test$PersonalField51[test$PersonalField51>3]<-3
test$PersonalField52[test$PersonalField52>3]<-3

test$PersonalField53[test$PersonalField53>5]<-5

test$PersonalField54[test$PersonalField54>4]<-4
test$PersonalField55[test$PersonalField55>4]<-4
test$PersonalField56[test$PersonalField56>4]<-4
test$PersonalField57[test$PersonalField57>4]<-4

save(file = './cleandata.Rdata',train,test,y,test_quote_number)
