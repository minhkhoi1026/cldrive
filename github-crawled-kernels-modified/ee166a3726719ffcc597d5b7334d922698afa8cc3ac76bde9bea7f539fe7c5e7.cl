//{"preserved_local_array_f2":2,"preserved_local_array_f4":6,"preserved_local_array_l3":5,"preserved_local_array_l4":8,"preserved_local_array_m5":10,"removed_constant_array_1":15,"removed_constant_array_f10":26,"removed_constant_array_f11":29,"removed_constant_array_f4":18,"removed_constant_array_f5":19,"removed_constant_array_f8":22,"removed_constant_array_f9":24,"removed_constant_array_l10":28,"removed_constant_array_l11":31,"removed_constant_array_l2":16,"removed_constant_array_l3":17,"removed_constant_array_l8":23,"removed_constant_array_l9":25,"removed_constant_array_m10":27,"removed_constant_array_m11":30,"removed_constant_array_m6":20,"removed_constant_array_m7":21,"removed_local_array_1":1,"removed_local_array_f3":4,"removed_local_array_f5":9,"removed_local_array_f6":12,"removed_local_array_l2":3,"removed_local_array_l5":11,"removed_local_array_l6":14,"removed_local_array_m4":7,"removed_local_array_m6":13,"result":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int removed_constant_1 = 1;
constant int* constant removed_constant_pointer_1 = &removed_constant_1;
constant int removed_constant_array_1[1] = {1};

constant int preserved_constant_f2 = 2, removed_constant_l2 = 2;
constant int *constant preserved_constant_pointer_f2 = &removed_constant_l2, *constant removed_constant_pointer_l2 = &removed_constant_l2;
constant int preserved_constant_array_f2[1] = {2}, removed_constant_array_l2[1] = {2};

constant int preserved_constant_f3 = 3, removed_constant_l3 = 3;
constant int *constant preserved_constant_pointer_f3 = &removed_constant_l3, *constant removed_constant_pointer_l3 = &removed_constant_l3;
constant int preserved_constant_array_f3[1] = {3}, removed_constant_array_l3[1] = {3};

constant int removed_constant_f4 = 4, preserved_constant_l4 = 4;
constant int *constant removed_constant_pointer_f4 = &removed_constant_f4, *constant preserved_constant_pointer_l4 = &removed_constant_f4;
constant int removed_constant_array_f4[1] = {4}, preserved_constant_array_l4[1] = {4};

constant int removed_constant_f5 = 5, preserved_constant_l5 = 5;
constant int *constant removed_constant_pointer_f5 = &removed_constant_f5, *constant preserved_constant_pointer_l5 = &removed_constant_f5;
constant int removed_constant_array_f5[1] = {5}, preserved_constant_array_l5[1] = {5};

constant int preserved_constant_f6 = 6, removed_constant_m6 = 6, preserved_constant_l6 = 6;
constant int *constant preserved_constant_pointer_f6 = &removed_constant_m6, *constant removed_constant_pointer_m6 = &removed_constant_m6, *constant preserved_constant_pointer_l6 = &removed_constant_m6;
constant int preserved_constant_array_f6[1] = {6}, removed_constant_array_m6[1] = {6}, preserved_constant_array_l6[1] = {6};

constant int preserved_constant_f7 = 7, removed_constant_m7 = 7, preserved_constant_l7 = 7;
constant int *constant preserved_constant_pointer_f7 = &removed_constant_m7, *constant removed_constant_pointer_m7 = &removed_constant_m7, *constant preserved_constant_pointer_l7 = &removed_constant_m7;
constant int preserved_constant_array_f7[1] = {7}, removed_constant_array_m7[1] = {7}, preserved_constant_array_l7[1] = {7};

constant int removed_constant_f8 = 8, preserved_constant_m8 = 8, removed_constant_l8 = 8;
constant int *constant removed_constant_pointer_f8 = &removed_constant_f8, *constant preserved_constant_pointer_m8 = &removed_constant_f8, *constant removed_constant_pointer_l8 = &removed_constant_f8;
constant int removed_constant_array_f8[1] = {8}, preserved_constant_array_m8[1] = {8}, removed_constant_array_l8[1] = {8};

