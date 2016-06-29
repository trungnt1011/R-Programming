num = 0
while(num < 3){
    name <- readline("Hey dude, what’s your name = ")
    cat('hello', name,'\n')
    cat('passwork is name of friend')
    pass <- readline("Please enter password:  \n")
    if(pass == "meo"){
        print('Yes! Correct')
        {break}
    } else {
        num <- num + 1
        print('Not correct! please exit, thanks you')
    }   
}