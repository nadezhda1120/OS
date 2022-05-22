#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int numerate = 0;
int counter = 1;
void read_helper(int fd, const char* from){
        char c;
        ssize_t rd;

        int newline = 1;
        while ( (rd = read(fd, &c, sizeof(c))) > 0){
                if (numerate){
                        if (newline){
                                setbuf(stdout, NULL);
                                fprintf(stdout, "%d ", counter);
                                write(1, &c, sizeof(c));
                                counter++;
                                newline = 0;
                        }else{
                                write(1, &c, sizeof(c));
                        }
                        if (c == '\n') newline = 1;

                }
                else{
                        write(1, &c, sizeof(c));
                }

        }
    if(rd == -1){
        int _errno=errno;
        close(fd);
        errno=_errno;
        err(4,"error while reading %s", from);
    }


}


int main(int argc, char* argv[]){
        if (argc == 1){
                read_helper(0, "STDIN");
                exit(0);
        }

        int i = 1;
        if(strcmp(argv[i], "-n") == 0){
                numerate = 1;
                i++;
        }

        for( ; i < argc; i++){
                if ( strcmp(argv[i], "-") == 0){
                        read_helper(0, "STDIN");
                        continue;
                }
                const char *filepath = argv[i];
                struct stat st;

                if ( stat(filepath, &st) == -1){
                        errx(1, "Error while stat");
                }
                if ( !S_ISREG(st.st_mode) ){

                        errx(2, "Error: its not regular file");
                }


                int fd = open(filepath, O_RDONLY);
                if ( fd == -1){
                        errx( 1, "error while opening %s", filepath);
                }

                read_helper(fd, "filepath");
                close(fd);
        }

        exit(0);
}

