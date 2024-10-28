//{"Xweights":3,"bias":2,"cellStates":12,"checkPatType":18,"effLayerCLSize":0,"fgActs":15,"fgBiasWeights":23,"fgBias_offset":6,"fgPeepWeights":26,"fgPeep_offset":9,"firstCall":17,"igActs":14,"igBiasWeights":22,"igBias_offset":5,"igPeepWeights":25,"igPeep_offset":8,"niActs":13,"niBiasWeights":21,"niBias_offset":4,"ogActs":16,"ogBiasWeights":24,"ogBias_offset":7,"ogPeepWeights":27,"ogPeep_offset":10,"output_offset":20,"outputs":19,"patTypes":11,"prevOutputDistance":1}
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

kernel void ll_computeBlockOutputFn(int effLayerCLSize, int prevOutputDistance, float bias, global float* Xweights, int niBias_offset, int igBias_offset, int fgBias_offset, int ogBias_offset, int igPeep_offset, int fgPeep_offset, int ogPeep_offset, global char* patTypes, global float* cellStates, global float* niActs, global float* igActs, global float* fgActs, global float* ogActs, int firstCall, int checkPatType, global float* outputs, int output_offset) {
  global float* niBiasWeights = &Xweights[hook(3, niBias_offset)];
  global float* igBiasWeights = &Xweights[hook(3, igBias_offset)];
  global float* fgBiasWeights = &Xweights[hook(3, fgBias_offset)];
  global float* ogBiasWeights = &Xweights[hook(3, ogBias_offset)];

  global float* igPeepWeights = &Xweights[hook(3, igPeep_offset)];
  global float* fgPeepWeights = &Xweights[hook(3, fgPeep_offset)];
  global float* ogPeepWeights = &Xweights[hook(3, ogPeep_offset)];
  int outputIdx = get_global_id(0) + output_offset;

  if (checkPatType == 1) {
    int patIdx = outputIdx / effLayerCLSize;
    if (patTypes[hook(11, patIdx)] == 0) {
      if (prevOutputDistance > 0)
        cellStates[hook(12, outputIdx)] = 0;

      outputs[hook(19, outputIdx)] = 0;
      return;
    }
  }

  int blockIdx = outputIdx % effLayerCLSize;

  float niAct = niActs[hook(13, outputIdx)];
  float igAct = igActs[hook(14, outputIdx)];
  float fgAct = fgActs[hook(15, outputIdx)];
  float ogAct = ogActs[hook(16, outputIdx)];

  niAct += bias * niBiasWeights[hook(21, blockIdx)];
  igAct += bias * igBiasWeights[hook(22, blockIdx)];
  fgAct += bias * fgBiasWeights[hook(23, blockIdx)];
  ogAct += bias * ogBiasWeights[hook(24, blockIdx)];

  if (!(firstCall == 1)) {
    float prevCellState = cellStates[hook(12, outputIdx + prevOutputDistance)];

    igAct += prevCellState * igPeepWeights[hook(25, blockIdx)];
    fgAct += prevCellState * fgPeepWeights[hook(26, blockIdx)];
  }

  niAct = Tanh_fn(niAct);
  igAct = Logistic_fn(igAct);
  fgAct = Logistic_fn(fgAct);

  niActs[hook(13, outputIdx)] = niAct;
  igActs[hook(14, outputIdx)] = igAct;
  fgActs[hook(15, outputIdx)] = fgAct;

  float cellState = niAct * igAct;

  if (!(firstCall == 1))
    cellState += cellStates[hook(12, outputIdx + prevOutputDistance)] * fgAct;

  cellStates[hook(12, outputIdx)] = cellState;

  ogAct += cellState * ogPeepWeights[hook(27, blockIdx)];
  ogAct = Logistic_fn(ogAct);
  ogActs[hook(16, outputIdx)] = ogAct;

  outputs[hook(19, outputIdx)] = Tanh_fn(cellState) * ogAct;
}