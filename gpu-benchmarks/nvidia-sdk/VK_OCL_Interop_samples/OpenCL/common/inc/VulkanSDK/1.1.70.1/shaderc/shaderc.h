













#ifndef SHADERC_SHADERC_H_
#define SHADERC_SHADERC_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


#if defined(SHADERC_SHAREDLIB)
    #if defined(_WIN32)
        #if defined(SHADERC_IMPLEMENTATION)
            #define SHADERC_EXPORT __declspec(dllexport)
        #else
            #define SHADERC_EXPORT __declspec(dllimport)
        #endif
    #else
        #if defined(SHADERC_IMPLEMENTATION)
            #define SHADERC_EXPORT __attribute__((visibility("default")))
        #else
            #define SHADERC_EXPORT
        #endif
    #endif
#else
    #define SHADERC_EXPORT
#endif


typedef enum {
  shaderc_source_language_glsl,
  shaderc_source_language_hlsl,
} shaderc_source_language;

typedef enum {
  
  
  shaderc_vertex_shader,
  shaderc_fragment_shader,
  shaderc_compute_shader,
  shaderc_geometry_shader,
  shaderc_tess_control_shader,
  shaderc_tess_evaluation_shader,

  shaderc_glsl_vertex_shader = shaderc_vertex_shader,
  shaderc_glsl_fragment_shader = shaderc_fragment_shader,
  shaderc_glsl_compute_shader = shaderc_compute_shader,
  shaderc_glsl_geometry_shader = shaderc_geometry_shader,
  shaderc_glsl_tess_control_shader = shaderc_tess_control_shader,
  shaderc_glsl_tess_evaluation_shader = shaderc_tess_evaluation_shader,
  
  
  shaderc_glsl_infer_from_source,
  
  
  
  shaderc_glsl_default_vertex_shader,
  shaderc_glsl_default_fragment_shader,
  shaderc_glsl_default_compute_shader,
  shaderc_glsl_default_geometry_shader,
  shaderc_glsl_default_tess_control_shader,
  shaderc_glsl_default_tess_evaluation_shader,
  shaderc_spirv_assembly,
} shaderc_shader_kind;

typedef enum {
  shaderc_target_env_vulkan,         
  shaderc_target_env_opengl,         
  shaderc_target_env_opengl_compat,  
                                     
                                     
  shaderc_target_env_default = shaderc_target_env_vulkan
} shaderc_target_env;

typedef enum {
  shaderc_profile_none,  
                         
  shaderc_profile_core,
  shaderc_profile_compatibility,
  shaderc_profile_es,
} shaderc_profile;


typedef enum {
  shaderc_compilation_status_success = 0,
  shaderc_compilation_status_invalid_stage,  
  shaderc_compilation_status_compilation_error,
  shaderc_compilation_status_internal_error,  
  shaderc_compilation_status_null_result_object,
  shaderc_compilation_status_invalid_assembly,
} shaderc_compilation_status;


typedef enum {
  shaderc_optimization_level_zero,  
  shaderc_optimization_level_size,  
} shaderc_optimization_level;


