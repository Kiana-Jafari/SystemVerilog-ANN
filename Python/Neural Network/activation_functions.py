import numpy as np

# ReLU activation function + derivative
def ReLU(z):
    return np.maximum(0, z)

def ReLU_derivative(z):
    return np.where(z > 0, 1, 0)

# Sigmoid activation function: Computes probability distribution for output class
def Sigmoid(z):
    return 1 / (1 + (np.exp(-z)))