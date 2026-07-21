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

Implemented and verified:

- Q3.12 fixed-point representation
- Floating-point to fixed-point parameter quantization
- Fixed-point multiplication and scaling
- ReLU activation
- Argmax classification
- Fixed-point inference in Python

The fixed-point implementation achieved identical classification accuracy to the original floating-point model.

---

# SystemVerilog Hardware Implementation

The neural network has been implemented in SystemVerilog using two different hardware architectures:

- **Combinational implementation**
- **Sequential FSM-based implementation**

Both implementations use the same trained Q3.12 fixed-point parameters and produce identical classification results.

---

## Combinational Architecture

The combinational implementation computes the complete inference path within a single evaluation of the combinational logic.

Characteristics:

- Fully parallel computation
- No clock cycles required for inference
- Lower latency
- Higher hardware resource utilization
- Simpler control logic

---

## Sequential Architecture

The sequential implementation reuses a single Multiply-Accumulate (MAC) datapath across all neurons using a Finite State Machine (FSM).

The sequential architecture consists of the following states:

- **IDLE** – Waits for the `start` signal and initializes the control registers.
- **HIDDEN_MAC** – Performs the MAC operations for one hidden neuron.
- **HIDDEN_STORE** – Adds the bias, applies the ReLU activation, and stores the hidden activation.
- **OUTPUT_MAC** – Performs the MAC operations for one output neuron.
- **OUTPUT_STORE** – Adds the output bias and stores the output logits.
- **DONE** – Computes the final prediction using Argmax and asserts the `done` signal.

The FSM allows a single MAC unit to be shared among all neurons, significantly reducing hardware resource utilization.

---

## Sequential Inference Latency

The sequential implementation requires multiple clock cycles to complete one inference.

|Component|Formula|Clock Cycles|
|---------|-------|-----------:|
|Hidden Layer|4 × (2 MAC + 1 STORE)|12|
|Output Layer|2 × (4 MAC + 1 STORE)|10|
|DONE State|1|1|
|**Total**|**12 + 10 + 1**|**23**|

---

## Verification

Both hardware architectures have been verified using SystemVerilog testbenches.

Verification includes:

- Applying all 57 unseen testing samples
- Comparing predictions against the ground-truth labels
- Reporting the overall classification accuracy
- Comparing the SystemVerilog outputs with the Python fixed-point implementation

The sequential implementation produces identical predictions to the combinational implementation and the Python fixed-point model.

---

## Hardware Design Trade-offs

|Combinational|Sequential|
|-------------|----------|
|Single-cycle inference|Multi-cycle inference|
|Higher throughput|Lower throughput|
|Higher hardware utilization|Lower hardware utilization|
|Higher power consumption|Lower power consumption|
|Simpler control logic|FSM-controlled execution|
|Multiple MAC units|Single shared MAC unit|

The sequential implementation demonstrates the trade-off between execution speed and hardware resource utilization by reusing arithmetic hardware across multiple clock cycles.

A summary of the model perfomance on the test set can be found on <a href='https://github.com/Kiana-Jafari/SystemVerilog-ANN/blob/main/docs/Performance/performance.csv'>docs/Performance/Performance.csv</a>

---

## Future Work

Possible future improvements include:

- Storing weights and biases inside ROM memories
- Reading testing samples directly from memory
- Parameterizing the network architecture for arbitrary layer sizes
- FPGA synthesis and resource utilization analysis
- Timing analysis and performance optimization