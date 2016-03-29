import pandas as pd
import numpy as np
import NextPrime
from sklearn import preprocessing
from math import *
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from keras.utils import np_utils, generic_utils


def import_raw_data():
    train = pd.read_csv('./input/train.csv').set_index("QuoteNumber")
    test = pd.read_csv('./input/test.csv').set_index("QuoteNumber")
    return train,test

    
def treat_missing(train,test):
    train = train.fillna(-1)
    test = test.fillna(-1)
    return train,test


def interaction_weekday_SalesField7(dataframe):
    # lasso exploration proved it to be the best interaction to consider
    # LB feedbacks seem to prove the same
    dataframe['weekday_salesField7'] = dataframe['SalesField7'] + dataframe['weekday'].map(str)
    return dataframe
    
    
def interaction_SalesField5_Field7(dataframe):
    dataframe['SalesField5_Field7'] = dataframe['SalesField5'].map(str) + dataframe['Field7'].map(str)
    return dataframe
    
    
def treat_dates_single(data):
    data['Date'] = pd.to_datetime(pd.Series(data['Original_Quote_Date']))
    data = data.drop('Original_Quote_Date', axis=1)
    data['Year'] = data['Date'].apply(lambda x: int(str(x)[:4]))
    data['Month'] = data['Date'].apply(lambda x: int(str(x)[5:7]))
    data['weekday'] = data['Date'].dt.dayofweek
    data['int_date'] = data['Year']*12 + data['Month'] 
    data = data.drop('Date', axis=1)
    return data
 
 
def treat_dates(train,test) :
    return treat_dates_single(train), treat_dates_single(test)

    
def drop_constant_columns(train,test) :
    nunique = pd.Series([train[col].nunique() for col in train.columns], index = train.columns)
    constants = nunique[nunique<2].index.tolist()
    
    train = train.drop(constants,axis=1)
    test = test.drop(constants,axis=1)

    return train,test

    
def replace_factors_by_response(train,test):
    #mean_response = train.QuoteConversion_Flag.mean()

    for feat in train.columns:
        if train[feat].dtype=='object' :
            rare_count = 20
        
            train.loc[train[feat].value_counts()[train[feat]].values < rare_count, feat]  = "RARE_VALUE"
            test.loc[train[feat].value_counts()[train[feat]].values  <  rare_count, feat] = "RARE_VALUE"
            
            train.loc[test[feat].value_counts()[test[feat]].values < rare_count, feat]  = "RARE_VALUE"
            test.loc[test[feat].value_counts()[test[feat]].values  <  rare_count, feat] = "RARE_VALUE"
            
            m = train.groupby([feat])['QuoteConversion_Flag'].mean()
            n = train.groupby([feat])['QuoteConversion_Flag'].count()
            
            train[feat] = train[feat].replace(m, inplace=False)
            test[feat]  = test[feat].replace(m, inplace=False)
            
    return train,test
 
 
def shift_factors(train,test,offset=1):
    for f in train.columns:
        if train[f].dtype=='object' :
            lbl = preprocessing.LabelEncoder()
            lbl.fit(list(train[f].values) + list(test[f].values))
            train[f] = lbl.transform(list(train[f].values))
            test[f] = lbl.transform(list(test[f].values))
            
            largest_label_val = max(max(train[f]),max(test[f]))
            modulo = NextPrime.next_prime(largest_label_val + offset)
            train[f] = train[f]*offset % modulo
            test[f] = test[f]*offset % modulo
    return train,test    
   
   
def ImportHomesiteData1(offset):
    train,test = import_raw_data()

    y = train.QuoteConversion_Flag
    train = train.drop('QuoteConversion_Flag', axis=1)

    train, test = treat_dates(train,test)
    train, test = treat_missing(train,test)
    train, test = drop_constant_columns(train,test)
    train, test = shift_factors(train,test,offset)
    
    return train,test,y

    
