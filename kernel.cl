int func_3(local int* in, int n) {
  return in[n];
}
int func_2(local int* in, int n) {
  return func_3(in, n);
}
int func_1(local int* in, int n) {
  return func_2(in, n);
}
kernel void kernel_1(local int* in, global int* out, int n) {
  out[n] = func_1(in, n);
}
