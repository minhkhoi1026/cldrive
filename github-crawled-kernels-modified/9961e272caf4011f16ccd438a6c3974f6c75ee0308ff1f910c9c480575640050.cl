//{"activations":0,"dropoutParameter":2,"nActivations":1,"randomSeed":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Dropout(global float* activations, const int nActivations, const float dropoutParameter, const ulong randomSeed) {
  const int iActivation = get_global_id(0);

  if (iActivation < nActivations) {
    ulong thisSeed = randomSeed + iActivation;
    thisSeed = (thisSeed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
    unsigned int pseudoRandomInt = thisSeed >> 16;
    for (int j = 0; j < 6; ++j) {
      thisSeed = pseudoRandomInt;
      thisSeed = (thisSeed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
      pseudoRandomInt = thisSeed >> 16;
    }
    float pseudoRandFloat = (float)pseudoRandomInt / (float)4294967295;

    if (pseudoRandFloat > dropoutParameter)
      activations[hook(0, iActivation)] = 0.0F;
    else
      activations[hook(0, iActivation)] /= dropoutParameter;
  }
}