FROM senpaidev/opencv-tf-py3-arm64:latest

WORKDIR /root/

COPY /app/ /root/app/

WORKDIR /root/app/

CMD ["python3", "/root/app/detect_mask_picam_buzzer.py"]


