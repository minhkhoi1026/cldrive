//{"height":3,"histo":0,"img":1,"local_histo":5,"ptr":6,"width":4,"widthStep":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void AtomicAddG(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;
  do {
    prevVal.floatVal = *source;
    newVal.floatVal = prevVal.floatVal + operand;
  } while (atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}
int histo_bin(float h, float s, float v) {
  int hd, sd, vd;

  vd = min((int)(v * 10 / 1.0f), 10 - 1);
  if (s < 0.1f || v < 0.2f)
    return 10 * 10 + vd;

  hd = min((int)(h * 10 / 360.0f), 10 - 1);
  sd = min((int)(s * 10 / 1.0f), 10 - 1);
  return sd * 10 + hd;
}
kernel void calc_histo(global float* histo, global const char* restrict img, const int widthStep, const int height, const int width) {
  int groups = get_num_groups(0);
  int tamGroup = get_local_size(0);
  int base = get_group_id(0);
  int lid = get_local_id(0);
  local int local_histo[110];

  for (int i = lid; i < 110; i += tamGroup)
    local_histo[hook(5, i)] = 0;
  barrier(0x01);

  for (int f = base; f < height; f += groups) {
    global float* ptr = (global float*)(img + widthStep * f);
    for (int col = lid; col < width; col += tamGroup) {
      int desp = 3 * col;
      int bin = histo_bin(ptr[hook(6, desp)], ptr[hook(6, desp + 1)], ptr[hook(6, desp + 2)]);
      atomic_inc(&local_histo[hook(5, bin)]);
    }
  }

  barrier(0x01);
  for (int i = lid; i < 110; i += tamGroup)
    AtomicAddG(&histo[hook(0, i)], local_histo[hook(5, i)]);
}