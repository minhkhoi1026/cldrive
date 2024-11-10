
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable
#pragma OPENCL EXTENSION cl_khr_local_int32_base_atomics : enable
#pragma OPENCL EXTENSION cl_khr_local_int32_extended_atomics: enable
#pragma OPENCL EXTENSION cl_khr_global_int32_extended_atomics: enable
#pragma OPENCL EXTENSION cl_amd_printf : enable

#define get_queue_index(tid) ((tid%NUM_P_PER_MP))
#define get_queue_offset(tid) ((tid%NUM_P_PER_MP)*W_Q_SIZE)























void __gpu_sync(int blocks_to_synch , volatile __global unsigned int *g_mutex)
{
    
    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    int tid_in_block= get_local_id(0);


    
    if (tid_in_block == 0)
    {
        atomic_add(g_mutex, 1);
        
        
        while(g_mutex[hook(3, 0)] < blocks_to_synch)
        {
        }

    }
    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
}



































__kernel void BFS_kernel_one_block(

    volatile __global unsigned int *frontier,
    unsigned int frontier_len,
    volatile __global int *visited,
    volatile __global unsigned int *cost,
    __global unsigned int *edgeArray,
    __global unsigned int *edgeArrayAux,
    unsigned int numVertices,
    unsigned int numEdges,
    volatile __global unsigned int *frontier_length,
    const unsigned int max_local_mem,

    
    volatile __local unsigned int *b_q,
    volatile __local unsigned int *b_q2)
{
    volatile __local unsigned int b_offset[1];
    volatile __local unsigned int b_q_length[1];

    
    unsigned int tid = get_local_id(0);
    
    if(tid<frontier_len)
    {
        b_q[hook(11, tid)]=frontier[hook(0, tid)];
    }

    unsigned int f_len=frontier_len;
    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    while(1)
    {
        
        if(tid==0)
        {
            b_q_length[hook(17, 0)]=0;
            b_offset[hook(18, 0)]=0;
        }
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
        if(tid<f_len)
        {
            
            unsigned int node_to_process=b_q[hook(11, tid)];

            visited[hook(3, node_to_process)]=0;
            
            unsigned int offset = edgeArray[hook(5, node_to_process)];
            unsigned int next   = edgeArray[hook(5, node_to_process + 1)];

            
            while(offset<next)
            {
                
                unsigned int nid=edgeArrayAux[hook(6, offset)];
                
                unsigned int v=atomic_min(&cost[hook(4, nid)],cost[hook(4, node_to_process)]+1);
                
                if(v>cost[hook(4, node_to_process)]+1)
                {
                    int is_in_frontier=atomic_xchg(&visited[hook(3, nid)],1);
                    
                    if(is_in_frontier==0)
                    {
                            
                            unsigned int t=atomic_add(&b_q_length[hook(17, 0)],1);
                            if(t< max_local_mem)
                            {
                                b_q2[hook(11, t)]=nid;
                            }
                            
                            else
                            {
                                int off=atomic_add(&b_offset[hook(18, 0)],1);
                                frontier[hook(0, off)]=nid;
                            }
                        }
                }
                offset++;
            }
        }
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
        
        if(tid<max_local_mem)
            b_q[hook(11, tid)]=b_q2[hook(11, tid)];
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
        
        if(b_q_length[hook(17, 0)]==0)
        {
            if(tid==0)
                frontier_length[hook(2, 0)]=0;

            return;
        }
        
        
        else if( b_q_length[hook(17, 0)] > get_local_size(0) ||
                 b_q_length[hook(17, 0)] > max_local_mem)
        {
            if(tid<(b_q_length[hook(17, 0)]-b_offset[hook(18, 0)]))
                frontier[hook(0, b_offset[0] hook(18, 0) tid)]=b_q[hook(11, tid)];
            if(tid==0)
            {
                frontier_length[hook(2, 0)] = b_q_length[hook(17, 0)];
            }
            return;
        }
        f_len=b_q_length[hook(17, 0)];
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    }
}




































