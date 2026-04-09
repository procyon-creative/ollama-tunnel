set -l script_dir (cd (dirname (status filename)); and pwd)

function ollama
    $script_dir/ollama-run.sh $argv
end

complete -c ollama -f -a "serve create show run push pull cp rm list ps stop help"
