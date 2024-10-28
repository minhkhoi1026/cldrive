//{"counts":3,"in":0,"length":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calcStatisticAtomic(global int* in, int length, global int* out) {
  int locId = get_local_id(0);
  int grpId = get_group_id(0);
  int gloId = get_global_id(0);

  int amountOfPixelsInWorkGroup = 256 * 32;

  local int counts[256];

  for (int i = locId; i < 256; i += 32) {
    counts[hook(3, i)] = 0;
    out[hook(2, i)] = 0;
  }
  for (int i = locId; i < amountOfPixelsInWorkGroup; i += 32) {
    if (i + grpId * amountOfPixelsInWorkGroup < length) {
      int Index = (i + grpId * amountOfPixelsInWorkGroup) * 3;
      float Y = 0.2126f * in[hook(0, Index + 0)] + 0.7152f * in[hook(0, Index + 1)] + 0.0722f * in[hook(0, Index + 2)];
      atomic_inc(&counts[hook(3, (int)Y)]);
    }
  }

  barrier(0x01);
  for (int i = locId; i < 256; i += 32) {
    atomic_add(&out[hook(2, i)], counts[hook(3, i)]);
  }
}