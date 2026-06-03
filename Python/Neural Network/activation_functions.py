import numpy as np

# ReLU activation function + derivative
def ReLU(z):
    return np.maximum(0, z)

def ReLU_derivative(z):
    return np.where(z > 0, 1, 0)

# Softmax activation function: Computes probabilities for multiple classes using 'z' values
def Softmax(z):
    exp_z = np.exp(z - np.max(z, axis=0, keepdims=True))  # Avoid Overflow
    return exp_z / np.sum(exp_z, axis=0, keepdims=True)