def ImportHomesiteData2():
    train,test = import_raw_data()

    train, test = treat_dates(train,test)
    train, test = treat_missing(train,test)
    train, test = drop_constant_columns(train,test)
    train, test = replace_factors_by_response(train,test)
    
    y = train.QuoteConversion_Flag
    train = train.drop('QuoteConversion_Flag', axis=1)

    return train,test,y
    
    
def ImportHomesiteData3(offset):
    train,test = import_raw_data()

    train, test = treat_dates(train,test)
    train, test = treat_missing(train,test)
    train, test = drop_constant_columns(train,test)
    
    train = interaction_weekday_SalesField7(train)
    test = interaction_weekday_SalesField7(test)
    
    train, test = shift_factors(train,test,offset)

    y = train.QuoteConversion_Flag
    train = train.drop('QuoteConversion_Flag', axis=1)

    return train,test,y   
    
    
def ImportHomesiteData4(offset):
    train,test = import_raw_data()

    train, test = treat_dates(train,test)
    train, test = treat_missing(train,test)
    train, test = drop_constant_columns(train,test)
    
    train = interaction_weekday_SalesField7(train)
    test = interaction_weekday_SalesField7(test)
    
    train = interaction_SalesField5_Field7(train)
    test = interaction_SalesField5_Field7(test)
    
    train, test = shift_factors(train,test,offset)

    y = train.QuoteConversion_Flag
    train = train.drop('QuoteConversion_Flag', axis=1)

    return train,test,y    
    
    
def getDummy(df,col):
    category_values=df[col].unique()
    data=[[0 for i in range(len(category_values))] for i in range(len(df))]
    dic_category=dict()
    for i,val in enumerate(list(category_values)):
        dic_category[str(val)]=i
   # print dic_category
    for i in range(len(df)):
        data[i][dic_category[str(df[col][i])]]=1

    data=np.array(data)
    for i,val in enumerate(list(category_values)):
        df.loc[:,"_".join([col,str(val)])]=data[:,i]

    return df
    
    
def load_data_nn(need_categorical, offset = 1):
    train,test = import_raw_data()
    
    train_y=train['QuoteConversion_Flag'].values
    train=train.drop('QuoteConversion_Flag',axis=1)
    
    train, test = drop_constant_columns(train,test)
    train, test = treat_dates(train,test)
    train, test = treat_missing(train,test)
        
    train = interaction_weekday_SalesField7(train)
    test = interaction_weekday_SalesField7(test)        
        
    train,test = shift_factors(train,test,offset)
            
    #try to encode all params less than 100 to be category
    if need_categorical:
        x=train.append(test,ignore_index=True)
        del train
        del test
        for f in x.columns:
            category_values= set(list(x[f].unique()))
            if len(category_values)<4 or f == 'weekday_salesField7':
                x=getDummy(x,f)
                x.drop(f,axis=1)
                #all_data.drop(f,axis=1)
        test = x.iloc[260753:,]
        train = x.iloc[:260753:,]

    encoder = LabelEncoder()
    train_y = encoder.fit_transform(train_y).astype(np.int32)
    train_y = np_utils.to_categorical(train_y)
    
    golden_feature=[("CoverageField1B","PropertyField21B"),
                ("GeographicField6A","GeographicField8A"),
                ("GeographicField6A","GeographicField13A"),
                ("GeographicField8A","GeographicField13A"),
                ("GeographicField11A","GeographicField13A"),
                ("GeographicField8A","GeographicField11A")]
    
    for featureA,featureB in golden_feature:
        train.loc[:,"_".join([featureA,featureB,"diff"])]=train[featureA]-train[featureB]
        test.loc[:,"_".join([featureA,featureB,"diff"])]=test[featureA]-test[featureB]        

    print ("processsing finished")
    
    train = np.array(train)
    train = train.astype(np.float32)
    test = np.array(test)
    test = test.astype(np.float32)
    
    scaler = StandardScaler().fit(train)
    train = scaler.transform(train)
    test = scaler.transform(test)
    
    return train,test,train_y    
    