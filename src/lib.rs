#![no_std]
#![no_main]

#[no_mangle]
pub extern "C" fn _start() -> ! {

    // ATTENTION: we have a very small stack and no guard page

    let hello = b"Hello World!";
    let color_byte = 0x1f; // white foreground, blue background

    let mut hello_colored = [color_byte; 24];
    for (i, char_byte) in hello.into_iter().enumerate() {
        hello_colored[i*2] = *char_byte;
    }

    // write `Hello World!` to the center of the VGA text buffer
    let buffer_ptr = (0xb8000 + 1988) as *mut _;
    unsafe { *buffer_ptr = hello_colored };
    
    loop {}
}

// fn write_char(c: char, pos: u32, attr: u8) {
//         let addr = 0xb8000 + (pos * 2);
//         let c_ptr = addr as *mut u8;
//         let a_ptr = (addr + 1) as *mut u8;

//     unsafe {
//         *c_ptr = c as u8;
//         *a_ptr = attr;
//     }
// }


use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}