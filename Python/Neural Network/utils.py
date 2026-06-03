import numpy as np

def get_shapes(X, y):
    
    # Extract shapes
    input_size = X.shape[0]
    output_size = len(np.unique(y))  # Number of classes

    return input_size, output_size