
#curl http://localhost:3000/props

curl --request POST \
    --url http://localhost:3000/completion \
    --header "Content-Type: application/json" \
    --data '{"prompt": "Building a website can be done in 10 simple steps:","n_predict": 128}'