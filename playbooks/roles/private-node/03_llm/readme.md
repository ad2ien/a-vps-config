# LLM

Deploys a specific version of Ollama and webui made from : https://github.com/robertrosenbusch/gfx803_rocm

with sligth fixes :

```patch
diff --git a/Dockerfile_rocm64_ollama b/Dockerfile_rocm64_ollama
index dfae519..9240832 100644
--- a/Dockerfile_rocm64_ollama
+++ b/Dockerfile_rocm64_ollama
@@ -10,6 +10,7 @@ ENV OLLAMA_WEBGUI_PORT=8080 \
     OLLAMA_HOST=0.0.0.0\
     # To Install and enable ollama WEBUI set OLLAMA_WEBUI=1, to disable change it to "0"
     OLLAMA_WEBUI=1 \
+    JOBLIB_START_METHOD=fork \
     COMMANDLINE_ARGS='' 
 
 ## Checkout interactive LLM Benchmark for Ollama
@@ -24,7 +25,7 @@ RUN pip install -r requirements.txt --break-system-packages && \
 
 ## Install Open WebUI    
 WORKDIR / 
-RUN if [[ $OLLAMA_WEBUI == "1" ]]; then echo "INSTALL OPEN-WEBUI";curl -LsSf https://astral.sh/uv/install.sh | sh; pip install open-webui --break-system-packages; else echo "NO OPEN-WEBUI"; fi &&\
+RUN if [[ $OLLAMA_WEBUI == "1" ]]; then echo "INSTALL OPEN-WEBUI";curl -LsSf https://astral.sh/uv/install.sh | sh; pip install open-webui --break-system-packages --ignore-installed; else echo "NO OPEN-WEBUI"; fi &&\
     true
 
 ## Checkout Ollama
```

Deploy and create an admin account.