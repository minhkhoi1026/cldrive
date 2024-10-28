//{"dst":0,"src":2,"tmp":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_atomic_functions(global int* dst, local int* tmp, global int* src) {
  int lid = get_local_id(0);
  int i = lid % 12;
  if (lid == 0) {
    for (int j = 0; j < 12; j = j + 1) {
      atomic_xchg(&tmp[hook(1, j)], 0);
    }
    atomic_xchg(&tmp[hook(1, 4)], -1);
  }
  barrier(0x01);

  switch (i) {
    case 0:
      atomic_inc(&tmp[hook(1, i)]);
      break;
    case 1:
      atomic_dec(&tmp[hook(1, i)]);
      break;
    case 2:
      atomic_add(&tmp[hook(1, i)], src[hook(2, lid)]);
      break;
    case 3:
      atomic_sub(&tmp[hook(1, i)], src[hook(2, lid)]);
      break;
    case 4:
      atomic_and(&tmp[hook(1, i)], ~(src[hook(2, lid)] << (lid / 16)));
      break;
    case 5:
      atomic_or(&tmp[hook(1, i)], src[hook(2, lid)] << (lid / 16));
      break;
    case 6:
      atomic_xor(&tmp[hook(1, i)], src[hook(2, lid)]);
      break;
    case 7:
      atomic_min(&tmp[hook(1, i)], -src[hook(2, lid)]);
      break;
    case 8:
      atomic_max(&tmp[hook(1, i)], src[hook(2, lid)]);
      break;
    case 9:
      atomic_min((local unsigned int*)&tmp[hook(1, i)], -src[hook(2, lid)]);
      break;
    case 10:
      atomic_max((local unsigned int*)&tmp[hook(1, i)], src[hook(2, lid)]);
      break;
    case 11:
      atomic_cmpxchg(&(tmp[hook(1, i)]), 0, src[hook(2, 10)]);
      break;
    default:
      break;
  }

  switch (i) {
    case 0:
      atomic_inc(&dst[hook(0, i)]);
      break;
    case 1:
      atomic_dec(&dst[hook(0, i)]);
      break;
    case 2:
      atomic_add(&dst[hook(0, i)], src[hook(2, lid)]);
      break;
    case 3:
      atomic_sub(&dst[hook(0, i)], src[hook(2, lid)]);
      break;
    case 4:
      atomic_and(&dst[hook(0, i)], ~(src[hook(2, lid)] << (lid / 16)));
      break;
    case 5:
      atomic_or(&dst[hook(0, i)], src[hook(2, lid)] << (lid / 16));
      break;
    case 6:
      atomic_xor(&dst[hook(0, i)], src[hook(2, lid)]);
      break;
    case 7:
      atomic_min(&dst[hook(0, i)], -src[hook(2, lid)]);
      break;
    case 8:
      atomic_max(&dst[hook(0, i)], src[hook(2, lid)]);
      break;
    case 9:
      atomic_min((global unsigned int*)&dst[hook(0, i)], -src[hook(2, lid)]);
      break;
    case 10:
      atomic_max((global unsigned int*)&dst[hook(0, i)], src[hook(2, lid)]);
      break;
    case 11:
      atomic_cmpxchg(&dst[hook(0, i)], 0, src[hook(2, 10)]);
      break;
    default:
      break;
  }

  barrier(0x02);

  if (get_global_id(0) == 0) {
    for (i = 0; i < 12; i = i + 1)
      atomic_xchg(&dst[hook(0, i + 12)], tmp[hook(1, i)]);
  }
}