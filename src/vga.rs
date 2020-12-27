const BUFFER_HEIGHT: usize = 25;
const BUFFER_WIDTH: usize = 80;

use volatile::Volatile;

use core::fmt;
impl fmt::Write for BufferWriter {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        self.print(s);
        Ok(())
    }
}

use lazy_static::lazy_static;
use spin::Mutex;
lazy_static! {
    pub static ref WRITER: Mutex<BufferWriter> = Mutex::new(BufferWriter::new());
}

#[repr(transparent)]
struct Buffer {
    chars: [[Volatile<u16>; BUFFER_WIDTH]; BUFFER_HEIGHT],
}

pub struct BufferWriter {
    pos_col: usize,
    pos_row: usize,
    current_color: ColorMode,
    buffer: &'static mut Buffer,
}

impl BufferWriter {
    pub fn new() -> BufferWriter {
        BufferWriter {
            pos_col: 0,
            pos_row: 0,
            current_color: ColorMode::new(Color::White, Color::Black, false),
            buffer: unsafe { &mut *(0xb8000 as *mut Buffer) },
        }
    }

    pub fn clear(&mut self) {
        let ch = self.current_color.with_ch(b' ');
        for row in 0..BUFFER_HEIGHT {
            for col in 0..BUFFER_WIDTH {
                self.write_at_unsafe(ch, row, col);
            }
        }
        self.pos_col = 0;
        self.pos_row = 0;
    }

    pub fn set_color(&mut self, color: ColorMode) {
        self.current_color = color;
    }

    pub fn write_at(&mut self, ch: u16, row: usize, col: usize) {
        if row < BUFFER_HEIGHT && col < BUFFER_WIDTH {
            self.write_at_unsafe(ch, row, col);
        }
    }

    pub fn print(&mut self, s: &str) {
        for byte in s.bytes() {
            match byte {
                // printable ASCII byte or newline
                0x20..=0x7e | b'\n' => self.print_byte(byte),
                // not part of printable ASCII range
                _ => self.print_byte(0xfe),
            }
        }
    }

    pub fn print_byte(&mut self, ch: u8) {
        match ch {
            b'\n' => self.newline(),
            ch => {
                self.pos_col += 1;
                if self.pos_col >= BUFFER_WIDTH {
                    self.pos_col = 0;
                    self.pos_row += 1;
                }

                self.write_at(self.current_color.with_ch(ch), self.pos_row, self.pos_col);
            }
        }
    }

    fn newline(&mut self) {
        self.pos_col = 0;
        self.pos_row += 1;
        if self.pos_row >= BUFFER_HEIGHT {
            for row in 1..BUFFER_HEIGHT {
                for col in 0..BUFFER_WIDTH {
                    self.write_at_unsafe(self.buffer.chars[row][col].read(), row - 1, col);
                }
            }
            self.pos_row -= 1;
        }
    }

    fn write_at_unsafe(&mut self, ch: u16, row: usize, col: usize) {
        self.buffer.chars[row][col].write(ch);
    }
}

#[allow(dead_code)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[repr(u8)]
pub enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ColorMode(u16);

impl ColorMode {
    pub fn new(fore: Color, back: Color, blink: bool) -> ColorMode {
        ColorMode(
            // ASCII Print Char
            ((fore as u16) & 0xF) << 8
                | ((back as u16) & 0xF) << 12
                | (if blink { 0b1 } else { 0b0 }) << 15,
        )
    }

    fn with_ch(self, ch: u8) -> u16 {
        self.0 | (ch as u16)
    }
}
