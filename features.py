import pandas as pd
import numpy as np
from sklearn import cluster, preprocessing

def count_na(data):
    data['NAs'] = data.apply(lambda x : np.count_nonzero(x+999), 
        axis=1)
    return data

def count_minus_one(data):
    data['CountMinusOne'] = data.apply(lambda x : np.count_nonzero(x+1), 
        axis=1)
    return data

def count_zeroes(data):
    data['CountZeroes'] = data.apply(lambda x : np.count_nonzero(x), 
        axis=1)
    return data

def count_unique(data):
    data['CountUnique'] = data.apply(lambda x : np.unique(x).shape[0], 
        axis=1)
    return data
    
def knn(train, test, n_clusters_knn=8, seed=11):
    scaler = preprocessing.StandardScaler().fit(train)
    
    train_scaled = scaler.transform(train)
    test_scaled = scaler.transform(test)
        
    k_means_models = cluster.MiniBatchKMeans(n_clusters = n_clusters_knn, 
        random_state = seed, verbose = False)

    train_clusters = pd.DataFrame(k_means_models.fit_transform(train_scaled),index=train.index)
    train = pd.concat([train,train_clusters],axis=1)
    
    test_clusters = pd.DataFrame(k_means_models.transform(test_scaled),index=test.index)
    test = pd.concat([test,test_clusters],axis=1)
    
    return train,test
    