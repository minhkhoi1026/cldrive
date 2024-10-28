//{"inputLength":3,"nextOffsetTable":1,"offsetPrefixScan":2,"previousOffsetTable":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
size_t __attribute__((overloadable)) digit(float value, size_t index) {
  size_t mantissa = (size_t)(fabs(((float)((size_t)value)) - value) * 10000);

  return (size_t)((size_t)(mantissa / pow(10.0, (double)index)) % 10);
}

size_t __attribute__((overloadable)) digit(int value, size_t index) {
  return ((int)(value / pow(10.0, (double)index))) % 10;
}

kernel void prefixScan(constant size_t* previousOffsetTable, global size_t* nextOffsetTable, global size_t* offsetPrefixScan, constant size_t* inputLength) {
  if (get_global_id(0) + 1 > (*inputLength))
    return;

 private
  size_t offsetTableIndex = get_global_id(0) * 10;
 private
  size_t offset = *offsetPrefixScan;

  if (offsetTableIndex < offset)
    for (size_t i = 0; i < 10; i++)
      nextOffsetTable[hook(1, offsetTableIndex + i)] = previousOffsetTable[hook(0, offsetTableIndex + i)];
  else
    for (size_t i = 0; i < 10; i++)
      nextOffsetTable[hook(1, offsetTableIndex + i)] = previousOffsetTable[hook(0, offsetTableIndex + i - offset)] + previousOffsetTable[hook(0, offsetTableIndex + i)];

  barrier(0x02);
  if (get_global_id(0) == 0)
    offsetPrefixScan[hook(2, 0)] = *offsetPrefixScan * 2;
}