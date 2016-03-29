require(readr)

train = read_csv('../input/train.csv')

dataframe.drop <- function(df,drops) { df[,!(names(df) %in% drops)] }

# Extra features

train[is.na(train)]   <- -1

train$NumMinusNineNineNine <- apply(train, 1, function(z) sum(z==-999))
train$NumMinusOne <- apply(train, 1, function(z) sum(z==-1))
train$NumZeroes <- apply(train, 1, function(z) sum(z==0))
train$NumUnique <- apply(train, 1, function(z) length(unique(z)))

train$month <- as.integer(format(train$Original_Quote_Date, "%m"))
train$year <- as.integer(format(train$Original_Quote_Date, "%y"))
train$day <- as.integer(weekdays(as.Date(train$Original_Quote_Date)))

train <- dataframe.drop(train,c("Original_Quote_Date","QuoteNumber"))

cat("assuming text variables are categorical & replacing them with numeric ids\n")
for (f in names(train)) {
  if (class(train[[f]])=="character") {
    levels <- unique(train[[f]])
    if(length(levels)==2)
    {
      print(paste0(f,'-> binary feature'))
    }
    train[[f]] <- as.integer(factor(train[[f]], levels=levels))
  }
}

train$Sum <- apply(train, 1, function(z) sum(z))


produceAnalysis <- function(train,outFileName)
{
  pdf(paste0('./',outFileName))
  
  for(name in names(train))
  {
    if(typeof(train[,name])!="character")
    {
      p0 <- hist(train[,name],plot = F)
      p1 <- hist(train[train[,"QuoteConversion_Flag"]==0,name],plot = F, breaks = p0$breaks)
      p2 <- hist(train[train[,"QuoteConversion_Flag"]==1,name],plot = F, breaks = p0$breaks)
    
      par(mfrow=c(1,2))
      
      plot( p1, col=rgb(0,0,1,1/4), main = name,xlab = "QuoteConversion_Flag=0")  # first histogram
      plot( p2, col=rgb(1,0,0,1/4), main = name, xlab = "QuoteConversion_Flag=1")  # second
      
      if(length(table(train[,name]))<100)
      {
        par(mfrow=c(1,1))
        avg = tapply(train[,"QuoteConversion_Flag"], train[,name], mean)
        indexes = tapply(train[,name], train[,name], mean)
        sdev = tapply(train[,"QuoteConversion_Flag"], train[,name], sd) / sqrt(tapply(train[,"QuoteConversion_Flag"], train[,name], length))
        plot(indexes, avg, main=name,ylab = "Average label value", type = "p",col="red")
        
        arrows(indexes, avg-sdev, indexes, avg+sdev, length=0.05, angle=90, code=3)
      }
    }
  }
  dev.off()
}

produceAnalysis(train,'mainAnalysis.pdf')
