













#ifndef SHADERC_SHADERC_HPP_
#define SHADERC_SHADERC_HPP_

#include <memory>
#include <string>
#include <vector>

#include "shaderc.h"

namespace shaderc {












template <typename OutputElementType>
class CompilationResult {
 public:
  typedef OutputElementType element_type;
  
  
  typedef const OutputElementType* const_iterator;

  
  
  
  explicit CompilationResult(shaderc_compilation_result_t compilation_result)
      : compilation_result_(compilation_result) {}
  ~CompilationResult() { shaderc_result_release(compilation_result_); }

  CompilationResult(CompilationResult&& other) {
    compilation_result_ = other.compilation_result_;
    other.compilation_result_ = nullptr;
  }

  
  std::string GetErrorMessage() const {
    if (!compilation_result_) {
      return "";
    }
    return shaderc_result_get_error_message(compilation_result_);
  }

  
  
  
  shaderc_compilation_status GetCompilationStatus() const {
    if (!compilation_result_) {
      return shaderc_compilation_status_null_result_object;
    }
    return shaderc_result_get_compilation_status(compilation_result_);
  }

  
  
  
  const_iterator cbegin() const {
    if (!compilation_result_) return nullptr;
    return reinterpret_cast<const_iterator>(
        shaderc_result_get_bytes(compilation_result_));
  }

  
  
  
  const_iterator cend() const {
    if (!compilation_result_) return nullptr;
    return cbegin() +
           shaderc_result_get_length(compilation_result_) /
               sizeof(OutputElementType);
  }

  
  const_iterator begin() const { return cbegin(); }
  
  const_iterator end() const { return cend(); }

  
  size_t GetNumWarnings() const {
    if (!compilation_result_) {
      return 0;
    }
    return shaderc_result_get_num_warnings(compilation_result_);
  }

  
  size_t GetNumErrors() const {
    if (!compilation_result_) {
      return 0;
    }
    return shaderc_result_get_num_errors(compilation_result_);
  }

 private:
  CompilationResult(const CompilationResult& other) = delete;
  CompilationResult& operator=(const CompilationResult& other) = delete;

  shaderc_compilation_result_t compilation_result_;
};



using SpvCompilationResult = CompilationResult<uint32_t>;

using AssemblyCompilationResult = CompilationResult<char>;

using PreprocessedSourceCompilationResult = CompilationResult<char>;


class CompileOptions {
 public:
  CompileOptions() { options_ = shaderc_compile_options_initialize(); }
  ~CompileOptions() { shaderc_compile_options_release(options_); }
  CompileOptions(const CompileOptions& other) {
    options_ = shaderc_compile_options_clone(other.options_);
  }
  CompileOptions(CompileOptions&& other) {
    options_ = other.options_;
    other.options_ = nullptr;
  }

  
  
  void AddMacroDefinition(const char* name, size_t name_length,
                          const char* value, size_t value_length) {
    shaderc_compile_options_add_macro_definition(options_, name, name_length,
                                                 value, value_length);
  }

  
  void AddMacroDefinition(const std::string& name) {
    AddMacroDefinition(name.c_str(), name.size(), nullptr, 0u);
  }

  
  void AddMacroDefinition(const std::string& name, const std::string& value) {
    AddMacroDefinition(name.c_str(), name.size(), value.c_str(), value.size());
  }

  
  void SetGenerateDebugInfo() {
    shaderc_compile_options_set_generate_debug_info(options_);
  }

  
  
  void SetOptimizationLevel(shaderc_optimization_level level) {
    shaderc_compile_options_set_optimization_level(options_, level);
  }

  
  class IncluderInterface {
   public:
    
    virtual shaderc_include_result* GetInclude(const char* requested_source,
                                               shaderc_include_type type,
                                               const char* requesting_source,
                                               size_t include_depth) = 0;

    
    virtual void ReleaseInclude(shaderc_include_result* data) = 0;

    virtual ~IncluderInterface() = default;
  };

  
  
  
  void SetIncluder(std::unique_ptr<IncluderInterface>&& includer) {
    includer_ = std::move(includer);
    shaderc_compile_options_set_include_callbacks(
        options_,
        [](void* user_data, const char* requested_source, int type,
           const char* requesting_source, size_t include_depth) {
          auto* includer = static_cast<IncluderInterface*>(user_data);
          return includer->GetInclude(requested_source,
                                      (shaderc_include_type)type,
                                      requesting_source, include_depth);
        },
        [](void* user_data, shaderc_include_result* include_result) {
          auto* includer = static_cast<IncluderInterface*>(user_data);
          return includer->ReleaseInclude(include_result);
        },
        includer_.get());
  }

  
  
  
  
  
  void SetForcedVersionProfile(int version, shaderc_profile profile) {
    shaderc_compile_options_set_forced_version_profile(options_, version,
                                                       profile);
  }

  
  
  
  
