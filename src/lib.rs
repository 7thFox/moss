#![no_std]
#![no_main]

mod vga;
use core::fmt::Write;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    for x in 0..10000 {
        write!(vga::WRITER.lock(), "{}. Hello World!\n", x).unwrap();
    }

    loop {}
}

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
