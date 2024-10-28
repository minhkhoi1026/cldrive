//{"AddSamples":3,"Slices":8,"apodArray":4,"apodArraySize":5,"dDest":1,"dSource":0,"inputL":6,"inputS":7,"outputL":9,"outputS":10,"usedLines":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cksDMAS(global float* dSource, global float* dDest, global unsigned short* usedLines, global unsigned short* AddSamples, constant float* apodArray, unsigned short apodArraySize, unsigned int inputL, unsigned int inputS, unsigned int Slices, unsigned int outputL, unsigned int outputS) {
  unsigned int globalPosX = get_global_id(0);
  unsigned int globalPosY = get_global_id(1);
  unsigned int globalPosZ = get_global_id(2);

  if (globalPosX < outputL && globalPosY < outputS && globalPosZ < Slices) {
    float l_i = (float)globalPosX / (float)outputL * (float)inputL;

    unsigned short curUsedLines = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX)];
    unsigned short minLine = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX + 1)];
    unsigned short maxLine = usedLines[hook(2, globalPosY * 3 * outputL + 3 * globalPosX + 2)];

    float apod_mult = (float)apodArraySize / (float)curUsedLines;

    unsigned short Delay1 = 0;
    unsigned short Delay2 = 0;

    float output = 0;
    float mult = 0;

    float s_1 = 0;
    float s_2 = 0;
    float dSign = 0;
    float apod_1 = 0;

    for (short l_s1 = minLine; l_s1 < maxLine; ++l_s1) {
      Delay1 = AddSamples[hook(3, globalPosY * (outputL / 2) + (int)(fabs(l_s1 - l_i) / (float)inputL * (float)outputL))];
      if (Delay1 < inputS && Delay1 >= 0) {
        s_1 = dSource[hook(0, (int)(globalPosZ * inputL * inputS + Delay1 * inputL + l_s1))];
        apod_1 = apodArray[hook(4, (int)((l_s1 - minLine) * apod_mult))];
        dSign += s_1;

        for (short l_s2 = l_s1 + 1; l_s2 < maxLine; ++l_s2) {
          Delay2 = AddSamples[hook(3, globalPosY * (outputL / 2) + (int)(fabs(l_s2 - l_i) / (float)inputL * (float)outputL))];
          if (Delay2 < inputS && Delay2 >= 0) {
            s_2 = dSource[hook(0, (int)(globalPosZ * inputL * inputS + Delay2 * inputL + l_s2))];

            mult = apodArray[hook(4, (int)((l_s2 - minLine) * apod_mult))] * s_2 * apod_1 * s_1;

            output += sqrt(fabs(mult)) * ((mult > 0) - (mult < 0));
          }
        }
      } else
        --curUsedLines;
    }

    dDest[hook(1, globalPosZ * outputL * outputS + globalPosY * outputL + globalPosX)] = output / (float)(curUsedLines * curUsedLines - (curUsedLines - 1)) * sign(dSign);
  }
}