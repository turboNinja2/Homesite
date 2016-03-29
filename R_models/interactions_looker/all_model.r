require(readr)
interactions_data <- read.table('./interactions.csv',sep=',',header=T)
print(head(interactions_data))

n_lines <- 200

res <- data.frame(Var1 = "0", Res = 0)

for(i in 1:n_lines)
{
  model_name <- paste0(interactions_data[i,1],"_", interactions_data[i,2])
  
  master_formula <-   paste0("~ . + ", interactions_data[i,1],"*", interactions_data[i,2]," - 1")
  
  master_formula <- gsub(x = master_formula,pattern = "\n",replacement = "",fixed = T)
  
  
  load(file = './cleandata.Rdata')
  source('./_run_lasso.R')
  
  res = rbind.data.frame(data.frame(Var1 = model_name, Res = perf),res)
  
  res <- res[order(-res$Res),]
  write_csv(x = res, path = '.\\gold_digger.csv')
}