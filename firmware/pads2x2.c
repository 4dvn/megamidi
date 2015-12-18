#include <util/delay.h>

#define STEP _delay_us(10);
#define WAIT _delay_ms(250);

#define B00 ((PINC & (1 << 0)) > 0)
#define B01 ((PINC & (1 << 1)) > 0)
#define B10 ((PINC & (1 << 2)) > 0)
#define B11 ((PINC & (1 << 3)) > 0)

#define SRCLK 5
#define RCLK 6
#define SER 7

void shift(unsigned char data){
    PORTD &= ~(1 << SRCLK);
    if (data) {
        PORTD |= (1 << SER);
        PORTB |= (1 << 3);
    } else {
        PORTD &= ~(1 << SER);
        PORTB &= ~(1 << 3);
    }
    PORTD |= (1 << SRCLK);
}

void latch() {
    PORTD &= ~(1 << RCLK);
    PORTD |= (1 << RCLK);
}

void shiftn(unsigned char data, int n) {
    for (int i = 0; i < n; i++) {
        shift(data);
    }
}

void clear() {
    shiftn(0, 8);
    latch();
}

// R
// G
// B
// BL 00
// TL 01
// BR 10
// TR 11

void rgb(int r, int g, int b, int row, int col) {
    shift(0);
    if (row == 1 && col == 1) shift(0);
    else shift(1);
    if (row == 1 && col == 0) shift(0);
    else shift(1);
    if (row == 0 && col == 1) shift(0);
    else shift(1);
    if (row == 0 && col == 0) shift(0);
    else shift(1);
    shift(r);
    shift(g);
    shift(b);
    latch();
}

void rgb_fill(int r, int g, int b) {
    rgb(r, g, b, 0, 0); STEP
    rgb(r, g, b, 0, 1); STEP
    rgb(r, g, b, 1, 1); STEP
    rgb(r, g, b, 1, 0); STEP
}

static char positions[] = {0b00, 0b01, 0b11, 0b10};
static char colors[] = {0b100, 0b010, 0b001, 0b110, 0b101, 0b011, 0b111};

void rgbcolor(char color, char row, char col) {
    char r = ((color & (1 << 2)) == 0) ? 0 : 1; // R
    char g = ((color & (1 << 1)) == 0) ? 0 : 1; // G
    char b = ((color & (1 << 0)) == 0) ? 0 : 1; // B
    rgb(r, g, b, row, col);
}

void color_loop() {
    char pi = 0; // Position index
    char ci = 0; // Color index

    for (;;) {
        char pos = positions[pi];
        char row = ((pos & (1 << 0)) == 0) ? 0 : 1; // Row
        char col = ((pos & (1 << 1)) == 0) ? 0 : 1; // Col
        rgbcolor(colors[ci], row, col);
        pi = (pi + 1) % 4;
        if (pi == 0) ci = (ci + 1) % 7;
        _delay_ms(200);
    }
}

void setup_shift() {
    DDRD |= (1 << SRCLK) | (1 << RCLK) | (1 << SER);
}
