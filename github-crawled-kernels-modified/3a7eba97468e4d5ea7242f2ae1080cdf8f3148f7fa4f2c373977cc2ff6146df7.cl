//{"fields":1,"fields_internal_size2":2,"whoHasWon":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_who_has_won(global int* whoHasWon, global float* fields, unsigned int fields_internal_size2) {
  if (get_global_id(0) == 0) {
    if (fields[hook(1, 0 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 0 * fields_internal_size2 + 0)] == fields[hook(1, 0 * fields_internal_size2 + 1)] && fields[hook(1, 0 * fields_internal_size2 + 1)] == fields[hook(1, 0 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 0 * fields_internal_size2 + 0)];
    else if (fields[hook(1, 1 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 1 * fields_internal_size2 + 0)] == fields[hook(1, 1 * fields_internal_size2 + 1)] && fields[hook(1, 1 * fields_internal_size2 + 1)] == fields[hook(1, 1 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 1 * fields_internal_size2 + 0)];
    else if (fields[hook(1, 2 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 2 * fields_internal_size2 + 0)] == fields[hook(1, 2 * fields_internal_size2 + 1)] && fields[hook(1, 2 * fields_internal_size2 + 1)] == fields[hook(1, 2 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 2 * fields_internal_size2 + 0)];

    else if (fields[hook(1, 0 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 0 * fields_internal_size2 + 0)] == fields[hook(1, 1 * fields_internal_size2 + 0)] && fields[hook(1, 1 * fields_internal_size2 + 0)] == fields[hook(1, 2 * fields_internal_size2 + 0)])
      *whoHasWon = fields[hook(1, 0 * fields_internal_size2 + 0)];
    else if (fields[hook(1, 0 * fields_internal_size2 + 1)] != 0 && fields[hook(1, 0 * fields_internal_size2 + 1)] == fields[hook(1, 1 * fields_internal_size2 + 1)] && fields[hook(1, 1 * fields_internal_size2 + 1)] == fields[hook(1, 2 * fields_internal_size2 + 1)])
      *whoHasWon = fields[hook(1, 0 * fields_internal_size2 + 1)];
    else if (fields[hook(1, 0 * fields_internal_size2 + 2)] != 0 && fields[hook(1, 0 * fields_internal_size2 + 2)] == fields[hook(1, 1 * fields_internal_size2 + 2)] && fields[hook(1, 1 * fields_internal_size2 + 2)] == fields[hook(1, 2 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 0 * fields_internal_size2 + 2)];

    else if (fields[hook(1, 0 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 0 * fields_internal_size2 + 0)] == fields[hook(1, 1 * fields_internal_size2 + 1)] && fields[hook(1, 1 * fields_internal_size2 + 1)] == fields[hook(1, 2 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 0 * fields_internal_size2 + 0)];
    else if (fields[hook(1, 2 * fields_internal_size2 + 0)] != 0 && fields[hook(1, 2 * fields_internal_size2 + 0)] == fields[hook(1, 1 * fields_internal_size2 + 1)] && fields[hook(1, 1 * fields_internal_size2 + 1)] == fields[hook(1, 0 * fields_internal_size2 + 2)])
      *whoHasWon = fields[hook(1, 2 * fields_internal_size2 + 0)];
    else
      *whoHasWon = 0;
  }
}