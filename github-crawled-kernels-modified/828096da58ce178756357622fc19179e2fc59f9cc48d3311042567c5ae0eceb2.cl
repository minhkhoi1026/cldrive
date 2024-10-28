//{"actual":19,"contextTargetOffset":10,"contextTargetSize":11,"error":20,"flatSpot":17,"globalError":14,"gradients":18,"ideal":1,"input":0,"inputCount":12,"layerCounts":6,"layerDelta":16,"layerFeedCounts":7,"layerIndex":3,"layerOutput":4,"layerSums":5,"layeroutput":21,"output":22,"outputCount":13,"setSize":15,"significance":2,"weightIndex":8,"weights":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float DerivativeFunction(float b, float a) {
  return a * (1.0 - a);
}

void CalculateError(float* ideal, int* actual, float* error) {
  int actualLength = sizeof(actual) / sizeof(actual[hook(19, 0)]);

  for (int i = 0; i < actualLength; i++) {
    error[hook(20, i)] = ideal[hook(1, i)] - actual[hook(19, i)];
  }
}

void UpdateError(float* globalError, int setSize, float* actual, float* ideal, float* significance) {
  int actualLength = sizeof(actual) / sizeof(actual[hook(19, 0)]);
  for (int i = 0; i < actualLength; i++) {
    float delta = ideal[hook(1, i)] - actual[hook(19, i)];
    globalError[hook(14, 0)] += delta * delta;
  }

  setSize += sizeof(ideal) / sizeof(ideal[hook(1, 0)]);
}

void sigmoid(float* layeroutput, int outputIndex, int outputSize) {
  for (int i = outputIndex; i < outputIndex + outputSize; i++) {
    layeroutput[hook(21, i)] = 1.0 / (1.0 + exp(-layeroutput[hook(21, i)]));
  }
}

void ProcessLevel(int* layerIndex, float* layerOutput, float* layerSums, int* layerCounts, int* layerFeedCounts, int* weightIndex, float* weights, float* flatSpot, float* gradients, float* layerDelta) {
  int layerCountsLength = sizeof(layerCounts) / sizeof(layerCounts[hook(6, 0)]);
  for (int i = 0; i < layerCountsLength - 1; i++) {
    int fromLayerIndex = layerIndex[hook(3, i + 1)];
    int toLayerIndex = layerIndex[hook(3, i)];
    int fromLayerSize = layerCounts[hook(6, i + 1)];
    int toLayerSize = layerFeedCounts[hook(7, i)];

    int index = weightIndex[hook(8, i)];

    float currentFlatSpot = flatSpot[hook(17, i + 1)];
    int yi = fromLayerIndex;
    for (int y = 0; y < fromLayerSize; y++) {
      float output = layerOutput[hook(4, yi)];
      float sum = 0;
      int xi = toLayerIndex;
      int wi = index + y;
      for (int x = 0; x < toLayerSize; x++) {
        gradients[hook(18, wi)] += output * layerDelta[hook(16, xi)];
        sum += weights[hook(9, wi)] * layerDelta[hook(16, xi)];
        wi += fromLayerSize;
        xi++;
      }
      layerDelta[hook(16, yi)] = sum * (DerivativeFunction(layerSums[hook(5, yi)], layerOutput[hook(4, yi)]) + currentFlatSpot);
      yi++;
    }
  }
}

void FlatNetworkCompute(float* input, float* output, int* layerIndex, float* layerOutput, float* layerSums, int* layerCounts, int* layerFeedCounts, int* weightIndex, float* weights, int* contextTargetOffset, int* contextTargetSize, int* inputCount, int* outputCount) {
  int layerOutputLength = sizeof(layerOutput) / sizeof(layerOutput[hook(4, 0)]);
  int layerCountsLength = sizeof(layerCounts) / sizeof(layerCounts[hook(6, 0)]);
  int layerIndexLength = sizeof(layerIndex) / sizeof(layerIndex[hook(3, 0)]);

  int sourceIndex = layerOutputLength - layerCounts[hook(6, layerCountsLength - 1)];

  for (int i = sourceIndex; i <= inputCount[hook(12, 0)]; i++) {
    layerOutput[hook(4, i)] = input[hook(0, i - sourceIndex)];
  }

  for (int i = layerIndexLength - 1; i > 0; i--) {
    int inputIndex = layerIndex[hook(3, i)];
    int outputIndex = layerIndex[hook(3, i - 1)];
    int inputSize = layerCounts[hook(6, i)];
    int outputSize = layerFeedCounts[hook(7, i - 1)];
    int index = weightIndex[hook(8, i - 1)];
    int limitX = outputIndex + outputSize;
    int limitY = inputIndex + inputSize;

    for (int x = outputIndex; x < limitX; x++) {
      float sum = 0;
      for (int y = inputIndex; y < limitY; y++) {
        sum += weights[hook(9, index++)] * layerOutput[hook(4, y)];
      }
      layerOutput[hook(4, x)] = sum;
      layerSums[hook(5, x)] = sum;
    }

    sigmoid(&layerOutput, outputIndex, outputSize);

    int offset = contextTargetOffset[hook(10, i)];
    for (int x = 0; x < contextTargetSize[hook(11, i)]; x++) {
      layerOutput[hook(4, offset + x)] = layerOutput[hook(4, outputIndex + x)];
    }
  }

  int offset = contextTargetOffset[hook(10, 0)];

  for (int x = 0; x < contextTargetSize[hook(11, 0)]; x++) {
    layerOutput[hook(4, offset + x)] = layerOutput[hook(4, x)];
  }

  for (int i = 0; i < outputCount; i++) {
    output[hook(22, i)] = layerOutput[hook(4, i)];
  }
}

kernel void Process(global float* input, global float* ideal, global float* significance,

                    global int* layerIndex, global float* layerOutput, global float* layerSums, global int* layerCounts, global int* layerFeedCounts, global int* weightIndex, global float* weights, global int* contextTargetOffset, global int* contextTargetSize, global int* inputCount, global int* outputCount,

                    global float* globalError, global int* setSize,

                    global float* layerDelta,

                    global float* flatSpot, global float* gradients, global float* actual) {
  FlatNetworkCompute(&input, &actual, &layerIndex, &layerOutput, &layerSums, &layerCounts, &layerFeedCounts, &weightIndex, &weights, &contextTargetOffset, &contextTargetSize, &inputCount, &outputCount);

  UpdateError(&globalError, setSize[hook(15, 0)], &actual, &ideal, &significance);
  CalculateError(&ideal, &actual, &layerDelta);

  int actualLength = sizeof(actual) / sizeof(actual[hook(19, 0)]);
  for (int i = 0; i < actualLength; i++) {
    layerDelta[hook(16, i)] = (DerivativeFunction(layerSums[hook(5, i)], layerOutput[hook(4, i)]) + flatSpot[hook(17, 0)]) * layerDelta[hook(16, i)] * significance[hook(2, 0)];
  }

  ProcessLevel(&layerIndex, &layerOutput, &layerSums, &layerCounts, &layerFeedCounts, &weightIndex, &weights, &flatSpot, &gradients, &layerDelta);
}