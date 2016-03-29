my_seed <- 1
max_iterations <- 200
hidden_layer_size <- 1

master_formula <-   "~ . + day*SalesField7 - 1"

load(file = './cleandata.Rdata')
source('./_run_nnet.R')



