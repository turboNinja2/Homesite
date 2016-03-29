import pandas as pd
from sklearn import ensemble, cluster, preprocessing
import CrossValidate
import ImportData
import xgboost as xgb
import numpy as np
import features 

##############################################################################
# params #####################################################################
##############################################################################

seed = 1

learning_rate = 0.025
n_estimators = [1600]

min_depth_cv = 6
max_depth_cv = 9

offsets = [1, 3, 5, 7, 11, 13, 17, 23]

##############################################################################
# functions ##################################################################
##############################################################################

def generate_models(learning_rate,n_estimators,min_depth_cv,max_depth_cv,seed):
    models = []
    for n_estimator in n_estimators:
        for k in range(min_depth_cv,max_depth_cv):
            models.append(xgb.XGBClassifier(n_estimators=n_estimator,
                            nthread=7,
                            max_depth=k,
                            learning_rate=learning_rate,
                            silent=False,
                            seed = seed,
                            subsample=0.8,
                            colsample_bytree=0.8))
    return models
    
##############################################################################
# models #####################################################################
##############################################################################

for offset in offsets:

    seed += 1
    
    train, test, y = ImportData.ImportHomesiteData3(offset)
    models = generate_models(learning_rate,n_estimators,min_depth_cv,max_depth_cv,seed)
       
    for model in models:
        predicted = model.fit(train, y).predict_proba(test)[:,1]
        sample = pd.read_csv('./input/sample_submission.csv')

        sample.QuoteConversion_Flag = predicted
        sample.to_csv('xgb_model4_'+
            str(model.get_params()["max_depth"])+'_'+
            str(model.get_params()["n_estimators"])+'_'+
            str(offset) + '.csv', index=False) 
            