constant int removed_constant_f9 = 9, preserved_constant_m9 = 9, removed_constant_l9 = 9;
constant int *constant removed_constant_pointer_f9 = &removed_constant_f9, *constant preserved_constant_pointer_m9 = &removed_constant_f9, *constant removed_constant_pointer_l9 = &removed_constant_l9;
constant int removed_constant_array_f9[1] = {9}, preserved_constant_array_m9[1] = {9}, removed_constant_array_l9[1] = {9};

constant int removed_constant_f10 = 10, removed_constant_m10 = 10, removed_constant_l10 = 10;
constant int *constant removed_constant_pointer_f10 = &removed_constant_m10, *constant removed_constant_pointer_m10 = &removed_constant_m10, *constant removed_constant_pointer_l10 = &removed_constant_m10;
constant int removed_constant_array_f10[1] = {10}, removed_constant_array_m10[1] = {10}, removed_constant_array_l10[1] = {10};

constant int removed_constant_f11 = 11, removed_constant_m11 = 11, removed_constant_l11 = 11;
constant int *constant removed_constant_pointer_f11 = &removed_constant_f11, *constant removed_constant_pointer_m11 = &removed_constant_m11, *constant removed_constant_pointer_l11 = &removed_constant_l11;
constant int removed_constant_array_f11[1] = {11}, removed_constant_array_m11[1] = {11}, removed_constant_array_l11[1] = {11};

