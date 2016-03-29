print(paste0('LASSO running on : ',model_name))

train <- model.matrix(as.formula(master_formula),data=train)

print(dim(train))

not_almost_constant_columns <- which(apply(train, 2, var, na.rm=TRUE) > 0.00015)
train <- train[,not_almost_constant_columns]
print(dim(train))

gc(verbose=FALSE)

test <- model.matrix(as.formula(master_formula), data=test)
test <- test[,not_almost_constant_columns]

gc(verbose=FALSE)

require(glmnet)
modelcv <- cv.glmnet(x = train, y = y,                                  #data
                 alpha = 0.8, lambda = exp(-seq(7,15,by=0.1)),          #model parameters
                 type.measure = "auc",family = 'binomial',nfolds = 5,   #CV parameters
                 thresh = 1e-5,maxit=1000)                              #numeric parameters


perf <- max(modelcv$cvm)

print(perf)
