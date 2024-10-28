//{"delayMultiplicatorRaw":7,"gDest":0,"inputL":2,"inputS":3,"isPAImage":6,"outputL":4,"outputS":5,"totalSamples_i":8,"usedLines":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ckDelayCalculationSphe(global unsigned short* gDest, global unsigned short* usedLines, unsigned int inputL, unsigned int inputS, unsigned int outputL, unsigned int outputS, char isPAImage, float delayMultiplicatorRaw, float totalSamples_i) {
  unsigned int globalPosX = get_global_id(0);
  unsigned int globalPosY = get_global_id(1);

  if (globalPosX * 2 < outputL && globalPosY < outputS) {
    float l_i = 0;
    float s_i = (float)globalPosY / (float)outputS * totalSamples_i;
    float l_s = (float)globalPosX / (float)outputL * (float)inputL;

    gDest[hook(0, globalPosY * (outputL / 2) + globalPosX)] = sqrt(pow(s_i, 2) + pow((delayMultiplicatorRaw * ((l_s - l_i)) / inputL), 2)) + (1 - isPAImage) * s_i;
  }
}