  void SetSuppressWarnings() {
    shaderc_compile_options_set_suppress_warnings(options_);
  }

  
  void SetSourceLanguage(shaderc_source_language lang) {
    shaderc_compile_options_set_source_language(options_, lang);
  }

  
  
  
  
  
  void SetTargetEnvironment(shaderc_target_env target, uint32_t version) {
    shaderc_compile_options_set_target_env(options_, target, version);
  }

  
  
  
  
  void SetWarningsAsErrors() {
    shaderc_compile_options_set_warnings_as_errors(options_);
  }

  
  void SetLimit(shaderc_limit limit, int value) {
    shaderc_compile_options_set_limit(options_, limit, value);
  }

  
  
  void SetAutoBindUniforms(bool auto_bind) {
    shaderc_compile_options_set_auto_bind_uniforms(options_, auto_bind);
  }

  
  
  void SetHlslIoMapping(bool hlsl_iomap) {
    shaderc_compile_options_set_hlsl_io_mapping(options_, hlsl_iomap);
  }

  
  
  
  void SetHlslOffsets(bool hlsl_offsets) {
    shaderc_compile_options_set_hlsl_offsets(options_, hlsl_offsets);
  }

  
  
  
  
  void SetBindingBase(shaderc_uniform_kind kind, uint32_t base) {
    shaderc_compile_options_set_binding_base(options_, kind, base);
  }

  
  
  
  void SetBindingBaseForStage(shaderc_shader_kind shader_kind,
                              shaderc_uniform_kind kind, uint32_t base) {
    shaderc_compile_options_set_binding_base_for_stage(options_, shader_kind,
                                                       kind, base);
  }

  
  
  void SetHlslRegisterSetAndBindingForStage(shaderc_shader_kind shader_kind,
                                            const std::string& reg,
                                            const std::string& set,
                                            const std::string& binding) {
    shaderc_compile_options_set_hlsl_register_set_and_binding_for_stage(
        options_, shader_kind, reg.c_str(), set.c_str(), binding.c_str());
  }

  
  
  void SetHlslRegisterSetAndBinding(const std::string& reg,
                                    const std::string& set,
                                    const std::string& binding) {
    shaderc_compile_options_set_hlsl_register_set_and_binding(
        options_, reg.c_str(), set.c_str(), binding.c_str());
  }

 private:
  CompileOptions& operator=(const CompileOptions& other) = delete;
  shaderc_compile_options_t options_;
  std::unique_ptr<IncluderInterface> includer_;

  friend class Compiler;
};


class Compiler {
 public:
  Compiler() : compiler_(shaderc_compiler_initialize()) {}
  ~Compiler() { shaderc_compiler_release(compiler_); }

  Compiler(Compiler&& other) {
    compiler_ = other.compiler_;
    other.compiler_ = nullptr;
  }

  bool IsValid() const { return compiler_ != nullptr; }

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  SpvCompilationResult CompileGlslToSpv(const char* source_text,
                                        size_t source_text_size,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name,
                                        const char* entry_point_name,
                                        const CompileOptions& options) const {
    shaderc_compilation_result_t compilation_result = shaderc_compile_into_spv(
        compiler_, source_text, source_text_size, shader_kind, input_file_name,
        entry_point_name, options.options_);
    return SpvCompilationResult(compilation_result);
  }

  
  
  
  
  SpvCompilationResult CompileGlslToSpv(const char* source_text,
                                        size_t source_text_size,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name,
                                        const CompileOptions& options) const {
    return CompileGlslToSpv(source_text, source_text_size, shader_kind,
                            input_file_name, "main", options);
  }

  
  
  
  SpvCompilationResult CompileGlslToSpv(const char* source_text,
                                        size_t source_text_size,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name) const {
    shaderc_compilation_result_t compilation_result =
        shaderc_compile_into_spv(compiler_, source_text, source_text_size,
                                 shader_kind, input_file_name, "main", nullptr);
    return SpvCompilationResult(compilation_result);
  }

  
  
  
  
  SpvCompilationResult CompileGlslToSpv(const std::string& source_text,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name,
                                        const CompileOptions& options) const {
    return CompileGlslToSpv(source_text.data(), source_text.size(), shader_kind,
                            input_file_name, options);
  }

  
  
  
  
