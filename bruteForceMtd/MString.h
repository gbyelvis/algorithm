#ifndef MSTRING_H_INCLUDED
#define MSTRING_H_INCLUDED
/*
* BF algorithm matching string T to S;
*/
int BF(char* S, char* T)
{
    int i, j, index;
    i = 0; j = 0; index = 0;
    while(S[i] != '\0' && T[j] != '\0')
    {
        if(S[i] == T[j]){
            i++;
            j++;
        } else {
            index++;
            j = 0;
            i= index;
        }
    }
    if(T[j] == '\0') return index+1;
    else return 0;
}

/*
* KMP algorithm matching string T to S;
* next[j]={when j = 0; -1; when 1<=k<j && T[0]...T[k-1] = T[j-k]...T[j-1]; max(k); others; 0}
*/
void GetNext(char* T, int* next)
{
    int i, j, k;
    next[0] = -1;
    for(j = 1; T[j] != '\0'; j++)
    {
        for(k = j-1; k >= 1; k--)
        {
            for(i = 0; i < k; i++)
                if(T[i] != T[j-k+i]) break;
            if(i == k)
            {
                next[j] = k;
                break;
            }
        }
        if(k < 1) next[j] = 0;
    }
}

int KMP(char* S, char* T)
{
    int i, j;
    int* next;
    i = 0;
    j = 0;
    GetNext(T, next);
    while(S[i] != '\0' && T[j] != '\0')
    {
        if(S[i] == T[j]){
            i++;
            j++;
        } else {
            j = next[j];
            if(j == -1) {
                i++;
                j++;
            }
        }
    }
    if(T[j] == '\0') return (i - strlen(T)+1);
    else return 0;
}
#endif // MSTRING_H_INCLUDED
