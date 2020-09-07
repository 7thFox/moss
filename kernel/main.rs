#[no_mangle]
fn main() {
//    write_char('A', 0, 0x0);
    loop {}
}

fn write_char(c: char, pos: u32, attr: u8) {
    unsafe {
        let addr = 0xb8000 + (pos * 2);
        let c_ptr = addr as *mut u8;
        let a_ptr = (addr + 1) as *mut u8;

        *c_ptr = c as u8;
        *a_ptr = attr;
    }
}
