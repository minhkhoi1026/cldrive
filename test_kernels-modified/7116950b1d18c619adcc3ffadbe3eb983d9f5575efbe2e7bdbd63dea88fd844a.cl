//{"array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int get_value(int value);
constant struct {
  struct {
    struct {
      int f;
    } b;
  } a;

} c1 = {{{1}}}, c2 = {{{2}}};

constant struct {
  struct {
    struct {
      int f;
    } b;
  } a;

} c3 = {{{3}}}, c4 = {{{4}}};

int get_value(int value) {
  struct {
    struct {
      struct {
        int f;
      } b;
    } a;

  } p1 = {{{value + 1}}}, p2 = {{{value + 2}}};

 private
  struct {
    struct {
      struct {
        int f;
      } b;
    } a;

  } p3 = {{{value + 3}}}, p4 = {{{value + 4}}};

  return p1.a.b.f + p2.a.b.f + p3.a.b.f + p4.a.b.f;
}

constant struct {
  struct {
    struct {
      int f;
    } b;
  } a;

} c5 = {{{5}}}, c6 = {{{6}}};

constant struct {
  struct {
    struct {
      int f;
    } b;
  } a;

} c7 = {{{7}}}, c8 = {{{8}}};

kernel void access_array(

    global int* array) {
  local struct {
    struct {
      struct {
        int f;
      } b;
    } a;

  } l1, l2;

  l1.a.b.f = 1;
  l2.a.b.f = 2;

  const int i = get_global_id(0);
  array[hook(0, i)] = c1.a.b.f + c2.a.b.f + c3.a.b.f + c4.a.b.f + c5.a.b.f + c6.a.b.f + c7.a.b.f + c8.a.b.f + l1.a.b.f + l2.a.b.f + get_value(i);
}