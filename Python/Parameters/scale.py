import numpy as np

# Save weights & biases in a dictionary

parameters = {

    'W1': np.array([
        [-1.12481838, -1.58392813],
        [-0.01853132, -0.01098436],
        [ 0.94074928,  1.67657521],
        [ 0.95129257,  1.62229048]

    ]),

    'b1': np.array([
        [ 0.95585181],
        [-0.0544634 ],
        [ 1.36148988],
        [ 1.34625025]

    ]),

    'W2': np.array([
        [-1.41972548,  0.02798524,  1.56377782,  1.56203395],
        [ 1.43995558, -0.03274611, -1.56375944, -1.56859512]

    ]),

    'b2': np.array([
        [-0.4660371 ],
        [ 0.44073646]
    ])
}

SCALE = 2**11  # 2^11 = 2048

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
#  [[-2304 -3244]
#  [  -38   -22]
#  [ 1927  3434]
#  [ 1948  3322]] 
# b1:
#  [[1958]
#  [-112]
#  [2788]
#  [2757]] 
# W2:
#  [[-2908    57  3203  3199]
#  [ 2949   -67 -3203 -3212]] 
# b2:
#  [[-954]
#  [ 903]]