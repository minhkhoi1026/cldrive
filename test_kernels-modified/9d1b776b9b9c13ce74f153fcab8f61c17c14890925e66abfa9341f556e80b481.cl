//{"Xweight":6,"cellStateErrors":12,"cellStates":7,"checkPatType":21,"effLayerCLSize":0,"fgActs":10,"fgDeltas":15,"fgPeepWeights":24,"fgPeepWeights_offset":4,"firstCall":19,"igActs":9,"igDeltas":14,"igPeepWeights":23,"igPeepWeights_offset":3,"lastCall":20,"niActs":8,"niDeltas":13,"offset":18,"ogActs":11,"ogDeltas":16,"ogPeepWeights":22,"ogPeepWeights_offset":5,"outputErrs":17,"patTypes":2,"prevOutputDistance":1}
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

kernel void ll_computeBlockErrorsFn(int effLayerCLSize, int prevOutputDistance, global char* patTypes, int igPeepWeights_offset, int fgPeepWeights_offset, int ogPeepWeights_offset, global const float* Xweight, global const float* cellStates, global const float* niActs, global const float* igActs, global const float* fgActs, global const float* ogActs, global float* cellStateErrors, global float* niDeltas, global float* igDeltas, global float* fgDeltas, global float* ogDeltas, global float* outputErrs, int offset, int firstCall, int lastCall, int checkPatType) {
  global float* igPeepWeights = &Xweight[hook(6, igPeepWeights_offset)];
  global float* fgPeepWeights = &Xweight[hook(6, fgPeepWeights_offset)];
  global float* ogPeepWeights = &Xweight[hook(6, ogPeepWeights_offset)];

  int outputIdx = get_global_id(0) + offset;
  float outputErr = outputErrs[hook(17, outputIdx)];

  if (checkPatType == 1) {
    int patIdx = outputIdx / effLayerCLSize;
    if (patTypes[hook(2, patIdx)] == 0) {
      niDeltas[hook(13, outputIdx)] = 0;
      igDeltas[hook(14, outputIdx)] = 0;
      fgDeltas[hook(15, outputIdx)] = 0;
      ogDeltas[hook(16, outputIdx)] = 0;
      cellStateErrors[hook(12, outputIdx)] = 0;
      return;
    }
  }

  int blockIdx = outputIdx % effLayerCLSize;

  float niAct = niActs[hook(8, outputIdx)];
  float igAct = igActs[hook(9, outputIdx)];
  float ogAct = ogActs[hook(11, outputIdx)];
  float cellState = cellStates[hook(7, outputIdx)];

  float ogDelta = Logistic_deriv(ogAct) * Tanh_fn(cellState) * outputErr;

  float ogPeepWeight = ogPeepWeights[hook(22, blockIdx)];
  float cellStateErr = ogAct * Tanh_deriv(Tanh_fn(cellState)) * outputErr + ogPeepWeight * ogDelta;

  if (!(firstCall == 1)) {
    float nextFgAct = fgActs[hook(10, outputIdx - prevOutputDistance)];
    float nextCellStateErr = cellStateErrors[hook(12, outputIdx - prevOutputDistance)];
    float nextIgDelta = igDeltas[hook(14, outputIdx - prevOutputDistance)];
    float nextFgDelta = fgDeltas[hook(15, outputIdx - prevOutputDistance)];

    float igPeepWeight = igPeepWeights[hook(23, blockIdx)];
    float fgPeepWeight = fgPeepWeights[hook(24, blockIdx)];

    cellStateErr += nextFgAct * nextCellStateErr + igPeepWeight * nextIgDelta + fgPeepWeight * nextFgDelta;
  }

  float niDelta = igAct * Tanh_deriv(niAct) * cellStateErr;

  float fgDelta = 0;

  if (!(lastCall == 1)) {
    float fgAct = fgActs[hook(10, outputIdx)];
    float prevCellState = cellStates[hook(7, outputIdx + prevOutputDistance)];

    fgDelta = Logistic_deriv(fgAct) * prevCellState * cellStateErr;
  }

  float igDelta = Logistic_deriv(igAct) * niAct * cellStateErr;

  niDeltas[hook(13, outputIdx)] = limitedError(niDelta);
  igDeltas[hook(14, outputIdx)] = limitedError(igDelta);
  fgDeltas[hook(15, outputIdx)] = limitedError(fgDelta);
  ogDeltas[hook(16, outputIdx)] = limitedError(ogDelta);
  cellStateErrors[hook(12, outputIdx)] = cellStateErr;
}