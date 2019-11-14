This is a port of NVIDIA's original FXAA v2 shader (the console version), with further pre-compute optimizations added by Matt DesLauriers. In short, FXAA is a single-pass, 1:1 anti-aliasing post-processing effect. Compared to straight super-sampling or MSAA, it has a lower quality, but is much faster. Love2D's MSAA was too slow for a project I'm working on, so I quickly hacked this together based on Matt's glslify shader.

I found that (on my linux machine with NVIDIA drivers), the shader *must* be applied to a canvas if `window.setMode` is used *at all*. Don't ask me why. You can finetune the FXAA params in the shader code (or convert them to sent values to allow runtime changes). Read the paper to learn what they mean.

Here's a screenshot of the demo file (single pass, left is FXAA, right is original):

![](/screenshot.png)