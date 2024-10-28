//{"bytes":0,"pixelCount":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global unsigned char* bytes, global unsigned int* pixelCount, global unsigned int* result) {
  unsigned int lid = get_local_id(0);
  unsigned int gid = get_group_id(0);
  unsigned int gsize = get_local_size(0);
  unsigned int globalId = get_global_id(0);

  unsigned int i, bValue;
  unsigned int basePixelIdx = lid * 1024 + gid * gsize * 1024;
  unsigned int baseResultIdx = globalId * 768;
  unsigned int maxPixel = *pixelCount;

  for (i = 0; i < 768; i++) {
    result[hook(2, baseResultIdx + i)] = 0;
  }

  unsigned int processIndex = 0;
  while (processIndex < 1024 && (basePixelIdx + processIndex < maxPixel)) {
    bValue = bytes[hook(0, basePixelIdx * 3 + processIndex * 3)];

    result[hook(2, baseResultIdx + bValue)]++;

    bValue = bytes[hook(0, basePixelIdx * 3 + processIndex * 3 + 1)];
    result[hook(2, baseResultIdx + 256 + bValue)]++;

    bValue = bytes[hook(0, basePixelIdx * 3 + processIndex * 3 + 2)];
    result[hook(2, baseResultIdx + 512 + bValue)]++;
    processIndex++;
  }
}