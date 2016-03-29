my_seed <- 2
max_iterations <- 600
hidden_layer_size <- 4

master_formula <-   "~ . + day*SalesField7 - 1"

load(file = './cleandata.Rdata')
source('./_run_nnet.R')