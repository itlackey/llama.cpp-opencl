
# https://github.com/ggerganov/llama.cpp/blob/master/examples/server/README.md
MODEL_NAME=wizardlm-1.0-uncensored-llama2-13b.Q5_K_M.gguf
MODEL_NAME=llama-2-7b-chat.Q4_0.gguf

./build/bin/server -m /models/$MODEL_NAME -c 2048 --port 3000 -ngl 41  --host 0.0.0.0