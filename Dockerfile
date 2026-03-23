FROM runpod/worker-comfyui:5.7.1-base-cuda12.8.1

ENV PIP_BREAK_SYSTEM_PACKAGES=1
#ENV HF_ENDPOINT="http://192.168.88.33:8092"

WORKDIR /comfyui/custom_nodes

RUN pip3 install pycolmap
RUN pip3 install imageio
RUN pip3 install ffmpeg

RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
RUN git clone https://github.com/PozzettiAndrea/ComfyUI-MotionCapture
RUN git clone https://github.com/PozzettiAndrea/ComfyUI-HyMotion
RUN git clone https://github.com/PozzettiAndrea/ComfyUI-SAM3

WORKDIR /comfyui/custom_nodes/ComfyUI-MotionCapture
RUN pip3 install -r requirements.txt
WORKDIR /comfyui/custom_nodes/ComfyUI-HyMotion
RUN python3 install.py
WORKDIR /comfyui/custom_nodes/ComfyUI-VideoHelperSuite
RUN pip3 install -r requirements.txt
WORKDIR /comfyui/custom_nodes/ComfyUI-VideoHelperSuite
RUN pip3 install -r requirements.txt
WORKDIR /comfyui/custom_nodes/ComfyUI-SAM3
RUN git checkout $(git rev-list -n 1 --before="2026-02-22" main)
RUN pip3 install -r requirements.txt
RUN rm -rf /comfyui/models
RUN ln -s /runpod-volume/models /comfyui/models
RUN rm -rf /comfyui/output
RUN ln -s /runpod-volume/output /comfyui/output

COPY ./patches/ /
