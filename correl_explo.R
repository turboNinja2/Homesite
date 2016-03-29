submissions <- list.files(path = ".//submissions//",pattern = "*.csv")

complete_submissions <- read.table(file = paste0(".//submissions//",submissions[1]),sep = ",",header = T)$QuoteConversion_Flag
head(complete_submissions)

for(i in 2:length(submissions))
{
  current_submission <- read.table(file = paste0(".//submissions//",submissions[i]),sep = ",",header = T)$QuoteConversion_Flag
  complete_submissions <- cbind.data.frame(complete_submissions,current_submission)
}


require(corrplot)

names(complete_submissions) <- submissions
print(head(complete_submissions))
print(dim(complete_submissions))

corrplot(cor(complete_submissions),is.corr = F)