typedef enum {
  shaderc_limit_max_lights,
  shaderc_limit_max_clip_planes,
  shaderc_limit_max_texture_units,
  shaderc_limit_max_texture_coords,
  shaderc_limit_max_vertex_attribs,
  shaderc_limit_max_vertex_uniform_components,
  shaderc_limit_max_varying_floats,
  shaderc_limit_max_vertex_texture_image_units,
  shaderc_limit_max_combined_texture_image_units,
  shaderc_limit_max_texture_image_units,
  shaderc_limit_max_fragment_uniform_components,
  shaderc_limit_max_draw_buffers,
  shaderc_limit_max_vertex_uniform_vectors,
  shaderc_limit_max_varying_vectors,
  shaderc_limit_max_fragment_uniform_vectors,
  shaderc_limit_max_vertex_output_vectors,
  shaderc_limit_max_fragment_input_vectors,
  shaderc_limit_min_program_texel_offset,
  shaderc_limit_max_program_texel_offset,
  shaderc_limit_max_clip_distances,
  shaderc_limit_max_compute_work_group_count_x,
  shaderc_limit_max_compute_work_group_count_y,
  shaderc_limit_max_compute_work_group_count_z,
  shaderc_limit_max_compute_work_group_size_x,
  shaderc_limit_max_compute_work_group_size_y,
  shaderc_limit_max_compute_work_group_size_z,
  shaderc_limit_max_compute_uniform_components,
  shaderc_limit_max_compute_texture_image_units,
  shaderc_limit_max_compute_image_uniforms,
  shaderc_limit_max_compute_atomic_counters,
  shaderc_limit_max_compute_atomic_counter_buffers,
  shaderc_limit_max_varying_components,
  shaderc_limit_max_vertex_output_components,
  shaderc_limit_max_geometry_input_components,
  shaderc_limit_max_geometry_output_components,
  shaderc_limit_max_fragment_input_components,
  shaderc_limit_max_image_units,
  shaderc_limit_max_combined_image_units_and_fragment_outputs,
  shaderc_limit_max_combined_shader_output_resources,
  shaderc_limit_max_image_samples,
  shaderc_limit_max_vertex_image_uniforms,
  shaderc_limit_max_tess_control_image_uniforms,
  shaderc_limit_max_tess_evaluation_image_uniforms,
  shaderc_limit_max_geometry_image_uniforms,
  shaderc_limit_max_fragment_image_uniforms,
  shaderc_limit_max_combined_image_uniforms,
  shaderc_limit_max_geometry_texture_image_units,
  shaderc_limit_max_geometry_output_vertices,
  shaderc_limit_max_geometry_total_output_components,
  shaderc_limit_max_geometry_uniform_components,
  shaderc_limit_max_geometry_varying_components,
  shaderc_limit_max_tess_control_input_components,
  shaderc_limit_max_tess_control_output_components,
  shaderc_limit_max_tess_control_texture_image_units,
  shaderc_limit_max_tess_control_uniform_components,
  shaderc_limit_max_tess_control_total_output_components,
  shaderc_limit_max_tess_evaluation_input_components,
  shaderc_limit_max_tess_evaluation_output_components,
  shaderc_limit_max_tess_evaluation_texture_image_units,
  shaderc_limit_max_tess_evaluation_uniform_components,
  shaderc_limit_max_tess_patch_components,
  shaderc_limit_max_patch_vertices,
  shaderc_limit_max_tess_gen_level,
  shaderc_limit_max_viewports,
  shaderc_limit_max_vertex_atomic_counters,
  shaderc_limit_max_tess_control_atomic_counters,
  shaderc_limit_max_tess_evaluation_atomic_counters,
  shaderc_limit_max_geometry_atomic_counters,
  shaderc_limit_max_fragment_atomic_counters,
  shaderc_limit_max_combined_atomic_counters,
  shaderc_limit_max_atomic_counter_bindings,
  shaderc_limit_max_vertex_atomic_counter_buffers,
  shaderc_limit_max_tess_control_atomic_counter_buffers,
  shaderc_limit_max_tess_evaluation_atomic_counter_buffers,
  shaderc_limit_max_geometry_atomic_counter_buffers,
  shaderc_limit_max_fragment_atomic_counter_buffers,
  shaderc_limit_max_combined_atomic_counter_buffers,
  shaderc_limit_max_atomic_counter_buffer_size,
  shaderc_limit_max_transform_feedback_buffers,
  shaderc_limit_max_transform_feedback_interleaved_components,
  shaderc_limit_max_cull_distances,
  shaderc_limit_max_combined_clip_and_cull_distances,
  shaderc_limit_max_samples,
} shaderc_limit;




typedef enum {
  
  shaderc_uniform_kind_image,
  
  shaderc_uniform_kind_sampler,
  
  shaderc_uniform_kind_texture,
  
  shaderc_uniform_kind_buffer,
  
  shaderc_uniform_kind_storage_buffer,
  
  
  shaderc_uniform_kind_unordered_access_view,
} shaderc_uniform_kind;


























typedef struct shaderc_compiler* shaderc_compiler_t;










SHADERC_EXPORT shaderc_compiler_t shaderc_compiler_initialize(void);




SHADERC_EXPORT void shaderc_compiler_release(shaderc_compiler_t);



typedef struct shaderc_compile_options* shaderc_compile_options_t;






SHADERC_EXPORT shaderc_compile_options_t
    shaderc_compile_options_initialize(void);




SHADERC_EXPORT shaderc_compile_options_t shaderc_compile_options_clone(
    const shaderc_compile_options_t options);




SHADERC_EXPORT void shaderc_compile_options_release(
    shaderc_compile_options_t options);












SHADERC_EXPORT void shaderc_compile_options_add_macro_definition(
    shaderc_compile_options_t options, const char* name, size_t name_length,
    const char* value, size_t value_length);


SHADERC_EXPORT void shaderc_compile_options_set_source_language(
    shaderc_compile_options_t options, shaderc_source_language lang);


SHADERC_EXPORT void shaderc_compile_options_set_generate_debug_info(
    shaderc_compile_options_t options);



SHADERC_EXPORT void shaderc_compile_options_set_optimization_level(
    shaderc_compile_options_t options, shaderc_optimization_level level);






SHADERC_EXPORT void shaderc_compile_options_set_forced_version_profile(
    shaderc_compile_options_t options, int version, shaderc_profile profile);











typedef struct shaderc_include_result {
  
  
  
  
  
  const char* source_name;
  size_t source_name_length;
  
  
  const char* content;
  size_t content_length;
  
  void* user_data;
} shaderc_include_result;


