//{"accu_I":5,"accu_R":4,"fdl_I":3,"fdl_R":2,"info":6,"pir_I":1,"pir_R":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complexMultiplyAdd(global float* pir_R, global float* pir_I, global float* fdl_R, global float* fdl_I, global float* accu_R, global float* accu_I, global unsigned int* info) {
  unsigned int _2B = info[hook(6, 0)];
  unsigned int _C = info[hook(6, 1)];
  unsigned int _P = info[hook(6, 2)];
  unsigned int pir_C = info[hook(6, 3)];
  unsigned int fdl_lastest_line = info[hook(6, 4)];

  unsigned int idx = get_global_id(0);

  unsigned int channNum = idx / _2B;
  unsigned int sampleNum = idx % _2B;

  unsigned int pir_Idx = sampleNum % (pir_C * _2B);

  unsigned int fdl_Idx_base = channNum * _2B + sampleNum;
  unsigned int fdl_cursor = fdl_lastest_line;
  unsigned int fdl_Idx = (fdl_cursor * _2B * _C) + fdl_Idx_base;

  float accu_R_local = 0, accu_I_local = 0;

  for (unsigned int partNum = 0; partNum < _P; ++partNum) {
    float pir_R_local = pir_R[hook(0, pir_Idx)];
    float pir_I_local = pir_I[hook(1, pir_Idx)];

    float fdl_R_local = fdl_R[hook(2, fdl_Idx)];
    float fdl_I_local = fdl_I[hook(3, fdl_Idx)];

    accu_R_local += fdl_R_local * pir_R_local - fdl_I_local * pir_I_local;
    accu_I_local += fdl_I_local * pir_R_local + fdl_R_local * pir_I_local;

    pir_Idx += _2B * _C;
    fdl_cursor = (fdl_cursor - 1 + _P) % _P;
    fdl_Idx = (fdl_cursor * _2B * _C) + fdl_Idx_base;
  }

  accu_R[hook(4, idx)] = accu_R_local;
  accu_I[hook(5, idx)] = accu_I_local;
}