import numpy as np
from sklearn.preprocessing import MinMaxScaler

# Separate target from the features
def separate_data(data):

    features = data.drop(columns='target')
    target = data['target']

    return features, target

# Scale the features
def scale_features(X_train, X_test):

    scaler = MinMaxScaler(feature_range=(-1, 1))

    X_train = scaler.fit_transform(X_train)
    X_test = scaler.transform(X_test)

    return X_train, X_test

# Convert data to NumPy array and transpose for easier manipulation
def transpose_data(data):
    data = np.array(data)
    return data.T

# Produce a 2x2 one-hot encoded matrix and transpose the target
def one_hot_encode_target(label):

    n_classes = len(np.unique(label))
    target = np.eye(n_classes)[label]
    
    return target