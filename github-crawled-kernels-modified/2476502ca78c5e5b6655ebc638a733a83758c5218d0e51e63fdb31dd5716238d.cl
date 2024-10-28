//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test() {
  int i = 0;
  int j = 5;
  int a = i & j;
  int b = i && j;
  int c = i - j;
  int d = i - -j;
  int e = i | j;
  int f = i || j;
  int g = i ^ j;
  int h = ~i;
  int k = i < j;
  int l = i >= j;
  int m = i == j;
  int n = &i;
  int o = *(int*)i;
  float p = i;
  int q = p;
  unsigned r = q;
  unsigned s = p;
  long t = i;
  short u = i;
  char v = j;
  int w = ~i;
}