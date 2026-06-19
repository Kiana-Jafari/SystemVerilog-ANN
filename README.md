# SystemVerilog Implementation of Neural Network Inference

This document outlines a 2-4-2 neural network that has been trained using Python and implemented in SystemVerilog. The neural network utilizes Q3.12 fixed-point parameters to simulate the trained network in Python, and improve its performance and precision during inference.

## Dataset Overview

The model has been trained and validated using the `Breast Cancer Wisconsin Dataset`, a dataset used in the medical field for predicting breast cancer outcomes based on various attributes. The dataset can be found in the <a href='https://github.com/Kiana-Jafari/SystemVerilog-ANN/tree/main/Data'>Data</a> folder.

## Neural Network Architecture

The architecture of the neural network is composed of three layers, as described below:

- **Input Layer**: 2 neurons (representing the two input features, 'worst smoothness' & 'mean radius')
- **Hidden Layer**: 4 neurons (utilizing the ReLU activation function to introduce non-linearity)
- **Output Layer**: 2 neurons (employing the Softmax & Argmax function for output classification in Python, with Argmax used during inference to determine the predicted class in SV)

## Model Performance

The model achieved the following accuracy scores on the training, and testing sets as demonstrated below:
- **Training Accuracy**: 93.75%
- **Testing Accuracy**: 92.98%

A classification report has also been included to verify the model performance using other evaluation metrics as well:
|Info|precision|recall|f1-score|support|
|----|---------|------|--------|-------|
|malignant|0.90|0.90|0.90|21|
|benign|0.94|0.94|0.94|36|
|accuracy|||0.93|57|
|macro avg|0.92|0.92|0.92|57|
|weighted avg|0.93|0.93|0.93|57|

## Fixed Point Representation

The parameters of the neural network are represented in a Q3.12 fixed-point format. This choice of fixed-point representation ensures that the computations remain efficient for hardware implementation while maintaining the same accuracy in hardware.