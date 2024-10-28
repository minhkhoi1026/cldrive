//{"base":0,"chromosomeLength":1,"genesBuffer":4,"lim0":2,"lim1":3,"outBuffer":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void genCrowding(float base, unsigned int chromosomeLength, unsigned int lim0, unsigned int lim1, global const float* genesBuffer, global float* outBuffer) {
  int gId0 = get_global_id(0);
  int gId1 = get_global_id(1);
  int lId0 = get_local_id(0);
  int lId1 = get_local_id(1);
  int gRefGeneRow;
  int gTarGeneRow;
  int gOutRow;
  int gOutRowRefl;

  float distTerms = 0;

  if (gId0 >= gId1 && gId0 < lim0 && gId1 < lim1) {
    gRefGeneRow = gId0 * chromosomeLength;
    gTarGeneRow = gId1 * chromosomeLength;
    gOutRow = gId1 * lim0 + gId0;
    gOutRowRefl = gId0 * lim0 + gId1;

    if (gId0 == gId1) {
      outBuffer[hook(5, gOutRow)] = 0;
    } else {
      for (int i0 = 0; i0 < chromosomeLength; i0++) {
        distTerms += pown(genesBuffer[hook(4, gRefGeneRow + i0)] - genesBuffer[hook(4, gTarGeneRow + i0)], 2);
      }
      distTerms = sqrt(distTerms) / chromosomeLength;
      outBuffer[hook(5, gOutRow)] = distTerms;
      outBuffer[hook(5, gOutRowRefl)] = distTerms;
    }
  }
}