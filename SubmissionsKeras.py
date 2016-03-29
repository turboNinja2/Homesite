from keras.regularizers import l2, activity_l2
import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation
from keras.layers.normalization import BatchNormalization
from keras.layers.advanced_activations import PReLU
from sklearn.cross_validation import train_test_split
from sklearn.metrics import log_loss, auc, roc_auc_score
from keras.optimizers import Adagrad,SGD,Adadelta
from keras.callbacks import EarlyStopping
from keras.layers import containers
from keras.layers.core import Dense, AutoEncoder
from keras.constraints import maxnorm
import ImportData
import sys

print 'Argument List:', str(sys.argv)


arg_parser_index = 0

while arg_parser_index < len(sys.argv) :
    if sys.argv[arg_parser_index] == '-seed':
        my_seed = int(sys.argv[arg_parser_index+1])
    if sys.argv[arg_parser_index] == '-offset':
        offset = int(sys.argv[arg_parser_index+1])
    arg_parser_index+=1

np.random.seed(my_seed)  # for reproducibility
need_validataion = True
nb_epoch=200
batch_size = 256

def save2model(submission,file_name,y_pre):
    assert len(y_pre)==len(submission)
    submission['QuoteConversion_Flag']=y_pre
    submission.to_csv(file_name,index=False)
    print ("saved files %s" % file_name)


train,X_test,train_y=ImportData.load_data_nn(True,offset)

X_train,X_valid,y_train,y_valid=train_test_split(train,train_y,test_size=30000,random_state=my_seed)
    
nb_classes = y_train.shape[1]
print(nb_classes, 'classes')

dims = X_train.shape[1]
print(dims, 'dims')

model = Sequential()

model.add(Dense(1024, input_shape=(dims,)))
model.add(Dropout(0.1))#    input dropout
model.add(PReLU())
model.add(BatchNormalization())
model.add(Dropout(0.5))

model.add(Dense(360))
model.add(PReLU())
model.add(BatchNormalization())
model.add(Dropout(0.5))

model.add(Dense(420))
model.add(PReLU())
model.add(BatchNormalization())
model.add(Dropout(0.5))

model.add(Dense(nb_classes))
model.add(Activation('softmax'))

model.compile(loss='binary_crossentropy', optimizer="sgd")
auc_scores=[]

best_score=-1
best_model=None

best_i = -1

print('Training model...')
if need_validataion:
    for i in range(nb_epoch):
        model.fit(X_train, y_train, nb_epoch=1,batch_size=batch_size,verbose=0)
        y_pre = model.predict_proba(X_valid,verbose=0)
        scores = roc_auc_score(y_valid,y_pre)
        auc_scores.append(scores)
        print (i,scores)
        if scores>best_score:
            best_score=scores
            best_model=model    
            best_i = i


if need_validataion:
    model=best_model

print ("best_score is:",best_score)
    
y_pre = model.predict_proba(X_test,verbose=0)[:,1]
submission = pd.read_csv('./input/sample_submission.csv')
save2model(submission, 'keras_nn_'+str(offset)+'_'+str(my_seed)+'_'+str(best_i)+'_'+str(nb_epoch)+'.csv',y_pre)