#!/bin/bash
safe_download(){
 url="$1"; out="$2"
 wget --timeout=20 --tries=3 -q -O "$out" "$url" || { echo "Download failed: $url"; return 1; }
 [ -s "$out" ] || { echo "Empty download: $out"; return 1; }
}
