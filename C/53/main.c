#include <stdlib.h>
#include <err.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>

int main(int argc, char **argv){
        if (argc != 4){
                errx(1, "Not enough arguments");
        }

        const char *f1 = argv[1];
        const char *f2 = argv[2];
        struct stat s1;
        struct stat s2;

        if (stat(f1, &s1) == -1){
                err(2, "Error while stat file %s", f1);
        }

        if (stat(f2, &s2) == -1){
                err(3, "Error while stat file %s", f2);
        }

        off_t sz1 = s1.st_size, sz2 = s2.st_size;

// check if size greater than 4 bytes 625535


        if (sz1 != sz2){
                errx(4, "files are not consistent %s, %s", f1, f2);
        }

        struct triple_t{
                uint16_t offset ;
                uint8_t b1;
                uint8_t b2;
        }__attribute__((packed));

        int fd1 = open(f1, O_RDONLY);
        int fd2 = open(f2, O_RDONLY);
        if (fd1 == -1){
                errx(5, "ERROR: while opening %s", f1);
        }

        if ( fd2 == -1){
                const int _errno = errno;
                close(fd1);
                errno = _errno;
                errx(6, "ERROR: while opening file %s", f2);
        }
        const char* f3 = argv[3];
        int fd3 = open(f3, O_APPEND |O_CREAT |O_TRUNC | O_RDWR ,S_IRWXU);

        if ( fd3 == -1){
                const int _errno = errno;
                close(fd1);
                close(fd2);
                errno = _errno;
                err(7, "ERROR: while opening file %s", f3);
         }

        ssize_t rd1 = -1, rd2 = -1;
        struct triple_t p;

        for (p.offset = 0; p.offset < sz1; p.offset++){
                if ( (rd1 = read(fd1,&p.b1, sizeof(p.b1))) != sizeof(p.b1)){
                        close(fd1);
                        close(fd2);
                        close(fd3);
                        errx(7, "ERROR: while reading file %s", f1);
                }
                if ( (rd2 = read(fd2,&p.b2, sizeof(p.b2))) != sizeof(p.b2)){
                        close(fd1);
                        close(fd2);
                        close(fd3);
                        errx(7, "ERROR: while reading file %s", f2);
                }

                if (p.b1 != p.b2){
                        ssize_t wr = write(fd3, &p, sizeof(p));
                        if (wr == -1 || wr != sizeof(p)){
                                const int _errno = errno;
                                close(fd1);
                                close(fd2);
                                close(fd3);
                                errno = _errno;
                                errx(8, "ERROR: while writing in %s", f3);
                        }

                }

        }

        if (rd1 == -1 || rd2 == -2){
                const int _errno = errno;
                close(fd1);
                close(fd2);
                close(fd3);
                errno = _errno;
                errx(9, "ERROR: while reading from file %s and %s", f1, f2);
        }

        close(fd1);
        close(fd2);
        close(fd3);

        exit(0);


}
