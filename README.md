
# spIsoNet version 1.0

Update on Mar.27 2024

Single Particle spIsoNet (spIsoNet) is designed to correct for the preferred orientation problem in cryoEM by self-supervised deep learning, by recovering missing information from well-sampled orientations in Fourier space. 

Unlike conventional supervised deep learning methods that need explicit input-output pairs for training, spIsoNet autonomously extracts supervisory signals from the original data, ensuring the reliability of the information used for training.

spIsoNet is designed for single particle analysis and subtomogram averaging. For the correcting missing wedge in cryoET, please refer to IsoNet.

Please find tutorial/spIsoNet_v1.0_Tutorial.md for detailed document.

## Google group
We maintain an spIsoNet Google group for discussions or news.

To subscribe or visit the group via the web interface please visit https://groups.google.com/u/1/g/spisonet. 

To post to the forum you can either use the web interface or email to spisonet@googlegroups.com

# Installation

Modified for WEHI Milton HPC. Just clone this repo and run ```sbatch install.sh```
```bash ani.sh``` for anisotropic correction
