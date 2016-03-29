import numpy as np
from sklearn.metrics import metrics.mean_squared_error as mse
from sklearn import cross_validation
from time import time

def heldout_auc(model, X_test, y_test):
    score = np.zeros((model.get_params()["n_estimators"],), dtype=np.float64)
    for i, y_pred in enumerate(model.staged_decision_function(X_test)):
        score[i] = auc(y_test, y_pred)
    return score

def generic_cv(X,y,model,n_folds=3) :
    kf = cross_validation.StratifiedKFold(y, n_folds=n_folds, shuffle=True, random_state=11)
    trscores, cvscores, times = [], [], []
    i = 0
    for itr, icv in kf:
        i = i + 1
        print('FOLD : ' + str(i) + '-' + str(n_folds))
        t = time()
        trscore = mse(y.iloc[itr], model.fit(X.iloc[itr], y.iloc[itr]).predict_proba(X.iloc[itr])[:,1])
        cvscore = mse(y.iloc[icv], model.predict(X.iloc[icv])[:,1])
        trscores.append(trscore); cvscores.append(cvscore); times.append(time()-t)
    print("TRAIN %.5f | TEST %.5f | TIME %.2fm (1-fold)" % (np.mean(trscores), np.mean(cvscores), np.mean(times)/60))
    print(model.get_params(deep = True))
    print("\n")