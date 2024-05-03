#!/bin/bash

src_dir="$HOME/Atsiuntimai/"
dst_dir="$HOME/Obsidian/notes/"
docs_dir="$HOME/Dokumentai/"
music_dir="$HOME/Muzika/"
video_dir="$HOME/Video/"
images_dir="$HOME/Paveikslėliai/"
zip_dir="$HOME/Archyvuoti/"

if ! ls "$src_dir"/*.md >/dev/null 2>&1; then
  echo "Nėra .md failų Atsisiuntimų kataloge"
else
  for file in "$src_dir"*.md; do
    filename="${file%%.*}"
    dst_file="${dst_dir}$(basename "$filename").md"
    if [ -f "$dst_file" ]; then
      echo "Failas $file jau egzistuoja kataloge $dst_dir"
    else
      mv "$file" "$dst_file"
      echo "Perkeltas failas $file į katalogą $dst_dir"
    fi
  done
fi

move_files() {
  local extensions=("$@")
  local target_dir="${extensions[-1]}"
  unset 'extensions[${#extensions[@]}-1]'

  for ext in "${extensions[@]}"; do
    shopt -s nullglob
    files=("$src_dir"/*.$ext)
    shopt -u nullglob
    if [ ${#files[@]} -eq 0 ]; then
      echo "Nėra .$ext failų Atsisiuntimų kataloge"
    else
      for file in "${files[@]}"; do
        if [ -f "$file" ]; then
          mv "$file" "$target_dir"
          echo "Perkeltas failas $file į katalogą $target_dir"
        fi
      done
    fi
  done
}



move_files "pdf" "doc" "docx" "epub" "txt" "$docs_dir"
move_files "mp3" "$music_dir"
move_files "avi" "mpeg" "mkv" "$video_dir"
move_files "jpg" "jpeg" "png" "gif" "webp" "svg" "$images_dir"
move_files "zip" "tar" "gzip" "bzip2" "xz" "7z" "$zip_dir"
