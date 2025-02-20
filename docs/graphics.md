Keeping track of my findings on making the terminal visible on screen without adding specific video drivers for intel, amd, nvidia, etc.


## Framebufer console

https://docs.kernel.org/fb/fbcon.html


> In order for fbcon to activate, at least one framebuffer driver is required, so choose from any of the numerous drivers available. For x86 systems, they almost universally have VGA cards, so **vga16fb and vesafb will always be available**. However, using a chipset-specific driver will give you more speed and features, such as the ability to change the video mode dynamically.

Because of this I want to enable `vga16fb` and `vesafb` functionality:

```
CONFIG_FB_VGA16=y
CONFIG_FB_VESA=y
```

## EFI Framebuffer

> This is a generic EFI platform driver for systems with UEFI firmware. The system must be booted via the EFI stub for this to be usable. efifb supports both firmware with Graphics Output Protocol (GOP) displays as well as older systems with only Universal Graphics Adapter (UGA) displays.
> 
> https://docs.kernel.org/fb/efifb.html


## SimpleDRM


> DRM driver for simple platform-provided framebuffers.
>
> This driver assumes that the display hardware has been initialized by the firmware or bootloader before the kernel boots. Scanout buffer, size, and display format must be provided via device tree, UEFI, VESA, etc.
>
> On x86 BIOS or UEFI systems, you should also select SYSFB_SIMPLEFB to use UEFI and VESA framebuffers.
>
> https://cateee.net/lkddb/web-lkddb/DRM_SIMPLEDRM.html

```
CONFIG_DRM_SIMPLEDRM=y
CONFIG_SYSFB_SIMPLEFB=y
```

The option `SYSFB_SIMPLEFB` mentioned above is actually `CONFIG_SYSFB_SIMPLEFB`, and the docs about it says:

> Firmwares often provide initial graphics framebuffers so the BIOS, bootloader or kernel can show basic video-output during boot for user-guidance and debugging. Historically, x86 used the VESA BIOS Extensions and EFI-framebuffers for this, which are mostly limited to x86 BIOS or EFI systems. This option, if enabled, marks VGA/VBE/EFI framebuffers as generic framebuffers so the new generic system-framebuffer drivers can be used instead. If the framebuffer is not compatible with the generic modes, it is advertised as fallback platform framebuffer so legacy drivers like efifb, vesafb and uvesafb can pick it up. If this option is not selected, all system framebuffers are always marked as fallback platform framebuffers as usual.
>
> https://cateee.net/lkddb/web-lkddb/SYSFB_SIMPLEFB.html


## Framebuffer vs DRM

When I started this project I knew nothing about how display modes work on Linux, now I'm starting to get some clues but still I'm very far from understanding anything.


**fbdev is deprecated** (is fbdev the same as frambuffer? IDK)
https://lkml.iu.edu/hypermail/linux/kernel/1509.3/00253.html

As per wikipedia, fbdev is the same as Framebuffer and is superseeded by DRM. [Source](https://en.wikipedia.org/wiki/Linux_framebuffer)


## Gentoo on graphic modes

The info in this page was very helpful

https://wiki.gentoo.org/wiki/Framebuffer


## Related kernel parameters

https://docs.kernel.org/admin-guide/kernel-parameters.html


        earlycon=       [KNL,EARLY] Output early console device and options.

                efifb,[options]
                        Start an early, unaccelerated console on the EFI
                        memory mapped framebuffer (if available). On cache
                        coherent non-x86 systems that use system memory for
                        the framebuffer, pass the 'ram' option so that it is
                        mapped with the correct attributes.


        nomodeset       Disable kernel modesetting. Most systems' firmware
                        sets up a display mode and provides framebuffer memory
                        for output. With nomodeset, DRM and fbdev drivers will
                        not load if they could possibly displace the pre-
                        initialized output. Only the system framebuffer will
                        be available for use. The respective drivers will not
                        perform display-mode changes or accelerated rendering.


        fbcon=nodefer

            If the kernel is compiled with deferred fbcon takeover support, normally the framebuffer contents, left in place by the firmware/bootloader, will be preserved until there actually is some text is output to the console. This option causes fbcon to bind immediately to the fbdev device.

        console=tty0

            ??

        vga=ask

            Seems to have no effect unles booting in legacy BIOS mode




