//{"numKnotsU":3,"numKnotsV":4,"outputBuffer":2,"parameter":0,"samplingValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evaluateSphere(global const float* parameter, global const float* samplingValues, global float* outputBuffer, int numKnotsU, int numKnotsV) {
  int numElements = numKnotsU * numKnotsV;

  int iGID = get_global_id(0);

  if (iGID >= numElements) {
    return;
  }

  float u = (samplingValues[hook(1, (iGID * 2))] * numKnotsU);
  float v = (samplingValues[hook(1, (iGID * 2) + 1)] * numKnotsV);
  float angle1 = (float)v / (numKnotsV)*2 * 3.14159265358979323846264338327950288f;
  float angle2 = (float)u / (numKnotsU - 1) * 3.14159265358979323846264338327950288f;

  float helper = parameter[hook(0, 0)] * sin(angle2);

  outputBuffer[hook(2, (iGID * 3))] = (float)helper * cos(angle1);
  outputBuffer[hook(2, (iGID * 3) + 1)] = (float)helper * sin(angle1);
  outputBuffer[hook(2, (iGID * 3) + 2)] = (float)parameter[hook(0, 0)] * cos(angle2);
}