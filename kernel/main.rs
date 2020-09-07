
#[no_mangle]
fn main() {
    unsafe {
        let video_memory_addr = 0xb8000;
        let video_memory = video_memory_addr as *mut u8;
        *video_memory = 'X' as u8;
        *video_memory.add(1) = 'Y' as u8;
        *video_memory.add(2) = 'Z' as u8;
        *video_memory.add(3) = 'A' as u8;
//        *video_memory = 0x0F;
//        *video_memory.add(1) = 'X' as u8
    }
}


