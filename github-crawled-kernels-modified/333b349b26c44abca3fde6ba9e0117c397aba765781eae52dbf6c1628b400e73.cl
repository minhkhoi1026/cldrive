//{"numKnotsU":3,"numKnotsV":4,"outputBuffer":2,"parameter":0,"samplingValues":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evaluateBox(global const float* parameter, global const float* samplingValues, global float* outputBuffer, int numKnotsU, int numKnotsV) {
  int numElements = numKnotsU * numKnotsV;

  int iGID = get_global_id(0);
  if (iGID >= numElements) {
    return;
  }
  float u = (samplingValues[hook(1, (iGID * 2))]);
  float v = (samplingValues[hook(1, (iGID * 2) + 1)]);

  float4 firstTop;
  float4 secondTop;
  float4 firstBottom;
  float4 secondBottom;

  if (v <= 0.25) {
    firstTop = (float4){parameter[hook(0, 0)], parameter[hook(0, 1)], parameter[hook(0, 5)], 0};
    secondTop = (float4){parameter[hook(0, 3)], parameter[hook(0, 1)], parameter[hook(0, 5)], 0};

    firstBottom = (float4){parameter[hook(0, 0)], parameter[hook(0, 1)], parameter[hook(0, 2)], 0};
    secondBottom = (float4){parameter[hook(0, 3)], parameter[hook(0, 1)], parameter[hook(0, 2)], 0};

  } else if (v <= 0.5) {
    v -= 0.25;

    firstTop = (float4){parameter[hook(0, 3)], parameter[hook(0, 1)], parameter[hook(0, 5)], 0};
    secondTop = (float4){parameter[hook(0, 3)], parameter[hook(0, 4)], parameter[hook(0, 5)], 0};

    firstBottom = (float4){parameter[hook(0, 3)], parameter[hook(0, 1)], parameter[hook(0, 2)], 0};
    secondBottom = (float4){parameter[hook(0, 3)], parameter[hook(0, 4)], parameter[hook(0, 2)], 0};

  } else if (v <= 0.75) {
    v -= 0.5;

    firstTop = (float4){parameter[hook(0, 3)], parameter[hook(0, 4)], parameter[hook(0, 5)], 0};
    secondTop = (float4){parameter[hook(0, 0)], parameter[hook(0, 4)], parameter[hook(0, 5)], 0};

    firstBottom = (float4){parameter[hook(0, 3)], parameter[hook(0, 4)], parameter[hook(0, 2)], 0};
    secondBottom = (float4){parameter[hook(0, 0)], parameter[hook(0, 4)], parameter[hook(0, 2)], 0};

  } else {
    v -= 0.75;

    firstTop = (float4){parameter[hook(0, 0)], parameter[hook(0, 4)], parameter[hook(0, 5)], 0};
    secondTop = (float4){parameter[hook(0, 0)], parameter[hook(0, 1)], parameter[hook(0, 5)], 0};

    firstBottom = (float4){parameter[hook(0, 0)], parameter[hook(0, 4)], parameter[hook(0, 2)], 0};
    secondBottom = (float4){parameter[hook(0, 0)], parameter[hook(0, 1)], parameter[hook(0, 2)], 0};
  }

  float4 pointTop = mix(firstTop, secondTop, (4.0 * v));
  float4 pointBottom = mix(firstBottom, secondBottom, 4.0 * v);
  float4 point = mix(pointTop, pointBottom, 1.0 - u);

  outputBuffer[hook(2, (iGID * 3))] = point.x;
  outputBuffer[hook(2, (iGID * 3) + 1)] = point.y;
  outputBuffer[hook(2, (iGID * 3) + 2)] = point.z;
}