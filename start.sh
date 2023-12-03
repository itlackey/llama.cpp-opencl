docker run -it \
--device /dev/dri \
--gpus all \
-p 3000:3000 \
-e GGML_OPENCL_PLATFORM=0 \
-e GGML_OPENCL_DEVICE=0 \
-v ~/ai/models/llama.cpp/models/:/models \
-v ~/ai/ipex/containers/llama-cpp-opencl:/apps \
itlackey/llama-cpp-opencl

# GGML_OPENCL_PLATFORM=1 ./main ...
# GGML_OPENCL_DEVICE=2 ./main ...
# GGML_OPENCL_PLATFORM=Intel ./main ...
# GGML_OPENCL_PLATFORM=AMD GGML_OPENCL_DEVICE=1 ./main ...