  SpvCompilationResult CompileGlslToSpv(const std::string& source_text,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name,
                                        const char* entry_point_name,
                                        const CompileOptions& options) const {
    return CompileGlslToSpv(source_text.data(), source_text.size(), shader_kind,
                            input_file_name, entry_point_name, options);
  }

  
  
  
  
  SpvCompilationResult CompileGlslToSpv(const std::string& source_text,
                                        shaderc_shader_kind shader_kind,
                                        const char* input_file_name) const {
    return CompileGlslToSpv(source_text.data(), source_text.size(), shader_kind,
                            input_file_name);
  }

  
  
  
  
  
  
  
  
  SpvCompilationResult AssembleToSpv(const char* source_assembly,
                                     size_t source_assembly_size,
                                     const CompileOptions& options) const {
    return SpvCompilationResult(shaderc_assemble_into_spv(
        compiler_, source_assembly, source_assembly_size, options.options_));
  }

  
  
  
  SpvCompilationResult AssembleToSpv(const char* source_assembly,
                                     size_t source_assembly_size) const {
    return SpvCompilationResult(shaderc_assemble_into_spv(
        compiler_, source_assembly, source_assembly_size, nullptr));
  }

  
  
  
  
  SpvCompilationResult AssembleToSpv(const std::string& source_assembly,
                                     const CompileOptions& options) const {
    return SpvCompilationResult(
        shaderc_assemble_into_spv(compiler_, source_assembly.data(),
                                  source_assembly.size(), options.options_));
  }

  
  
  
  
  SpvCompilationResult AssembleToSpv(const std::string& source_assembly) const {
    return SpvCompilationResult(shaderc_assemble_into_spv(
        compiler_, source_assembly.data(), source_assembly.size(), nullptr));
  }

  
  
  
  AssemblyCompilationResult CompileGlslToSpvAssembly(
      const char* source_text, size_t source_text_size,
      shaderc_shader_kind shader_kind, const char* input_file_name,
      const char* entry_point_name, const CompileOptions& options) const {
    shaderc_compilation_result_t compilation_result =
        shaderc_compile_into_spv_assembly(
            compiler_, source_text, source_text_size, shader_kind,
            input_file_name, entry_point_name, options.options_);
    return AssemblyCompilationResult(compilation_result);
  }

  
  
  
  AssemblyCompilationResult CompileGlslToSpvAssembly(
      const char* source_text, size_t source_text_size,
      shaderc_shader_kind shader_kind, const char* input_file_name,
      const CompileOptions& options) const {
    return CompileGlslToSpvAssembly(source_text, source_text_size, shader_kind,
                                    input_file_name, "main", options);
  }

  
  
  
  
  AssemblyCompilationResult CompileGlslToSpvAssembly(
      const std::string& source_text, shaderc_shader_kind shader_kind,
      const char* input_file_name, const char* entry_point_name,
      const CompileOptions& options) const {
    return CompileGlslToSpvAssembly(source_text.data(), source_text.size(),
                                    shader_kind, input_file_name,
                                    entry_point_name, options);
  }

  
  
  
  AssemblyCompilationResult CompileGlslToSpvAssembly(
      const std::string& source_text, shaderc_shader_kind shader_kind,
      const char* input_file_name, const CompileOptions& options) const {
    return CompileGlslToSpvAssembly(source_text, shader_kind, input_file_name,
                                    "main", options);
  }

  
  
  
  PreprocessedSourceCompilationResult PreprocessGlsl(
      const char* source_text, size_t source_text_size,
      shaderc_shader_kind shader_kind, const char* input_file_name,
      const CompileOptions& options) const {
    shaderc_compilation_result_t compilation_result =
        shaderc_compile_into_preprocessed_text(
            compiler_, source_text, source_text_size, shader_kind,
            input_file_name, "main", options.options_);
    return PreprocessedSourceCompilationResult(compilation_result);
  }

  
  
  
  PreprocessedSourceCompilationResult PreprocessGlsl(
      const std::string& source_text, shaderc_shader_kind shader_kind,
      const char* input_file_name, const CompileOptions& options) const {
    return PreprocessGlsl(source_text.data(), source_text.size(), shader_kind,
                          input_file_name, options);
  }

 private:
  Compiler(const Compiler&) = delete;
  Compiler& operator=(const Compiler& other) = delete;

  shaderc_compiler_t compiler_;
};
}  

#endif  
