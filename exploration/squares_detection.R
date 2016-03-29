require(readr)
set.seed(1)

dataframe.drop <- function(df,drops) { df[,!(names(df) %in% drops)] }

cat("reading the train and test data\n")
train <- read_csv("../input/train.csv")
train[is.na(train)]   <- -1

train <- train[sample(nrow(train),size = 200000),]
print(dim(train))

# seperating out the elements of the date column for the train set
train$month <- as.integer(format(train$Original_Quote_Date, "%m"))
train$year <- as.integer(format(train$Original_Quote_Date, "%y"))
train$day <- weekdays(as.Date(train$Original_Quote_Date))

print(dim(train))

# removing the date column
train <- dataframe.drop(train,c("Original_Quote_Date","QuoteNumber"))

print(dim(train))

to_factor <- c('month',
              paste0('Field',c(6,7,8,9,10,11)),
               paste0('SalesField',c(4,5,6)),
               paste0("CoverageField",c("5A","5B","6A","6B","8","9")),
               paste0("PersonalField",c(8,11,12,13,22,68)))

for (f in names(train)) {
  if (class(train[[f]])=="character" || f %in% to_factor) {
    levels <- unique(train[[f]])
    if(length(levels)>1){
    train[[f]] <- factor(train[[f]], levels=levels)
    }
    else{
      train[[f]] <- NULL
    }
  }
}


var_names <- names(train)

res <- data.frame(Var1 = "0", Var2 = "0", Res = 0)

for(name1 in var_names)
{
  
  if(name1!="QuoteConversion_Flag" && class(train[[name1]])!='factor')
  {
	    str_formula_interaction <- paste0("QuoteConversion_Flag~I(",name1,"^2) +",name1)
	    str_formula_no_interaction <- paste0("QuoteConversion_Flag~",name1)
	    
      model_linear_interaction <- lm(formula=str_formula_interaction,data = train)
	    model_linear_no_interaction <- lm(formula=str_formula_no_interaction,data = train)
	    
      r2_interaction <- summary(model_linear_interaction)$adj.r.squared
	    r2_no_interaction <- summary(model_linear_no_interaction)$adj.r.squared
	    
      score <- r2_interaction-r2_no_interaction
      
      print(paste0(name1,'^2 -> ',score))
      
      res = rbind.data.frame(data.frame(Var1 = name1, Var2 = name2, Res = score),res)
	  }
	
	res <- res[order(-res$Res),]
	write_csv(x = res, path = '.\\squares.csv')
  
}
