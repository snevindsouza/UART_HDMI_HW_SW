#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"

XGpio Gpio;

int main() {
    char cmd;
    XGpio_Initialize(&Gpio, XPAR_AXI_GPIO_0_BASEADDR);
    xil_printf("HDMI Pattern Control\n\r");
    xil_printf("\n\rEnter pattern (0-3): ");
    while(1) {
        scanf("%c", &cmd);
        if(cmd >= '0' && cmd <= '3'){
            int val = cmd - '0';
            XGpio_DiscreteWrite(&Gpio, 1, val);
            xil_printf("Pattern = %d\n\r", val);
        }
    }
}