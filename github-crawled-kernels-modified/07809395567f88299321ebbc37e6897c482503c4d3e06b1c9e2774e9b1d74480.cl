//{"global_float_data":4,"global_int_data":0,"global_uint_data":2,"local_float_data":5,"local_int_data":1,"local_uint_data":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atoms(volatile global int* global_int_data, volatile local int* local_int_data, volatile global unsigned int* global_uint_data, volatile local unsigned int* local_uint_data, volatile global float* global_float_data, volatile local float* local_float_data) {
  long val_int = 1;
  ulong val_uint = 2;
  unsigned int cmp = 1;

  val_int = atomic_min(global_int_data, val_int);

  val_int = atomic_max(global_int_data, val_int);

  val_int = atomic_and(global_int_data, val_int);

  val_int = atomic_or(global_int_data, val_int);

  val_int = atomic_xor(global_int_data, val_int);

  val_uint = atomic_min(global_uint_data, val_uint);

  val_uint = atomic_max(global_uint_data, val_uint);

  val_uint = atomic_and(global_uint_data, val_uint);

  val_uint = atomic_or(global_uint_data, val_uint);

  val_uint = atomic_xor(global_uint_data, val_uint);

  val_int = atomic_min(local_int_data, val_int);

  val_int = atomic_max(local_int_data, val_int);

  val_int = atomic_and(local_int_data, val_int);

  val_int = atomic_or(local_int_data, val_int);

  val_int = atomic_xor(local_int_data, val_int);

  val_uint = atomic_min(local_uint_data, val_uint);

  val_uint = atomic_max(local_uint_data, val_uint);

  val_uint = atomic_and(local_uint_data, val_uint);

  val_uint = atomic_or(local_uint_data, val_uint);

  val_uint = atomic_xor(local_uint_data, val_uint);
}