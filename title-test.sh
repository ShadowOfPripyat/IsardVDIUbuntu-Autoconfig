# Function to print gradient ASCII title
print_gradient_title() {
    local lines=$(tput lines)
    local color1=$'\e[38;5;39m'  # Blue
    local color2=$'\e[38;5;198m' # Orange

    title="
    ____                    __   ______            _____                        __            
   /  _/________ __________/ /  / ____/___  ____  / __(_)___ ___  ___________ _/ /_____  _____
   / // ___/ __ \`/ ___/ __  /  / /   / __ \/ __ \/ /_/ /  _ \`/ / / / _/ __ \` __/ __ \/ ___/
 _/ /(__  ) /_/ / /  / /_/ /  / /___/ /_/ / / / / __/ / /_/ / /_/ / /  / /_/ / /_/ /_/ / /    
/___/____/\__,_/_/   \__,_/   \____/\____/_/ /_/_/ /_/\__, /\__,_/_/   \__,_/\__/\____/_/     
                                                     /____/
"

    printf "\n"
    printf "%*s\n" $(((${#title}+lines)/2)) | tr ' ' '*'
    printf "\n"

    for ((i=0; i<lines; i++)); do
        local ratio=$(bc <<< "scale=2; $i/$lines")
        local r=$(printf "%.0f" $(bc <<< "scale=2; (1-$ratio)*255"))
        local g=$(printf "%.0f" $(bc <<< "scale=2; $ratio*255"))
        local color=$'\e[38;2;'$r';'$g';0m'
        printf "%s%s" "$color1" "$color2" | tr "$color1$color2" "$color$color"
    done

    printf "\n\n"
    printf "%*s\n\n" $(((${#title}+lines)/2)) | tr ' ' '*'
    printf "\n"

    tput sgr0
}
