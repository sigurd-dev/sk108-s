/*
  April 2018 (C) Sigurd Dagestad
  To make the program treat the received data as ASCII codes, compile the program with the symbol    
  DISPLAY_STRING, e.g.  
  Compile with:
  gcc writesk108s.c -o writesk108s
  (gcc -DDISPLAY_STRING writesk108s.c -o writesk108s)
  Se flott eksempel: https://stackoverflow.com/questions/6947413/how-to-open-read-and-write-from-serial-port-in-c
*/

#include <errno.h>
#include <fcntl.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#include <stdint.h> 


int set_interface_attribs(int fd, int speed)
{
    struct termios tty;

    if (tcgetattr(fd, &tty) < 0) {
        printf("Error from tcgetattr: %s\n", strerror(errno));
        return -1;
    }

    cfsetospeed(&tty, (speed_t)speed);
    cfsetispeed(&tty, (speed_t)speed);

    tty.c_cflag |= (CLOCAL | CREAD);    /* ignore modem controls */
    tty.c_cflag &= ~CSIZE;
    tty.c_cflag |= CS8;         /* 8-bit characters */
    tty.c_cflag &= ~PARENB;     /* no parity bit */
    tty.c_cflag &= ~CSTOPB;     /* only need 1 stop bit */
    tty.c_cflag &= ~CRTSCTS;    /* no hardware flowcontrol */

    /* setup for non-canonical mode */
    tty.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
    tty.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    tty.c_oflag &= ~OPOST;

    /* fetch bytes as they become available */
    tty.c_cc[VMIN] = 1;
    tty.c_cc[VTIME] = 1;

    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        printf("Error from tcsetattr: %s\n", strerror(errno));
        return -1;
    }
    return 0;
}

void set_mincount(int fd, int mcount)
{
    struct termios tty;

    if (tcgetattr(fd, &tty) < 0) {
        printf("Error tcgetattr: %s\n", strerror(errno));
        return;
    }

    tty.c_cc[VMIN] = mcount ? 1 : 0;
    tty.c_cc[VTIME] = 5;        /* half second timer */

    if (tcsetattr(fd, TCSANOW, &tty) < 0)
        printf("Error tcsetattr: %s\n", strerror(errno));
}


int main( int argc, char *argv[] )
{
    char *portname;
    char *hexstring;
    //unsigned int bytearray[60];
    unsigned char bytearray[60];  
    uint8_t str_len;

    if( argc == 3 ) {  
        portname = argv[1];
        hexstring = argv[2];// "4452068925068B19068D0D068F010690F50692E90694DD0696D10698C5069AB9069CAD069EA106A09506A28906A47D06A67100000000001E021D0D0A";
        int i;
        
        str_len = strlen(hexstring);
  
        for (i = 0; i < (str_len / 2); i++) {
           sscanf(hexstring + 2*i, "%02x", &bytearray[i]);
           //printf("bytearray %d: %02x\n", i, bytearray[i]);
        }


    }
    else {
        printf("Device and hex string must be given as arguments.\n");
        return 0;
    }
        
    int fd;
    int wlen;

    fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);
    if (fd < 0) {
        printf("Error opening %s: %s\n", portname, strerror(errno));
        return -1;
    }
    /*baudrate 9600, 8 bits, no parity, 1 stop bit */
    set_interface_attribs(fd, B9600);
    //set_mincount(fd, 0);                /* set to pure timed read */

    /* simple output */
    wlen = write(fd, bytearray , 60); /*write command (bytearray) to SK108, it's allways 60 bytes*/
    if (wlen != 60) {
        printf("Error from write: %d, %d\n", wlen, errno);
    }
    tcdrain(fd);    /* delay for output */
    usleep(6+25 * 10000); /*Enough time to read from  SK108*/ 

    /* simple noncanonical input */
        unsigned char buf[800];
        int rdlen;

        rdlen = read(fd, buf, sizeof(buf) - 1);
        if (rdlen > 0) {
#ifdef DISPLAY_STRING
            buf[rdlen] = 0;
            printf("Read:%d: \"%s\"\n", rdlen, buf);
#else /* display hex */
            unsigned char   *p;
            printf("Read:%d:", rdlen);
            for (p = buf; rdlen-- > 0; p++)
                printf("%02X ", *p);   
            printf("\n");
#endif
        } else if (rdlen < 0) {
            printf("Error from read: %d: %s\n", rdlen, strerror(errno));
        }  
}
