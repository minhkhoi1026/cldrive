//{"Output":23,"bias":9,"biasWeightsOffset":6,"bwCellStates":14,"bwFgDeltas":20,"bwIgDeltas":18,"bwNiDeltas":16,"bwOgDeltas":22,"bwOutputs":12,"cellStates":24,"effLayerCLSize":1,"fwCellStates":13,"fwFgDeltas":19,"fwIgDeltas":17,"fwNiDeltas":15,"fwOgDeltas":21,"fwOutputs":11,"internalWeightsOffset":7,"layerSize":0,"niagDeltasLut":26,"niagDeltasLut[weightTypeY + (isBwStateWeight ? 4 : 0)]":25,"parallelSequences":4,"patternsCount":5,"peepholeWeightsOffset":8,"plOutputs":10,"precLayerCLSize":2,"timestepDistance":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float boundRange(float x, float lowerLimit, float upperLimit) {
  return (x < lowerLimit ? lowerLimit : (x > upperLimit ? upperLimit : x));
}

float Logistic_fn(float x) {
  if (x < 88.722839f) {
    if (x > -88.722839f)
      return (float)1.0 / ((float)1.0 + exp(-x));
    else
      return 0;
  }

  return 1;
}

float Maxmin1_fn(float x) {
  return ((float)2.0 * Logistic_fn(x) - (float)1.0);
}

float Tanh_fn(float x) {
  return Maxmin1_fn((float)2.0 * x);
}

float Identity_fn(float x) {
  return x;
}

float Tanh_deriv(float y) {
  return (float)1.0 - (y * y);
}
float Logistic_deriv(float y) {
  return y * ((float)1.0 - y);
}
float Identity_deriv(float y) {
  return 1;
}
float safeExp(float x) {
  if (x <= -1e30)
    return 0;
  else if (x >= 88.722839f)
    return 3.4028235e+038f;
  else
    return exp(x);
}

float limitedError(float error) {
  return boundRange(error, -1.0, +1.0);
}

