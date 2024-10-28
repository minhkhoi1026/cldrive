//{"counts":5,"counts[0]":6,"counts[k]":7,"counts[locId]":4,"in":0,"length":1,"out":3,"pixelPerWorkitem":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calcStatistic(global int* in, int length, int pixelPerWorkitem, global int* out) {
  int locId = get_local_id(0);
  int grpId = get_group_id(0);
  int gloId = get_global_id(0);

  local int counts[32][256];

  for (int i = 0; i < 256; i++) {
    counts[hook(5, locId)][hook(4, i)] = 0;
  }
  barrier(0x01);

  int amountOfPixelsInWorkGroup = pixelPerWorkitem * 32;

  for (int i = locId; i < amountOfPixelsInWorkGroup; i += 32) {
    if (i + grpId * amountOfPixelsInWorkGroup < length) {
      int Index = (i + grpId * amountOfPixelsInWorkGroup) * 3;
      float Y = 0.2126f * in[hook(0, Index + 0)] + 0.7152f * in[hook(0, Index + 1)] + 0.0722f * in[hook(0, Index + 2)];
      Y = clamp(Y, 0.f, 255.f);
      counts[hook(5, locId)][hook(4, (int)Y)] += 1;
    }
  }

  barrier(0x01);
  for (int i = locId; i < 256; i += 32) {
    for (int k = 1; k < 32; k++) {
      counts[hook(5, 0)][hook(6, i)] += counts[hook(5, k)][hook(7, i)];
    }
    out[hook(3, i + 256 * grpId)] = counts[hook(5, 0)][hook(6, i)];
  }
}