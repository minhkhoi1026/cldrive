//{"Slices":8,"apodArray":4,"apodArraySize":5,"dDest":1,"dSource":0,"elementHeights":2,"elementPositions":3,"horizontalExtent":12,"inputL":6,"inputS":7,"isPAImage":14,"mult":13,"outputL":9,"outputS":10,"totalSamples_i":11,"usedLines":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckDMAS_g(global float* dSource, global float* dDest, global float* elementHeights, global float* elementPositions, constant float* apodArray, unsigned short apodArraySize, unsigned int inputL, unsigned int inputS, int Slices, int outputL, int outputS, float totalSamples_i, float horizontalExtent, float mult, char isPAImage, global unsigned short* usedLines) {
  int globalPosX = get_global_id(0);
  int globalPosY = get_global_id(1);
  int globalPosZ = get_global_id(2);

  if (globalPosX < outputL && globalPosY < outputS && globalPosZ < Slices) {
    int AddSample1 = 0;
    int AddSample2 = 0;

    float output = 0;

    float s_1 = 0;
    float s_2 = 0;
    float apod_1 = 0;

    float l_p = (float)globalPosX / outputL * horizontalExtent;
    float s_i = (float)globalPosY / outputS * totalSamples_i;

    unsigned short curUsedLines = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX)];
    unsigned short minLine = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX + 1)];
    unsigned short maxLine = usedLines[hook(15, globalPosY * 3 * outputL + 3 * globalPosX + 2)];

    float apod_mult = (float)apodArraySize / curUsedLines;

    float multiplication = 0;

    for (int l_s1 = minLine; l_s1 < maxLine; ++l_s1) {
      AddSample1 = (int)sqrt(pow(s_i - elementHeights[hook(2, l_s1)] * mult, 2) + pow(mult * (l_p - elementPositions[hook(3, l_s1)]), 2)) + (1 - isPAImage) * s_i;

      if (AddSample1 < inputS && AddSample1 >= 0) {
        s_1 = dSource[hook(0, (int)(globalPosZ * inputL * inputS + AddSample1 * inputL + l_s1))];
        apod_1 = apodArray[hook(4, (int)((l_s1 - minLine) * apod_mult))];

        for (int l_s2 = minLine; l_s2 < maxLine; ++l_s2) {
          AddSample2 = (int)sqrt(pow(s_i - elementHeights[hook(2, l_s2)] * mult, 2) + pow(mult * (l_p - elementPositions[hook(3, l_s2)]), 2)) + (1 - isPAImage) * s_i;
          if (AddSample2 < inputS && AddSample2 >= 0) {
            s_2 = dSource[hook(0, (int)(globalPosZ * inputL * inputS + AddSample2 * inputL + l_s2))];
            multiplication = apodArray[hook(4, (int)((l_s2 - minLine) * apod_mult))] * s_2 * apod_1 * s_1;

            output += sqrt(fabs(multiplication)) * sign(multiplication);
          }
        }
      } else
        --curUsedLines;
    }
    dDest[hook(1, globalPosZ * outputL * outputS + globalPosY * outputL + globalPosX)] = output / (float)(pow((float)curUsedLines, 2) - (curUsedLines - 1));
  }
}