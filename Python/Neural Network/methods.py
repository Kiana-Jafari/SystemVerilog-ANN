from activation_functions import (ReLU, ReLU_derivative, Sigmoid)
import numpy as np

def initialize_parameters(input_size, first_hidden_size, output_size):

    W1 = np.random.randn(first_hidden_size, input_size) * 0.01  # Multiply by a small factor
    b1 = np.zeros((first_hidden_size, 1))

    W2 = np.random.randn(output_size, first_hidden_size) * 0.01
    b2 = np.zeros((output_size, 1))

    parameters = {'W1':W1,
                  'b1':b1,
                  'W2':W2,
                  'b2':b2}

    return parameters

def forward_propagation(X, parameters):

    # Retrieve weights and biases from parameters dictionary
    W1, b1 = parameters['W1'], parameters['b1']
    W2, b2 = parameters['W2'], parameters['b2']

    # Perform linear transformations and activation functions
    z1 = np.dot(W1, X) + b1
    a1 = ReLU(z1)
    z2 = np.dot(W2, a1) + b2
    a2 = Sigmoid(z2)

    forward_cache = {'z1':z1,
                     'a1':a1,
                     'z2':z2,
                     'a2':a2}

    return a2, forward_cache

def compute_cost(a2, y, parameters, penalty, epsilon=1e-8):

    # Get the model parameters (weights)
    W1 = parameters['W1']
    W2 = parameters['W2']

    # Number of examples in the dataset
    n = y.shape[1]

    # Compute log probabilities
    logprobs = np.multiply(y, np.log(a2)) + np.multiply((1 - y), np.log(1 - a2))
    cost = -np.mean(logprobs)

    # Compute regularization term
    regularized_cost = np.divide(penalty, np.multiply(2, n)) * (np.sum(np.square(W1)) + np.sum(np.square(W2)))
    total_cost = cost + regularized_cost

    return total_cost

def backward_propagation(X, y, parameters, forward_cache, penalty):

    W1 = parameters['W1']
    W2 = parameters['W2']

    z1 = forward_cache['z1']
    a1 = forward_cache['a1']
    z2 = forward_cache['z2']
    a2 = forward_cache['a2']

    m = X.shape[1]  # Number of training examples

    # gradients for output layer
    dZ2 = a2 - y
    dW2 = np.dot(dZ2, a1.T) / m + np.multiply(np.divide(penalty, m), W2)
    db2 = np.sum(dZ2, axis=1, keepdims=True) / m

    # gradients for the hidden layer
    dZ1 = np.dot(W2.T, dZ2) * ReLU_derivative(z1)
    dW1 = np.dot(dZ1, X.T) / m + np.multiply(np.divide(penalty, m), W1)
    db1 = np.sum(dZ1, axis=1, keepdims=True) / m

    gradients = {'dW1':dW1,
               'db1':db1,
               'dW2':dW2,
               'db2':db2}

    return gradients

def initialize_adam(parameters):

    # Define two empty dictionaries for `Momentum`, and `RMSprop`, respectively
    velocity = {}
    cache = {}

    # Initialize velocity and cache with zeros of the same shape as the parameter
    for key, value in parameters.items():
        velocity[key] = np.zeros_like(value)
        cache[key] = np.zeros_like(value)

    return velocity, cache

def update_parameters(parameters, gradients, velocity, cache, learning_rate, decay_rate, current_iteration, momentum_coefficient=0.9, rmsprop_coefficient=0.999, epsilon=1e-8):

    # beta1 and beta2 based on specified coefficients
    beta1 = momentum_coefficient
    beta2 = rmsprop_coefficient

    corrected_velocity = {}
    corrected_cache = {}

    # Compute decayed learning rate
    learning_rate_decay = learning_rate / (1 + decay_rate * current_iteration)

    # Update velocity with momentum term and cache with RMSprop term
    for parameter in parameters:

        velocity[parameter] = beta1 * velocity[parameter] + (1 - beta1) * gradients['d' + parameter]
        corrected_velocity[parameter] = velocity[parameter] / (1 - beta1)

        cache[parameter] = beta2 * cache[parameter] + (1 - beta2) * (gradients['d' + parameter] ** 2)
        corrected_cache[parameter] = cache[parameter] / (1 - beta2)

        parameters[parameter] -= learning_rate_decay * corrected_velocity[parameter] / (np.sqrt(corrected_cache[parameter]) + epsilon)

    return parameters, velocity, cache