enum shaderc_include_type {
  shaderc_include_type_relative,  
  shaderc_include_type_standard   
};









typedef shaderc_include_result* (*shaderc_include_resolve_fn)(
    void* user_data, const char* requested_source, int type,
    const char* requesting_source, size_t include_depth);


typedef void (*shaderc_include_result_release_fn)(
    void* user_data, shaderc_include_result* include_result);


SHADERC_EXPORT void shaderc_compile_options_set_include_callbacks(
    shaderc_compile_options_t options, shaderc_include_resolve_fn resolver,
    shaderc_include_result_release_fn result_releaser, void* user_data);





SHADERC_EXPORT void shaderc_compile_options_set_suppress_warnings(
    shaderc_compile_options_t options);




SHADERC_EXPORT void shaderc_compile_options_set_target_env(
    shaderc_compile_options_t options,
    shaderc_target_env target,
    uint32_t version);





SHADERC_EXPORT void shaderc_compile_options_set_warnings_as_errors(
    shaderc_compile_options_t options);


SHADERC_EXPORT void shaderc_compile_options_set_limit(
    shaderc_compile_options_t options, shaderc_limit limit, int value);



SHADERC_EXPORT void shaderc_compile_options_set_auto_bind_uniforms(
    shaderc_compile_options_t options, bool auto_bind);



SHADERC_EXPORT void shaderc_compile_options_set_hlsl_io_mapping(
    shaderc_compile_options_t options, bool hlsl_iomap);




SHADERC_EXPORT void shaderc_compile_options_set_hlsl_offsets(
    shaderc_compile_options_t options, bool hlsl_offsets);





SHADERC_EXPORT void shaderc_compile_options_set_binding_base(
    shaderc_compile_options_t options,
    shaderc_uniform_kind kind,
    uint32_t base);




SHADERC_EXPORT void shaderc_compile_options_set_binding_base_for_stage(
    shaderc_compile_options_t options, shaderc_shader_kind shader_kind,
    shaderc_uniform_kind kind, uint32_t base);



SHADERC_EXPORT void shaderc_compile_options_set_hlsl_register_set_and_binding_for_stage(
    shaderc_compile_options_t options, shaderc_shader_kind shader_kind,
    const char* reg, const char* set, const char* binding);



SHADERC_EXPORT void shaderc_compile_options_set_hlsl_register_set_and_binding(
    shaderc_compile_options_t options, const char* reg, const char* set,
    const char* binding);



typedef struct shaderc_compilation_result* shaderc_compilation_result_t;




















SHADERC_EXPORT shaderc_compilation_result_t shaderc_compile_into_spv(
    const shaderc_compiler_t compiler, const char* source_text,
    size_t source_text_size, shaderc_shader_kind shader_kind,
    const char* input_file_name, const char* entry_point_name,
    const shaderc_compile_options_t additional_options);




SHADERC_EXPORT shaderc_compilation_result_t shaderc_compile_into_spv_assembly(
    const shaderc_compiler_t compiler, const char* source_text,
    size_t source_text_size, shaderc_shader_kind shader_kind,
    const char* input_file_name, const char* entry_point_name,
    const shaderc_compile_options_t additional_options);



SHADERC_EXPORT shaderc_compilation_result_t shaderc_compile_into_preprocessed_text(
    const shaderc_compiler_t compiler, const char* source_text,
    size_t source_text_size, shaderc_shader_kind shader_kind,
    const char* input_file_name, const char* entry_point_name,
    const shaderc_compile_options_t additional_options);










SHADERC_EXPORT shaderc_compilation_result_t shaderc_assemble_into_spv(
    const shaderc_compiler_t compiler, const char* source_assembly,
    size_t source_assembly_size,
    const shaderc_compile_options_t additional_options);






SHADERC_EXPORT void shaderc_result_release(shaderc_compilation_result_t result);



SHADERC_EXPORT size_t shaderc_result_get_length(const shaderc_compilation_result_t result);


SHADERC_EXPORT size_t shaderc_result_get_num_warnings(
    const shaderc_compilation_result_t result);


SHADERC_EXPORT size_t shaderc_result_get_num_errors(const shaderc_compilation_result_t result);




SHADERC_EXPORT shaderc_compilation_status shaderc_result_get_compilation_status(
    const shaderc_compilation_result_t);






SHADERC_EXPORT const char* shaderc_result_get_bytes(const shaderc_compilation_result_t result);



SHADERC_EXPORT const char* shaderc_result_get_error_message(
    const shaderc_compilation_result_t result);


SHADERC_EXPORT void shaderc_get_spv_version(unsigned int* version, unsigned int* revision);





SHADERC_EXPORT bool shaderc_parse_version_profile(const char* str, int* version,
                                   shaderc_profile* profile);

#ifdef __cplusplus
}
#endif  

#endif  
