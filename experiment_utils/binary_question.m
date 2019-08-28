function answer = binary_question(msg)
while true
    r = input(msg,'s');
    r = lower(r);
    switch r
        case 'y'
            answer = true;
            break
        case 'n'
            answer = false;
            break
        otherwise
            continue
    end
end