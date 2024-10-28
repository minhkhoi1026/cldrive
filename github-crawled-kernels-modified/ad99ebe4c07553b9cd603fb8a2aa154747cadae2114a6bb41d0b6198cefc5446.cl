//{"numKnotsU":3,"numKnotsV":4,"outputBuffer":2,"parameter":0,"samplingValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evaluatePyramid(global const float* parameter, global const float* samplingValues, global float* outputBuffer, int numKnotsU, int numKnotsV) {
  int numElements = numKnotsU * numKnotsV;
  int iGID = get_global_id(0);
  if (iGID >= numElements) {
    return;
  }

  int gridWidth = (int)sqrt((float)numElements);

  float u = samplingValues[hook(1, (iGID * 2))];
  float v = (samplingValues[hook(1, (iGID * 2 + 1))] * numKnotsV) / (numKnotsV);

  float factor = u * numKnotsU / ((float)(numKnotsU - 1));
  float absCoorZ = -((-parameter[hook(0, 2)] + factor * (parameter[hook(0, 2)]))) / parameter[hook(0, 2)];

  float4 first;
  float4 second;
  float4 point;

  if (v <= 0.25) {
    first = (float4){-parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, -parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};
    second = (float4){parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, -parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};

  } else if (v <= 0.5) {
    v -= 0.25;
    first = (float4){parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, -parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};
    second = (float4){parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};

  } else if (v <= 0.75) {
    v -= 0.5;
    first = (float4){parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};
    second = (float4){-parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};

  } else {
    v -= 0.75;
    first = (float4){-parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};
    second = (float4){-parameter[hook(0, 0)] * parameter[hook(0, 3)] * absCoorZ, -parameter[hook(0, 1)] * parameter[hook(0, 4)] * absCoorZ, -absCoorZ, 0};
  }

  point = mix(first, second, (4.0 * v * numKnotsV / (float)(numKnotsV)));

  outputBuffer[hook(2, (iGID * 3))] = point.x;
  outputBuffer[hook(2, (iGID * 3) + 1)] = point.y;
  outputBuffer[hook(2, (iGID * 3) + 2)] = -absCoorZ * parameter[hook(0, 2)];
}