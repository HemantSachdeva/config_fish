function fish_prompt
    # This prompt shows:
    # - green lines if the last return command is OK, red otherwise
    # - your user name, in red if root or yellow otherwise
    # - your hostname, in cyan if ssh or blue otherwise
    # - the current path (with prompt_pwd)
    # - date +%X
    # - the current virtual environment, if any
    # - the current git status, if any, with fish_git_prompt
    # - the current battery state, if any, and if your power cable is unplugged, and if you have "acpi"
    # - current background jobs, if any

    # It goes from:
    # ┬─[nim@Hattori:~]─[11:39:00]
    # ╰─>$ echo here

    # To:
    # ┬─[nim@Hattori:~/w/dashboard]─[11:37:14]─[V:django20]─[G:master↑1|●1✚1…1]─[B:85%, 05:41:42 remaining]
    # │ 2	15054	0%	arrêtée	sleep 100000
    # │ 1	15048	0%	arrêtée	sleep 100000
    # ╰─>$ echo there

    set -l retc yellow
    test $status = 0; and set retc yellow

    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto

    function _nim_prompt_wrapper
        set retc $argv[1]
        set field_name $argv[2]
        set field_value $argv[3]

        set_color normal
        set_color $retc
        echo -n '─'
        set_color -o white
        echo -n '['
        set_color normal
        test -n $field_name
        and echo -n $field_name:
        set_color $retc
        test -n $field_value
        and echo -n $field_value
        set_color -o white
        echo -n ']'
    end

    set_color $retc
    echo -n '┬─'
    set_color -o white
    echo -n [
    if test "$USER" = root -o "$USER" = toor
        set_color -o yellow
    else
        set_color -o red
    end
    echo -n $USER
    set_color -o white
    echo -n ' at ' 
    if [ -z "$SSH_CLIENT" ]
        set_color -o white
    else
        set_color -o cyan
    end
    echo -n (prompt_hostname)
    #set_color -o yellow
    #echo -n :(prompt_pwd)
    set_color -o white
    echo -n ']'

    # Time
    #_nim_prompt_wrapper $retc '' ( date +%r)
    _nim_prompt_wrapper $retc '' :(prompt_pwd)
    # Date
    #and _nim_prompt_wrapper $retc '' (date +%x) 

    # Virtual Environment
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and _nim_prompt_wrapper $retc V (basename "$VIRTUAL_ENV")

    # git
    set prompt_git (fish_git_prompt | string trim -c ' ()')
    test -n "$prompt_git" 
    and _nim_prompt_wrapper $retc BR $prompt_git

    # Battery status
    #type -q acpi
    #and test (acpi -a 2> /dev/null | string match -r off)
    #and _nim_prompt_wrapper $retc B (acpi -b | cut -d' '  -f 4-)
    
    # Temperature
    #set prompt_temp (acpi -t)
    #test -n acpi 
    #and _nim_prompt_wrapper $retc T $prompt_temp
    
    
    #New line
    echo  
    #echo -n (prompt_hostname)
    set_color normal
    set_color $retc
    echo -n '╰─>'
    #echo -n '╰>'
    set_color -o white
    #echo -n [
    set_color normal
    set_color -o yellow
    echo -n '💀'
    #💀, 🦄, 👻
    #set_color -o white
    #echo -n ']'
    #set_color -o red
    #echo -n '$ '


    # Background jobs
    set_color normal
    for job in (jobs)
        set_color $retc
        echo -n '│ '
        set_color brown
        echo $job
    end
    
    #set_color normal
    #set_color $retc
    #echo -n '╰─>'
    #set_color -o red
    #echo -n '$ '
    #set_color normal
end
