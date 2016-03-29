model_name <- paste0('nnet_',max_iterations,'_',my_seed,'_',hidden_layer_size)

print(paste0('NNET running on : ',model_name))

set.seed(my_seed)

train <- model.matrix(as.formula(master_formula),data=train)

print(dim(train))

not_almost_constant_columns <- which(apply(train, 2, var, na.rm=TRUE) > 0.00025)
train <- train[,not_almost_constant_columns]
print(dim(train))

gc(verbose=FALSE)

test <- model.matrix(as.formula(master_formula), data=test)
test <- test[,not_almost_constant_columns]

gc(verbose=FALSE)

require(caret)

nnetGrid <- expand.grid(size=hidden_layer_size,decay = 5* (5 ^ (-(0:2))))

y <- as.factor(paste0("F", as.character(y)))

modelnnet <- train(x = train,y = y,preProcess = c('center','scale'),
                   method = 'nnet',
				   trControl = trainControl(method = "cv",number=3), tuneGrid = nnetGrid, maxit = max_iterations,
				   trace = FALSE, MaxNWts = 3000)

print(modelnnet)
print(max(modelnnet$results$Accuracy))

test_pred <- predict(modelnnet,newdata = test,type = "prob")[,2]
print(head(test_pred))

require(readr)

submission <- data.frame(QuoteNumber=test_quote_number, QuoteConversion_Flag=test_pred)
names(submission)[2]<- "QuoteConversion_Flag"
write_csv(submission, paste0('.//nnet_',model_name,'.csv'))
