//{"Slices":8,"apodArray":4,"apodArraySize":5,"dDest":1,"dSource":0,"elementHeights":2,"elementPositions":3,"horizontalExtent":12,"inputL":6,"inputS":7,"isPAImage":14,"mult":13,"outputL":9,"outputS":10,"totalSamples_i":11,"usedLines":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckDAS_g(global float* dSource, global float* dDest, global float* elementHeights, global float* elementPositions, constant float* apodArray, unsigned short apodArraySize, unsigned int inputL, unsigned int inputS, int Slices, int outputL, int outputS, float totalSamples_i, float horizontalExtent, float mult, char isPAImage, global unsigned short* usedLines) {
  int globalPosX = get_global_id(0);
  int globalPosY = get_global_id(1);
  int globalPosZ = get_global_id(2);

  if (globalPosX < outputL && globalPosY < outputS && globalPosZ < Slices) {
    int AddSample = 0;
    float l_p = 0;
    float s_i = 0;

    float apod_mult = 1;

    float output = 0;

    l_p = (float)globalPosX / outputL * horizontalExtent;
    s_i = (float)globalPosY / outputS * totalSamples_i;

    unsigned short curUsedLines = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX)];
    unsigned short minLine = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX + 1)];
    unsigned short maxLine = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX + 2)];

    apod_mult = (float)apodArraySize / curUsedLines;

    for (int l_s = minLine; l_s < maxLine; ++l_s) {
      AddSample = (int)sqrt(pow(s_i - elementHeights[hook(2, l_s)] * mult, 2) + pow(mult * (l_p - elementPositions[hook(3, l_s)]), 2)) + (1 - isPAImage) * s_i;
      if (AddSample < inputS && AddSample >= 0)
        output += dSource[hook(0, (int)(globalPosZ * inputL * inputS + l_s + AddSample * inputL))] * apodArray[hook(4, (int)((l_s - minLine) * apod_mult))];
      else
        --curUsedLines;
    }
    dDest[hook(1, globalPosZ * outputL * outputS + globalPosY * outputL + globalPosX)] = output / curUsedLines;
  }
}