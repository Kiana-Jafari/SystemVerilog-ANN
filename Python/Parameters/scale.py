import numpy as np

# Save weights & biases in a dictionary

parameters = {

    'W1': np.array([
        [0.05276146, 0.04545019],
        [0.87860578, 1.4938967 ],
        [0.04193307, 0.03875046],
        [0.84913852, 1.46507294]

    ]),

    'b1': np.array([
        [-0.0500322 ],
        [ 0.93571265],
        [-0.05000003],
        [ 0.90332097]

    ]),

    'W2': np.array([
        [-0.0343271,   1.42355861, -0.05331349,  1.46707236],
        [ 0.01890401, -1.42651996,  0.0436103,  -1.45686225]

    ]),

    'b2': np.array([
        [-1.20539659],
        [ 1.20539659]
    ])
}

SCALE = 2**12  # 2^12 = 4096

def float_to_fixed(x):
    return np.round(x * SCALE).astype(np.int16)

# Apply to all weights and biases
W1_fixed = float_to_fixed(parameters['W1'])
b1_fixed = float_to_fixed(parameters['b1'])
W2_fixed = float_to_fixed(parameters['W2'])
b2_fixed = float_to_fixed(parameters['b2'])

# Apply quantization to the X_test (for HDL)
# X_test_fixed = float_to_fixed(X_test)

print(
    'W1:\n', W1_fixed,
    '\nb1:\n', b1_fixed, 
    '\nW2:\n', W2_fixed, 
    '\nb2:\n', b2_fixed)

# W1:
#  [[ 216  186]
#  [3599 6119]
#  [ 172  159]
#  [3478 6001]] 
# b1:
#  [[-205]
#  [3833]
#  [-205]
#  [3700]] 
# W2:
#  [[ -141  5831  -218  6009]
#  [   77 -5843   179 -5967]] 
# b2:
#  [[-4937]
#  [ 4937]]