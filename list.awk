BEGIN {
    time = strftime("%F %R");
    printf "\033[34mDeadline          State  Task\033[0m\n";
    infuture = 0;
}

/TODO|DONE/ {
    if (infuture == 0 && time < $1) {
        for (i = 0; i < width; i++) {
            printf "―"
        }
        printf "\033[0m\n";
        infuture = 1;
    }
    printf "%s  ", $1;
}

/TODO/ {
    printf "\033[31m";
}

/DONE/ {
    printf "\033[32m";  
}

/TODO|DONE/ {
    printf "%s\033[0m   %s\n", $2, $3;
}
