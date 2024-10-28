//{"g_answer":0,"g_reducedSet":1,"num_size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global unsigned char* g_answer, global unsigned char* g_reducedSet, const unsigned int num_size) {
  unsigned int gid = get_group_id(0);
  unsigned int lid = get_local_id(0);
  unsigned int tid = get_global_id(0);
  if (tid < num_size) {
    int mod = 2;
    int remainder = 1;
    for (mod = 2, remainder = 1; remainder <= get_local_size(0); mod *= 2, remainder *= 2) {
      if (lid % mod == remainder) {
        g_answer[hook(0, tid - remainder)] ^= g_answer[hook(0, tid)];
      }
      barrier(0x01);
    }

    if (lid == 0)
      g_reducedSet[hook(1, gid)] = g_answer[hook(0, tid)];
  }
}