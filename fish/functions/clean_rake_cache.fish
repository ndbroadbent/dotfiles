function clean_rake_cache -d 'Clean the rake autocomplete cache'
  for file in cache_path /tmp/rake_completion/$USER/*
    rm "$file"
  end
end
