# First argument is the input file
# second argument is the speed up factor, default: 8 if not provided
function speed_up
  if test (count $argv) -eq 0
    echo "Usage: speed_up <input_file> [speed_up_factor:8]"
    return 1
  end

  set input_file $argv[1]
  set speed_up_factor $argv[2]
  if test -z $speed_up_factor
    set speed_up_factor 8
  end

  set output_file (echo $input_file | sed "s/\(.*\)\.\(.*\)/\1-fast.\2/")
  echo "Speeding up $input_file by $speed_up_factor times and saving to $output_file..."
  ffmpeg -i $input_file -filter:v "setpts=PTS/$speed_up_factor" -an $output_file
end