kernel void ll_computeWeightUpdateFn(int layerSize, int effLayerCLSize, int precLayerCLSize, int timestepDistance, int parallelSequences, int patternsCount, int biasWeightsOffset, int internalWeightsOffset, int peepholeWeightsOffset, float bias, global const float* plOutputs, global const float* fwOutputs, global const float* bwOutputs, global const float* fwCellStates, global const float* bwCellStates, global const float* fwNiDeltas, global const float* bwNiDeltas, global const float* fwIgDeltas, global const float* bwIgDeltas, global const float* fwFgDeltas, global const float* bwFgDeltas, global const float* fwOgDeltas, global const float* bwOgDeltas, global float* Output

) {
  int weightIdx = get_global_id(0);

  int inwc = layerSize * precLayerCLSize;
  int biwc = layerSize;
  int itwc = layerSize * effLayerCLSize;
  int pewc = layerSize;

  int weightType = (int)(weightIdx >= 0 + 1 * inwc) + (int)(weightIdx >= 0 + 2 * inwc) + (int)(weightIdx >= 0 + 3 * inwc) + (int)(weightIdx >= 0 + 4 * inwc) + (int)(weightIdx >= biasWeightsOffset + 1 * biwc) + (int)(weightIdx >= biasWeightsOffset + 2 * biwc) + (int)(weightIdx >= biasWeightsOffset + 3 * biwc) + (int)(weightIdx >= biasWeightsOffset + 4 * biwc) + (int)(weightIdx >= internalWeightsOffset + 1 * itwc) + (int)(weightIdx >= internalWeightsOffset + 2 * itwc) + (int)(weightIdx >= internalWeightsOffset + 3 * itwc) + (int)(weightIdx >= internalWeightsOffset + 4 * itwc) * 2 + (int)(weightIdx >= peepholeWeightsOffset + 1 * pewc) + (int)(weightIdx >= peepholeWeightsOffset + 2 * pewc);

  int weightTypeX = weightType & 0xC;
  int weightTypeY = weightType & 0x3;

  global const float* offOutputs;
  int tgtBlockIdx;
  int offOutputsInc;
  bool skipFirstPattern = false;
  bool skipLastPattern = false;
  bool isBwStateWeight;

  switch (weightTypeX) {
    case 0x0: {
      {
        int inputWeightIdx = weightIdx;
        int plBlockIdx = inputWeightIdx % precLayerCLSize;
        int blockIdx = (inputWeightIdx - weightTypeY * (biasWeightsOffset / 4)) / precLayerCLSize;

        isBwStateWeight = (blockIdx >= effLayerCLSize);
        if (isBwStateWeight)
          blockIdx -= effLayerCLSize;

        tgtBlockIdx = blockIdx;
        offOutputs = &plOutputs[hook(10, plBlockIdx)];
        offOutputsInc = precLayerCLSize;
      }
    } break;

    case 0x4: {
      {
        int biasWeightIdx = weightIdx - biasWeightsOffset;
        int blockIdx = biasWeightIdx - weightTypeY * layerSize;

        isBwStateWeight = (blockIdx >= effLayerCLSize);
        if (isBwStateWeight)
          blockIdx -= effLayerCLSize;

        tgtBlockIdx = blockIdx;
        offOutputs = 0;
        offOutputsInc = 0;
      }
    } break;

    case 0x8: {
      {
        int internalWeightIdx = weightIdx - internalWeightsOffset;
        int srcBlockIdx = internalWeightIdx % effLayerCLSize;
        int blockIdx = internalWeightIdx / effLayerCLSize - weightTypeY * layerSize;

        isBwStateWeight = (blockIdx >= effLayerCLSize);
        if (isBwStateWeight)
          blockIdx -= effLayerCLSize;

        tgtBlockIdx = blockIdx;
        offOutputs = (isBwStateWeight ? &bwOutputs[hook(12, srcBlockIdx)] : &fwOutputs[hook(11, srcBlockIdx)]);
        offOutputsInc = effLayerCLSize;

        if (isBwStateWeight) {
          offOutputs += timestepDistance;
          skipLastPattern = true;
        } else {
          offOutputs -= timestepDistance;
          skipFirstPattern = true;
        }
      }
    } break;

    default: {
      {
        int peepholeWeightIdx = weightIdx - peepholeWeightsOffset;
        int blockIdx = peepholeWeightIdx - (weightTypeY - 1) * layerSize;

        isBwStateWeight = (blockIdx >= effLayerCLSize);
        if (isBwStateWeight)
          blockIdx -= effLayerCLSize;

        global const float* cellStates = (isBwStateWeight ? bwCellStates : fwCellStates);

        int timeShift;
        if (weightTypeY == 0x3) {
          timeShift = 0;
        } else {
          if (isBwStateWeight) {
            timeShift = timestepDistance;
            skipLastPattern = true;
          } else {
            timeShift = -timestepDistance;
            skipFirstPattern = true;
          }
        }

        tgtBlockIdx = blockIdx;
        offOutputs = &cellStates[hook(24, blockIdx + timeShift)];
        offOutputsInc = effLayerCLSize;
      }
    } break;
  }

  global const float* niagDeltasLut[] = {fwNiDeltas, fwIgDeltas, fwFgDeltas, fwOgDeltas, bwNiDeltas, bwIgDeltas, bwFgDeltas, bwOgDeltas};

  global const float* offDeltas = &niagDeltasLut[hook(26, weightTypeY + (isBwStateWeight ? 4 : 0))][hook(25, tgtBlockIdx)];

  if (skipFirstPattern) {
    offOutputs += parallelSequences * offOutputsInc;
    offDeltas += parallelSequences * effLayerCLSize;
  }

  int numPatterns = patternsCount;
  if (skipFirstPattern || skipLastPattern)
    numPatterns -= parallelSequences;

  float wu = 0;
  for (int i = 0; i < numPatterns; ++i) {
    wu += (offOutputs ? *offOutputs : bias) * *offDeltas;

    offOutputs += offOutputsInc;
    offDeltas += effLayerCLSize;
  }

  Output[hook(23, weightIdx)] = wu;
}