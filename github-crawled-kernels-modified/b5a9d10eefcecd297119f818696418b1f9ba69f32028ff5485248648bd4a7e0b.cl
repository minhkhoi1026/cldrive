//{"input":0,"output":1,"s":5,"x1":2,"x2":6,"y1":3,"y2":7,"z1":4,"z2":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Compare(private unsigned int x[8], private unsigned int y[8]);
int IsZero(private unsigned int x[8]);
void Add(private unsigned int x[8], private unsigned int y[8], private unsigned int prime[8], private unsigned int r[8]);
void Subtract(private unsigned int x[8], private unsigned int y[8], private unsigned int prime[8], private unsigned int r[8]);
void Multiply(private unsigned int x[8], private unsigned int y[8], private unsigned int prime[8], private unsigned int r[8]);
void EC_Add(private unsigned int x1[8], private unsigned int y1[8], private unsigned int z1[8], private unsigned int x2[8], private unsigned int y2[8], private unsigned int z2[8], private unsigned int prime[8], private unsigned int rx[8], private unsigned int ry[8], private unsigned int rz[8]);
void EC_Double(private unsigned int x[8], private unsigned int y[8], private unsigned int z[8], private unsigned int prime[8], private unsigned int rx[8], private unsigned int ry[8], private unsigned int rz[8]);
void EC_Multiply(private unsigned int x[8], private unsigned int y[8], private unsigned int z[8], private unsigned int s[8], private unsigned int prime[8], private unsigned int rx[8], private unsigned int ry[8], private unsigned int rz[8]);
kernel void Test(global unsigned int* input, global unsigned int* output) {
 private
  unsigned int x1[8];
 private
  unsigned int y1[8];
 private
  unsigned int z1[8];
 private
  unsigned int x2[8];
 private
  unsigned int y2[8];
 private
  unsigned int z2[8];
 private
  unsigned int s[8];
 private
  unsigned int prime[8] = {0xffffffff, 0xffffffff, 0xffffffff, 0, 0, 0, 1, 0xffffffff};

  int global_id = get_global_id(0);
  input += global_id * 32;
  output += global_id * 24;

  for (unsigned int i = 0; i < 8; i++) {
    x1[hook(2, i)] = input[hook(0, i)];
    y1[hook(3, i)] = input[hook(0, i + 8)];
    z1[hook(4, i)] = input[hook(0, i + 16)];
    s[hook(5, i)] = input[hook(0, i + 24)];
  }

  EC_Multiply(x1, y1, z1, s, prime, x2, y2, z2);

  for (unsigned int i = 0; i < 8; i++) {
    output[hook(1, i)] = x2[hook(6, i)];
    output[hook(1, i + 8)] = y2[hook(7, i)];
    output[hook(1, i + 16)] = z2[hook(8, i)];
  }
}