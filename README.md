This is a port of NVIDIA's original FXAA v2 shader (the console version), with further pre-compute optimizations added by Matt DesLauriers. In short, FXAA is a single-pass, 1:1 anti-aliasing post-processing effect. Compared to straight super-sampling or MSAA, it has a lower quality, but is much faster. Love2D's MSAA was too slow for a project I'm working on, so I quickly hacked this together based on Matt's glslify shader. I've added an optional sharpening stage, which uses a very simple algorithm.

`main.moon` contains an example class `FXAACanvas`, which wraps canvas draw calls and applies FXAA and sharpening on `render`. You can fine tune all FXAA params and the sharpening strength, as well as the number of FXAA passes (uses nested canvas render targets).

Here's a screenshot of the demo file (click to view full size):

![](/screenshot.png)