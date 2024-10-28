//{"data":0,"hist1":3,"hist2":4,"histogram":1,"numData":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateHistogram(global const unsigned char* restrict data, global unsigned int* restrict histogram, int numData) {
  const int tid = 0;

  const int startIdx = tid * numData;

  unsigned int hist1[256];

  unsigned int hist2[256];
  for (int i = 0; i < 256; i++) {
    hist1[hook(3, i)] = 0;

    hist2[hook(4, i)] = 0;
  }

  for (int i = 0; i < numData; i += 2) {
    int index = i + startIdx;

    hist1[hook(3, data[ihook(0, index))]++;

    if (i + 1 < numData) {
      hist2[hook(4, data[ihook(0, index + 1))]++;
    }
  }
  for (int i = 0; i < 256; i++) {
    histogram[hook(1, tid * 256 + i)] =

        hist1[hook(3, i)] +

        hist2[hook(4, i)] + 0;
  }
}