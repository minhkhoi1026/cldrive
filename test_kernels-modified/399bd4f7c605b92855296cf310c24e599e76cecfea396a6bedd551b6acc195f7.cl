//{"numKnotsU":3,"numKnotsV":4,"outputBuffer":2,"parameter":0,"samplingValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evaluateCylinder(global const float* parameter, global const float* samplingValues, global float* outputBuffer, int numKnotsU, int numKnotsV) {
  int numElements = numKnotsU * numKnotsV;

  int iGID = get_global_id(0);

  if (iGID >= numElements) {
    return;
  }

  int gridWidth = (int)sqrt((float)numElements);

  float u = (samplingValues[hook(1, (iGID * 2))] * numKnotsU);
  float v = (samplingValues[hook(1, (iGID * 2) + 1)] * numKnotsV);

  float angle = (float)v / (numKnotsV - 1) * 2 * 3.14159265358979323846264338327950288f;

  outputBuffer[hook(2, (iGID * 3))] = (float)(((-parameter[hook(0, 0)] + parameter[hook(0, 0)]) / 2) + 0.5 * (parameter[hook(0, 0)] - (-parameter[hook(0, 0)])) * (float)cos(angle));
  outputBuffer[hook(2, (iGID * 3) + 1)] = (float)(((-parameter[hook(0, 1)] + parameter[hook(0, 1)]) / 2) + 0.5 * (parameter[hook(0, 1)] - (-parameter[hook(0, 1)])) * sin(angle));
  outputBuffer[hook(2, (iGID * 3) + 2)] = (float)(0.5 * parameter[hook(0, 2)] - (0.5 * parameter[hook(0, 2)] - (-0.5 * parameter[hook(0, 2)])) * ((float)u / (numKnotsU - 1)));
}