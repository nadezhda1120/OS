#include <err.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

int main(int argc, char* argv[]){
        if (argc != 2){
                errx(1, "wrong number of arguments!");
        }

        int fd = open(argv[1], O_RDWR);
        if (fd == -1){
                err(2, "Open failure!");
        }

        uint8_t buffer;
        uint8_t counting[255] = {0};
        int rs;

        while ((rs = read(fd, &buffer, sizeof(buffer)) != 0)){
                if (rs == -1){
                        close(fd);
                        err(3, "Reading failure");
                }
                counting[buffer]++;
        }

        lseek(fd, 0, SEEK_SET);

        for (uint8_t i = 0; i < 255; i++){
                for (uint8_t j = 0; j < counting[i]; j++){
                        if(write(fd, &i, sizeof(i)) != sizeof(i)){
                                        close(fd);
                                        err(4, "writing failure");
                        }

                }

        }

        close(fd);
        exit(0);

}
