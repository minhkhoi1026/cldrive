//{"Slices":8,"apodArray":4,"apodArraySize":5,"dDest":1,"dSource":0,"delays":3,"inputL":6,"inputS":7,"outputL":9,"outputS":10,"usedLines":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckDAS(global float* dSource, global float* dDest, global unsigned short* usedLines, global unsigned short* delays, constant float* apodArray, unsigned short apodArraySize, unsigned int inputL, unsigned int inputS, unsigned int Slices, unsigned int outputL, unsigned int outputS) {
  unsigned int globalPosX = get_global_id(0);
  unsigned int globalPosY = get_global_id(1);
  unsigned int globalPosZ = get_global_id(2);

  if (globalPosX < outputL && globalPosY < outputS && globalPosZ < Slices) {
    float l_i = (float)globalPosX / (float)outputL * (float)inputL;

    unsigned short curUsedLines = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX)];
    unsigned short minLine = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX + 1)];
    unsigned short maxLine = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX + 2)];

    float apod_mult = (float)apodArraySize / (float)curUsedLines;

    unsigned short Delay = 0;

    float output = 0;
    float mult = 0;

    for (short l_s = minLine; l_s < maxLine; ++l_s) {
      Delay = delays[hook(3, globalPosY * (outputL / 2) + (int)(fabs(l_s - l_i) / (float)inputL * (float)outputL))];
      if (Delay < inputS && Delay >= 0) {
        output += apodArray[hook(4, (int)((l_s - minLine) * apod_mult))] * dSource[hook(0, (int)(globalPosZ * inputL * inputS + Delay * inputL + l_s))];
      } else
        --curUsedLines;
    }

    dDest[hook(1, globalPosZ * outputL * outputS + globalPosY * outputL + globalPosX)] = output / (float)curUsedLines;
  }
}