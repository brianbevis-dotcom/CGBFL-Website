#!/bin/bash
# Cut CG Bantam Playbook.MOV into 720p family videos.
# Run from the folder containing the MOV. Requires ffmpeg.
SRC="CG Bantam Playbook.MOV"

# Formations & Motions
ffmpeg -ss 0.0 -i "$SRC" -t 109.0 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-formations.mp4"

# Sweep & Ice
ffmpeg -ss 106.5 -i "$SRC" -t 94.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-sweep.mp4"

# Double Dive
ffmpeg -ss 207.5 -i "$SRC" -t 24.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-doubledive.mp4"

# Belly & Weak Belly
ffmpeg -ss 237.5 -i "$SRC" -t 125.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-belly.mp4"

# Jet & Weak Jet
ffmpeg -ss 376.5 -i "$SRC" -t 80.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-jet.mp4"

# Scissors
ffmpeg -ss 461.5 -i "$SRC" -t 24.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-scissors.mp4"

# Down
ffmpeg -ss 505.5 -i "$SRC" -t 25.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-down.mp4"

# Boot
ffmpeg -ss 544.5 -i "$SRC" -t 43.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-boot.mp4"

# Play Action Pass
ffmpeg -ss 605.5 -i "$SRC" -t 56.5 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-base-papass.mp4"

# Shotgun (all 15 plays, one file)
ffmpeg -ss 0.0 -i "$SRC" -t 243.0 \
  -vf "scale=-2:720" -c:v libx264 -preset slow -crf 25 -maxrate 1500k -bufsize 3000k -g 30 \
  -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 \
  "playbook-shotgun.mp4"

