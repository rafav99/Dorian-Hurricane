# Hurricane Dorian Motion Analysis

Satellite-image processing in MATLAB to segment Hurricane Dorian, track the eye, estimate translational motion, and infer local angular displacement from RGB texture matching.

<p align="center">
  <img src="assets/tracking.gif" alt="Hurricane Dorian eye tracking and segmentation" width="100%">
</p>

## Overview

This project analyzes a sequence of **35 RGB satellite frames** of Hurricane Dorian separated by **10 minutes**. The pipeline isolates the cloud structure using color information, tracks the hurricane eye across the sequence, measures the segmented storm area, and estimates rotational motion by matching an annular RGB pattern between consecutive frames.

The goal is not meteorological forecasting. It is a compact scientific-computing exercise in **image segmentation, feature tracking, motion estimation, and quantitative analysis of a physical system**.

## Key results

| Quantity | Result |
| --- | ---: |
| Frames analyzed | 35 |
| Time between frames | 10 min |
| Mean eye translation speed | **12.36 km/h** |
| Mean estimated angular speed | **20.12 deg/h** |
| Minimum segmented area | **349,451 km²** |
| Maximum segmented area | **405,507 km²** |

The angular estimate describes the apparent motion of image texture inside the selected annular sector. It should be interpreted as an image-based rotational proxy rather than a direct measurement of atmospheric wind speed.

## Method

### 1. Color-based storm segmentation

Each frame is transformed from RGB to HSV. The saturation channel provides strong contrast between the colored hurricane structure and the comparatively desaturated background.

A threshold of

\[
S > 0.4
\]

produces the initial binary mask. Morphological closing and opening remove small defects, and only the largest connected component is retained.

### 2. Eye detection and tracking

The interior holes of the segmented cloud structure are extracted by comparing the mask with its hole-filled version.

For the first frame, the largest interior hole is selected as the eye. In every later frame, the candidate whose centroid is closest to the previous eye position is selected. This turns a single-frame segmentation into a simple temporal tracker.

### 3. Translation speed

For consecutive eye centroids \((x_k,y_k)\), translation speed is estimated as

\[
v_k = \frac{\sqrt{(x_k-x_{k-1})^2 + (y_k-y_{k-1})^2}}{\Delta t}.
\]

The original dataset uses a scale of 1 km/pixel and \(\Delta t = 10\) min.

### 4. Rotation from annular RGB matching

A fixed annular sector around the eye is sampled using

- radius: **140–170 px**
- angular sector: **−15° to 15°**
- candidate shifts: **−40° to 40°**

For each candidate angular displacement, the RGB pattern in frame \(k\) is compared with the shifted pattern in frame \(k+1\). The selected displacement minimizes

\[
E(\Delta\theta)=\frac{1}{N}\sum_i\left[P_k(i)-P_{k+1}(i,\Delta\theta)\right]^2.
\]

The corresponding angular speed is

\[
\omega_k = \frac{\Delta\theta_k}{\Delta t}.
\]

<p align="center">
  <img src="assets/rotation.gif" alt="RGB annular pattern matching for rotation estimation" width="100%">
</p>

## Summary

<p align="center">
  <img src="assets/summary.png" alt="Summary plots for Hurricane Dorian analysis" width="100%">
</p>

## Repository structure

```text
hurricane-dorian-motion-analysis/
├── README.md
├── run_analysis.m
├── src/
│   ├── segment_hurricane.m
│   ├── detect_eye.m
│   ├── estimate_rotation.m
│   ├── render_tracking_frame.m
│   ├── render_rotation_frame.m
│   ├── append_gif_frame.m
│   └── render_summary.m
├── data/
│   ├── README.md
│   └── frames/
│       ├── Frame_1.png
│       └── ... Frame_35.png
├── assets/
│   ├── tracking.gif
│   ├── rotation.gif
│   └── summary.png
└── .gitignore
```

## Run the analysis

Open MATLAB in the repository root and run:

```matlab
run_analysis
```

The script processes all 35 frames and regenerates:

- `assets/tracking.gif`
- `assets/rotation.gif`
- `assets/summary.png`

## Requirements

- MATLAB
- Image Processing Toolbox

The implementation uses `rgb2hsv`, `strel`, `imclose`, `imopen`, `bwareafilt`, `imfill`, `bwlabel`, `regionprops`, and standard MATLAB plotting/image functions.

## Design choices and limitations

The method is intentionally lightweight and interpretable. Eye tracking uses nearest-centroid association instead of a learned tracker, while rotation is estimated by explicit RGB template matching rather than optical flow. These choices make each stage easy to inspect and connect directly to the physical quantities being estimated.

Potential extensions include sub-pixel eye localization, optical-flow comparison, automatic selection of the annular region, uncertainty estimates, and a more robust treatment of non-rigid cloud deformation.
