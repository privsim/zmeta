#!/usr/bin/env bash

# Ensure URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube_URL> [speed_multiplier] [--cleanup]"
    exit 1
fi

# Input variables
URL="$1"
SPEED=${2:-2.0} # Default 2.0x speed
OUTPUT_DIR="./downloads"
FILENAME="original"
FINAL_FILENAME="final_output"
CPU_CORES=$(nproc --all)

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Download highest quality video
echo "Downloading best quality video from $URL..."
yt-dlp -f "bv*+ba/b" --merge-output-format mkv -o "$OUTPUT_DIR/$FILENAME.mkv" "$URL"

# Validate download
if [ ! -f "$OUTPUT_DIR/$FILENAME.mkv" ]; then
    echo "Error: Download failed."
    exit 1
fi

# Extract video resolution
RESOLUTION=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$OUTPUT_DIR/$FILENAME.mkv")

# Set optimal CRF based on resolution
if [ "$RESOLUTION" -ge 2160 ]; then CRF=20
elif [ "$RESOLUTION" -ge 1440 ]; then CRF=18
else CRF=16
fi

echo "Processing video to ${SPEED}x speed, using CRF ${CRF}..."
ffmpeg -i "$OUTPUT_DIR/$FILENAME.mkv" \
-filter_complex "[0:v]setpts=PTS/${SPEED}[v];[0:a]rubberband=tempo=${SPEED}[a]" \
-map "[v]" -map "[a]" \
-c:v libx265 -crf "$CRF" -preset slower -threads "$CPU_CORES" \
-c:a aac -b:a 320k \
"$OUTPUT_DIR/$FINAL_FILENAME.mkv"

# Validate encoding
if [ $? -eq 0 ]; then
    echo "Processing complete! File saved as: $OUTPUT_DIR/$FINAL_FILENAME.mkv"

    # Cleanup option
    if [ "$3" == "--cleanup" ]; then
        rm "$OUTPUT_DIR/$FILENAME.mkv"
        echo "Original file removed."
    fi
else
    echo "Error: Processing failed."
    exit 1
fi
