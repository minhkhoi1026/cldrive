//{"actual":5,"flatSpot":19,"globalError":17,"gradients":15,"ideal":4,"idealAll":2,"idealLength":3,"inputAll":0,"inputCount":11,"inputLength":1,"layerCounts":9,"layerDelta":16,"layerFeedCounts":10,"layerIndex":8,"layerOutput":6,"layerSums":7,"layeroutput":20,"outputCount":12,"setSize":18,"weightIndex":13,"weights":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void UpdateError(float* globalError, int setSize, float* actual, float* ideal) {
  int actualLength = sizeof(actual) / sizeof(actual[hook(5, 0)]);
  for (int i = 0; i < actualLength; i++) {
    float delta = ideal[hook(4, i)] - actual[hook(5, i)];
    globalError[hook(17, 0)] += delta * delta;
  }

  setSize += sizeof(ideal) / sizeof(ideal[hook(4, 0)]);
}

float DerivativeFunction(float b, float a) {
  return a * (1.0 - a);
}

void Sigmoid(float* layeroutput, int outputIndex, int outputSize) {
  for (int i = outputIndex; i < outputIndex + outputSize; i++) {
    layeroutput[hook(20, i)] = 1.0 / (1.0 + exp(-layeroutput[hook(20, i)]));
  }
}

kernel void Train(global float* inputAll, global int* inputLength, global float* idealAll, global int* idealLength, global float* ideal, global float* actual,

                  global float* layerOutput, global float* layerSums, global int* layerIndex, global int* layerCounts, global int* layerFeedCounts, global int* inputCount, global int* outputCount,

                  global int* weightIndex, global float* weights,

                  global float* gradients, global float* layerDelta,

                  global float* globalError, global int* setSize, global float* flatSpot) {
  int globalId = get_global_id(0);
  int globalSize = get_global_size(0);

  int inputStart = globalId * inputLength[hook(1, 0)];

  int idealStart = globalId * idealLength[hook(3, 0)];

  int layerOutputLength = sizeof(layerOutput) / sizeof(layerOutput[hook(6, 0)]);
  int layerCountsLength = sizeof(layerCounts) / sizeof(layerCounts[hook(9, 0)]);
  int layerIndexLength = sizeof(layerIndex) / sizeof(layerIndex[hook(8, 0)]);

  int sourceIndex = layerOutputLength - layerCounts[hook(9, layerCountsLength - 1)];
  for (int i = sourceIndex; i <= inputCount[hook(11, 0)]; i++) {
    layerOutput[hook(6, i)] = inputAll[hook(0, inputStart + i - sourceIndex)];
  }

  for (int i = layerIndexLength - 1; i > 0; i--) {
    int inputIndex = layerIndex[hook(8, i)];
    int outputIndex = layerIndex[hook(8, i - 1)];
    int inputSize = layerCounts[hook(9, i)];
    int outputSize = layerFeedCounts[hook(10, i - 1)];
    int index = weightIndex[hook(13, i - 1)];
    int limitX = outputIndex + outputSize;
    int limitY = inputIndex + inputSize;

    for (int x = outputIndex; x < limitX; x++) {
      float sum = 0;
      for (int y = inputIndex; y < limitY; y++) {
        sum += weights[hook(14, index++)] * layerOutput[hook(6, y)];
      }
      layerOutput[hook(6, x)] = sum;
      layerSums[hook(7, x)] = sum;
    }

    Sigmoid(&layerOutput, outputIndex, outputSize);
  }

  for (int i = 0; i <= idealLength[hook(3, 0)]; i++) {
    ideal[hook(4, i)] = idealAll[hook(2, idealStart + i)];
  }

  for (int i = 0; i < outputCount[hook(12, 0)]; i++) {
    actual[hook(5, i)] = layerOutput[hook(6, i)];
  }

  UpdateError(&globalError, setSize[hook(18, 0)], &actual, &ideal);

  for (int i = 0; i < layerCountsLength - 1; i++) {
    int fromLayerIndex = layerIndex[hook(8, i + 1)];
    int toLayerIndex = layerIndex[hook(8, i)];
    int fromLayerSize = layerCounts[hook(9, i + 1)];
    int toLayerSize = layerFeedCounts[hook(10, i)];

    int index = weightIndex[hook(13, i)];

    float currentFlatSpot = flatSpot[hook(19, i + 1)];
    int yi = fromLayerIndex;
    for (int y = 0; y < fromLayerSize; y++) {
      float output = layerOutput[hook(6, yi)];
      float sum = 0;
      int xi = toLayerIndex;
      int wi = index + y;
      for (int x = 0; x < toLayerSize; x++) {
        gradients[hook(15, wi)] += output * layerDelta[hook(16, xi)];
        sum += weights[hook(14, wi)] * layerDelta[hook(16, xi)];
        wi += fromLayerSize;
        xi++;
      }
      layerDelta[hook(16, yi)] = sum * (DerivativeFunction(layerSums[hook(7, yi)], layerOutput[hook(6, yi)]) + currentFlatSpot);
      yi++;
    }
  }
}