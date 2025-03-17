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
CPU_CORES=$(sysctl -n hw.ncpu) # macOS-specific core count

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

# Set optimal bitrate based on resolution
if [ "$RESOLUTION" -ge 2160 ]; then BITRATE="10000k"
elif [ "$RESOLUTION" -ge 1440 ]; then BITRATE="8000k"
else BITRATE="5000k"
fi

echo "Processing video to ${SPEED}x speed, using GPU acceleration (Metal/VideoToolbox)..."

ffmpeg -hide_banner -y -hwaccel videotoolbox -i "$OUTPUT_DIR/$FILENAME.mkv" \
-filter_complex "[0:v]setpts=PTS/${SPEED}[v]; \
                 [0:a]rubberband=tempo=${SPEED}:formant=1.0:pitch=1.0[a]" \
-map "[v]" -map "[a]" \
-c:v hevc_videotoolbox -b:v "$BITRATE" -preset faster \
-c:a aac -b:a 320k \
-threads "$CPU_CORES" \
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