__kernel void BFS_kernel_SM_block(

    volatile __global unsigned int *frontier,
    unsigned int frontier_len,
    volatile __global unsigned int *frontier2,
    volatile __global int *visited,
    volatile __global unsigned int *cost,
    __global unsigned int *edgeArray,
    __global unsigned int *edgeArrayAux,
    unsigned int numVertices,
    unsigned int numEdges,
    volatile __global unsigned int *frontier_length,
    volatile __global unsigned int *g_mutex,
    volatile __global unsigned int *g_mutex2,
    volatile __global unsigned int *g_q_offsets,
    volatile __global unsigned int *g_q_size,
    const unsigned int max_local_mem,

    
    volatile __local unsigned int *b_q)
{

    volatile __local unsigned int b_q_length[1];
    volatile __local unsigned int b_offset[1];
    
    unsigned int tid=get_global_id(0);
    unsigned int lid=get_local_id(0);

    int loop_index=0;
    unsigned int l_mutex=g_mutex2[hook(4, 0)];
    unsigned int f_len=frontier_len;
    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    while(1)
    {
        
        if (lid==0)
        {
            b_q_length[hook(17, 0)]=0;
            b_offset[hook(18, 0)]=0;
        }
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
        if(tid<f_len)
        {
            unsigned int node_to_process;

            
            if(loop_index==0)
               node_to_process=frontier[hook(0, tid)];
            else
               node_to_process=frontier2[hook(1, tid)];

            
            visited[hook(3, node_to_process)]=0;
            
            unsigned int offset=edgeArray[hook(5, node_to_process)];
            unsigned int next=edgeArray[hook(5, node_to_process + 1)];

            
            while(offset<next)
            {
                
                unsigned int nid=edgeArrayAux[hook(6, offset)];
                
                unsigned int v=atomic_min(&cost[hook(4, nid)],cost[hook(4, node_to_process)]+1);
                
                if(v>cost[hook(4, node_to_process)]+1)
                {
                    int is_in_frontier=atomic_xchg(&visited[hook(3, nid)],1);
                    
                    if(is_in_frontier==0)
                    {
                        
                        unsigned int t=atomic_add(&b_q_length[hook(17, 0)],1);
                        if(t<max_local_mem)
                        {
                            b_q[hook(11, t)]=nid;
                        }
                        
                        else
                        {
                            int off=atomic_add(g_q_offsets,1);
                            if(loop_index==0)
                                frontier2[hook(1, off)]=nid;
                            else
                                frontier[hook(0, off)]=nid;
                        }
                    }
                }
                offset++;
            }
        }

        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
        
        if(lid==0)
        {
            if(b_q_length[hook(17, 0)] > max_local_mem)
            {
                b_q_length[hook(17, 0)] = max_local_mem;
            }
            b_offset[hook(18, 0)]=atomic_add(g_q_offsets,b_q_length[hook(17, 0)]);
        }

        
        barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
		l_mutex+=get_num_groups(0);
		__gpu_sync(l_mutex,g_mutex);

        
        if(tid==0)
        {
            g_q_size[hook(6, 0)]=g_q_offsets[hook(5, 0)];
            g_q_offsets[hook(5, 0)]=0;
        }

        
        if(lid < b_q_length[hook(17, 0)])
        {
            if(loop_index==0)
                frontier2[hook(1, lid + b_offset[0hook(18, 0))]=b_q[hook(11, lid)];
            else
                frontier[hook(0, lid + b_offset[0hook(18, 0))]=b_q[hook(11, lid)];
        }

        
		l_mutex+=get_num_groups(0);
		__gpu_sync(l_mutex,g_mutex);

        
        if(g_q_size[hook(6, 0)] < get_local_size(0) ||
            g_q_size[hook(6, 0)] > get_local_size(0) * get_num_groups(0))
                break;

        loop_index=(loop_index+1)%2;
        
        f_len=g_q_size[hook(6, 0)];
    }

    if(loop_index==0)
    {
        for(int i=tid;i<g_q_size[hook(6, 0)];i += get_global_size(0))
               frontier[hook(0, i)]=frontier2[hook(1, i)];
    }
    if(tid==0)
    {
        frontier_length[hook(2, 0)]=g_q_size[hook(6, 0)];
    }
}
































__kernel void BFS_kernel_multi_block(

    volatile __global unsigned int *frontier,
    unsigned int frontier_len,
    volatile __global unsigned int *frontier2,
    volatile __global int *visited,
    volatile __global unsigned int *cost,
    __global unsigned int *edgeArray,
    __global unsigned int *edgeArrayAux,
    unsigned int numVertices,
    unsigned int numEdges,
    volatile __global unsigned int *frontier_length,
    const unsigned int max_local_mem,

    volatile __local unsigned int *b_q)
{
    volatile __local unsigned int b_q_length[1];
    volatile __local unsigned int b_offset[1];

    
    unsigned int tid=get_global_id(0);
    unsigned int lid=get_local_id(0);

    
    if (lid == 0)
    {
        b_q_length[hook(17, 0)]=0;
        b_offset[hook(18, 0)]=0;
    }

    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    if(tid<frontier_len)
    {
        
        unsigned int node_to_process=frontier[hook(0, tid)];
        visited[hook(3, node_to_process)]=0;
        
        unsigned int offset=edgeArray[hook(5, node_to_process)];
        unsigned int next=edgeArray[hook(5, node_to_process + 1)];

        
        while(offset<next)
        {
            
            unsigned int nid=edgeArrayAux[hook(6, offset)];
            
            unsigned int v=atomic_min(&cost[hook(4, nid)],cost[hook(4, node_to_process)]+1);
            
            if(v>cost[hook(4, node_to_process)]+1)
            {
                int is_in_frontier=atomic_xchg(&visited[hook(3, nid)],1);
                
                if(is_in_frontier==0)
                {
                        
                        unsigned int t=atomic_add(&b_q_length[hook(17, 0)],1);
                        if(t<max_local_mem)
                        {
                            b_q[hook(11, t)]=nid;
                        }
                        
                        else
                        {
                            int off=atomic_add(frontier_length,1);
                            frontier2[hook(1, off)]=nid;
                        }
                }
            }
            offset++;
        }
    }
    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);

    
    if(lid==0)
    {
        if(b_q_length[hook(17, 0)] > max_local_mem)
        {
                b_q_length[hook(17, 0)]=max_local_mem;
        }
        b_offset[hook(18, 0)]=atomic_add(frontier_length,b_q_length[hook(17, 0)]);
    }

    barrier(CLK_LOCAL_MEM_FENCE|CLK_GLOBAL_MEM_FENCE);
    
    if(lid < b_q_length[hook(17, 0)])
        frontier2[hook(1, lid + b_offset[0hook(18, 0))]=b_q[hook(11, lid)];

}






















__kernel void Reset_kernel_parameters(

    __global unsigned int *frontier_length,
    __global volatile int *g_mutex,
    __global volatile int *g_mutex2,
    __global volatile int *g_q_offsets,
    __global volatile int *g_q_size)
{
    g_mutex[hook(3, 0)]=0;
    g_mutex2[hook(4, 0)]=0;
    *frontier_length=0;
    *g_q_offsets=0;
    g_q_size[hook(6, 0)]=0;
}
























__kernel void Frontier_copy(
    __global unsigned int *frontier,
    __global unsigned int *frontier2,
    __global unsigned int *frontier_length,
    __global volatile int *g_mutex,
    __global volatile int *g_mutex2,
    __global volatile int *g_q_offsets,
    __global volatile int *g_q_size)
{
    unsigned int tid=get_global_id(0);

    if(tid<*frontier_length)
    {
        frontier[hook(0, tid)]=frontier2[hook(1, tid)];
    }
}
