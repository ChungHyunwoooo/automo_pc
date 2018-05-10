#include <stdio.h>

int main(){
    FILE *fd = fopen("init.mem","w+");
    int buff[32];
    int input;
    int temp;
    int i,j;
    int result = 0;

    printf("Insert CGES number: ");
    scanf("%d",&input);

    for(i=0;i<input;i++){
        temp = i;
        result += i;
        for(j=0;j<32;j++){
            buff[j]=temp%2;
            temp >>= 1;
        }
        for (j = 0; j < 32; j++)
        {
            fprintf(fd,"%d", buff[31-j]);
        }
        fprintf(fd, "\n");
    }
    printf("%d\n", result);
}