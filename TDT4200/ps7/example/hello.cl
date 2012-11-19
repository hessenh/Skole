__kernel void hello(__global uint *dst) {
	int id = get_global_id(0);
	dst[id] = id;
}
