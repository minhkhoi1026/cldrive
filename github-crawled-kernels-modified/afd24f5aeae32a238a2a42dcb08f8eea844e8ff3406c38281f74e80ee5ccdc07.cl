//{"buffer":3,"in":0,"out":1,"pIn":2,"pOut":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1024, 1, 1))) kernel void pooling_f3x3_s2x2(const global float* in, global float* out) {
  unsigned int lidx = get_local_id(0);
  unsigned int gridx = get_group_id(0);

  local float buffer[112 * 66 * 2];

  global float* pIn;
  global float* pOut;

  float max_temp;
  unsigned int in_index;
  unsigned int out_index;
  unsigned int in_lds_index;
  unsigned int out_lds_index;

  for (unsigned int n = 0; n < 1; n++) {
    pIn = (global float*)(in + gridx * (112 * 112) + n * (64 * 112 * 112));
    pOut = (global float*)(out + gridx * ((112 >> 1) * (112 >> 1)) + n * (64 * (112 >> 1) * (112 >> 1)));

    if ((lidx & 63) < (112 >> 1)) {
      for (unsigned int i = 0; i < 7; i++) {
        in_index = ((lidx >> 6) * 7 + i) * 112;
        in_lds_index = ((lidx >> 6) * 7 + i);
        max_temp = fmax(pIn[hook(2, in_index + (lidx & 63) * 2)], pIn[hook(2, in_index + (lidx & 63) * 2 + 1)]);
        buffer[hook(3, in_lds_index * 66 + (lidx & 63) + ((lidx & 63) >> 5))] = (lidx & 63) * 2 + 2 < 112 ? fmax(max_temp, pIn[hook(2, in_index + (lidx & 63) * 2 + 2)]) : max_temp;
      }
    }

    barrier(0x01);

    if ((lidx >> 6) < 14 && (lidx & 63) < (112 >> 1)) {
      for (unsigned int i = 0; i < 4; i++) {
        out_index = ((lidx >> 6) * 4 + i) * (112 >> 1);
        out_lds_index = ((lidx >> 6) * 4 + i) * 2;
        max_temp = fmax(buffer[hook(3, out_lds_index * 66 + (lidx & 63) + ((lidx & 63) >> 5))], buffer[hook(3, (out_lds_index + 1) * 66 + (lidx & 63) + ((lidx & 63) >> 5))]);
        pOut[hook(4, out_index + (lidx & 63))] = out_lds_index + 2 < 112 ? fmax(max_temp, buffer[hook(3, (out_lds_index + 2) * 66 + (lidx & 63) + ((lidx & 63) >> 5))]) : max_temp;
      }
    }

    barrier(0x01);
  }
}