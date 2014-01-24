" Count the occurrences of char in files
function! CountChar (c) range
    let lnum = a:firstline
    let n    = 0
    
    while lnum < a:lastline
        let n = n + strlen(substitute(getline(lnum),'[^'.a:c.']','','g'))
        let lnum = lnum + 1
    endwhile
    echo "there are ".n." <".a:c.">"
endfunction!
