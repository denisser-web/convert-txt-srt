#!/bin/bash
if [ "$#" -lt 1 ]; then
  echo "Syntax: convert-txt-srt.sh file.txt"
  exit
fi

# Получаем имя входного файла
input_file=$1

# Получаем расширение входного файла
input_ext=$2

# Разделитель между миллисекундами в субтитрах srt - "," vtt - "."
if [ "$input_ext" == "vtt" ]; then
    # Генерация для vtt
    input_ext="vtt"
    splitter="."
else
    # Генерация для srt
    input_ext="srt"
    splitter=","
fi

output_file="${input_file%.*}.${input_ext}"
# Очистка файла, если он уже существует
echo "" > "$output_file"

if [ "$input_ext" == "vtt" ]; then
  echo "WEBVTT" > "$output_file"
fi

# Счетчик субтитров
counter=1

# Инициализируем переменную для хранения предыдущей временной метки
prev_time=""

# Проходим по каждой строке входного файла
while IFS= read -r line
do
    # Проверяем, является ли строка временным интервалом в формате HH:MM:SS:FF - HH:MM:SS:FF
    if [[ $line =~ ^[[:digit:]:]+[[:space:]]-[[:space:]][[:digit:]:]+ ]]; then
        # Извлекаем начало и конец временного интервала
        start_time=$(echo "$line" | awk -F'-' '{print $1}')
        end_time=$(echo "$line" | awk -F'-' '{print $2}')
        # Преобразуем начало и конец интервала в формат SRT субтитров
        start_srt=$(echo "$start_time" | awk -v splitter="$splitter" -F':' '{printf "%02d:%02d:%02d'$splitter'%02d0", int($1), int($2), int($3), int($4)}')
        end_srt=$(echo "$end_time" | awk -v splitter="$splitter" -F':' '{printf "%02d:%02d:%02d'$splitter'%02d0", int($1), int($2), int($3), int($4)}')

        # Создаем временной интервал в формате SRT
        time="$start_srt --> $end_srt"

        # Если временная ветка совпадает с предыдущей, пропускаем ее
        if [[ "$time" == "$prev_time" ]]
          then
              continue
          fi

        # Добавляем пробел между субтитрами
        if [[ $counter -gt 1 ]] || [[ $input_ext == "vtt" ]]; then
          echo "" >> "$output_file"
        fi

        echo "$counter" >> "$output_file"
        echo "$time" >> "$output_file"

        prev_time=$time
        counter=$((counter+1))

    # Проверяем, начинается ли строка с букв V и запятой
    elif [[ $line =~ ^V[[:digit:]]+,[[:space:]]Text ]]; then
        continue
    # Добавляем субтитр к выходному файла, если это не пустая строка
    elif [[ $line =~ ^[[:alnum:]]+ ]]; then
        echo "$line" >> "$output_file"
    fi

done < "$input_file"

echo "$input_file - completed"