kernel void remove_variables(

    global int* result) {
  local int removed_local_1;
  removed_local_1 = 1;
  local int* local removed_local_pointer_1;
  removed_local_pointer_1 = &removed_local_1;
  local int removed_local_array_1[1];
  removed_local_array_1[hook(1, 0)] = removed_local_1;

  local int preserved_local_f2, removed_local_l2;
  preserved_local_f2 = 2;
  removed_local_l2 = preserved_local_f2;
  local int *local preserved_local_pointer_f2, *local removed_local_pointer_l2;
  preserved_local_pointer_f2 = &removed_local_l2;
  removed_local_pointer_l2 = preserved_local_pointer_f2;
  local int preserved_local_array_f2[1], removed_local_array_l2[1];
  preserved_local_array_f2[hook(2, 0)] = preserved_local_f2;
  removed_local_array_l2[hook(3, 0)] = preserved_local_array_f2[hook(2, 0)];

  local int removed_local_f3, preserved_local_l3;
  removed_local_f3 = 3;
  preserved_local_l3 = removed_local_f3;
  local int *local removed_local_pointer_f3, *local preserved_local_pointer_l3;
  removed_local_pointer_f3 = &removed_local_f3;
  preserved_local_pointer_l3 = removed_local_pointer_f3;
  local int removed_local_array_f3[1], preserved_local_array_l3[1];
  removed_local_array_f3[hook(4, 0)] = removed_local_f3;
  preserved_local_array_l3[hook(5, 0)] = removed_local_array_f3[hook(4, 0)];

  local int preserved_local_f4, removed_local_m4, preserved_local_l4;
  preserved_local_f4 = 4;
  removed_local_m4 = preserved_local_f4;
  preserved_local_l4 = removed_local_m4;
  local int *local preserved_local_pointer_f4, *local removed_local_pointer_m4, *local preserved_local_pointer_l4;
  preserved_local_pointer_f4 = &removed_local_m4;
  removed_local_pointer_m4 = preserved_local_pointer_f4;
  preserved_local_pointer_l4 = removed_local_pointer_m4;
  local int preserved_local_array_f4[1], removed_local_array_m4[1], preserved_local_array_l4[1];
  preserved_local_array_f4[hook(6, 0)] = preserved_local_f4;
  removed_local_array_m4[hook(7, 0)] = preserved_local_array_f4[hook(6, 0)];
  preserved_local_array_l4[hook(8, 0)] = removed_local_array_m4[hook(7, 0)];

  local int removed_local_f5, preserved_local_m5, removed_local_l5;
  removed_local_f5 = 5;
  preserved_local_m5 = removed_local_f5;
  removed_local_l5 = preserved_local_m5;
  local int *local removed_local_pointer_f5, *local preserved_local_pointer_m5, *local removed_local_pointer_l5;
  removed_local_pointer_f5 = &removed_local_f5;
  preserved_local_pointer_m5 = removed_local_pointer_f5;
  removed_local_pointer_l5 = preserved_local_pointer_m5;
  local int removed_local_array_f5[1], preserved_local_array_m5[1], removed_local_array_l5[1];
  removed_local_array_f5[hook(9, 0)] = removed_local_f5;
  preserved_local_array_m5[hook(10, 0)] = removed_local_array_f5[hook(9, 0)];
  removed_local_array_l5[hook(11, 0)] = preserved_local_array_m5[hook(10, 0)];

  local int removed_local_f6, removed_local_m6, removed_local_l6;
  removed_local_f6 = 6;
  removed_local_m6 = removed_local_f6;
  removed_local_l6 = removed_local_m6;
  local int *local removed_local_pointer_f6, *local removed_local_pointer_m6, *local removed_local_pointer_l6;
  removed_local_pointer_f6 = &removed_local_f6;
  removed_local_pointer_m6 = removed_local_pointer_f6;
  removed_local_pointer_l6 = removed_local_pointer_m6;
  local int removed_local_array_f6[1], removed_local_array_m6[1], removed_local_array_l6[1];
  removed_local_array_f6[hook(12, 0)] = removed_local_f6;
  removed_local_array_m6[hook(13, 0)] = removed_local_array_f6[hook(12, 0)];
  removed_local_array_l6[hook(14, 0)] = removed_local_array_m6[hook(13, 0)];

  int removed_constants = *(&removed_constant_1) + *removed_constant_pointer_1 + removed_constant_array_1[hook(15, 0)] + *(&removed_constant_l2) + *removed_constant_pointer_l2 + removed_constant_array_l2[hook(16, 0)] + *(&removed_constant_l3) + *removed_constant_pointer_l3 + removed_constant_array_l3[hook(17, 0)] + *(&removed_constant_f4) + *removed_constant_pointer_f4 + removed_constant_array_f4[hook(18, 0)] + *(&removed_constant_f5) + *removed_constant_pointer_f5 + removed_constant_array_f5[hook(19, 0)] + *(&removed_constant_m6) + *removed_constant_pointer_m6 + removed_constant_array_m6[hook(20, 0)] + *(&removed_constant_m7) + *removed_constant_pointer_m7 + removed_constant_array_m7[hook(21, 0)] + *(&removed_constant_f8) + *removed_constant_pointer_f8 + removed_constant_array_f8[hook(22, 0)] + *(&removed_constant_l8) + *removed_constant_pointer_l8 + removed_constant_array_l8[hook(23, 0)] + *(&removed_constant_f9) + *removed_constant_pointer_f9 + removed_constant_array_f9[hook(24, 0)] + *(&removed_constant_l9) + *removed_constant_pointer_l9 + removed_constant_array_l9[hook(25, 0)] + *(&removed_constant_f10) + *removed_constant_pointer_f10 + removed_constant_array_f10[hook(26, 0)] + *(&removed_constant_m10) + *removed_constant_pointer_m10 + removed_constant_array_m10[hook(27, 0)] + *(&removed_constant_l10) + *removed_constant_pointer_l10 + removed_constant_array_l10[hook(28, 0)] + *(&removed_constant_f11) + *removed_constant_pointer_f11 + removed_constant_array_f11[hook(29, 0)] + *(&removed_constant_m11) + *removed_constant_pointer_m11 + removed_constant_array_m11[hook(30, 0)] + *(&removed_constant_l11) + *removed_constant_pointer_l11 + removed_constant_array_l11[hook(31, 0)];

  int removed_locals = *(&removed_local_1) + *removed_local_pointer_1 + removed_local_array_1[hook(1, 0)] + *(&removed_local_l2) + *removed_local_pointer_l2 + removed_local_array_l2[hook(3, 0)] + *(&removed_local_f3) + *removed_local_pointer_f3 + removed_local_array_f3[hook(4, 0)] + *(&removed_local_m4) + *removed_local_pointer_m4 + removed_local_array_m4[hook(7, 0)] + *(&removed_local_f5) + *removed_local_pointer_f5 + removed_local_array_f5[hook(9, 0)] + *(&removed_local_l5) + *removed_local_pointer_l5 + removed_local_array_l5[hook(11, 0)] + *(&removed_local_f6) + *removed_local_pointer_f6 + removed_local_array_f6[hook(12, 0)] + *(&removed_local_m6) + *removed_local_pointer_m6 + removed_local_array_m6[hook(13, 0)] + *(&removed_local_l6) + *removed_local_pointer_l6 + removed_local_array_l6[hook(14, 0)];

  result[hook(0, get_global_id(0))] = removed_constants + removed_locals;
}