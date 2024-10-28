//{"dDest":0,"inputL":2,"inputS":3,"outputL":4,"outputS":5,"partMult":1,"totalSamples_i":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckUsedLines(global unsigned short* dDest, float partMult, unsigned int inputL, unsigned int inputS, unsigned int outputL, unsigned int outputS, float totalSamples_i) {
  unsigned int globalPosX = get_global_id(0);
  unsigned int globalPosY = get_global_id(1);

  if (globalPosX < outputL && globalPosY < outputS) {
    float l_i = (float)globalPosX / outputL * inputL;
    float s_i = (float)globalPosY / (float)outputS * totalSamples_i;

    float part = partMult * s_i;
    if (part < 1)
      part = 1;

    unsigned short maxLine = min((l_i + part) + 1, (float)inputL);
    unsigned short minLine = max((l_i - part), 0.0f);

    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX)] = (maxLine - minLine);
    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX + 1)] = minLine;
    dDest[hook(0, globalPosY * 3 * outputL + 3 * globalPosX + 2)] = maxLine;
  }
}