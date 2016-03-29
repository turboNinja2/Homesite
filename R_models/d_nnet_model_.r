my_seed <- 1
max_iterations <- 400
hidden_layer_size <- 2

master_formula <-   "~ . + day*SalesField7 - 1"

load(file = './cleandata.Rdata')
source('./_run_nnet.R')