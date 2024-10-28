# blender-to-realitykit

As I've been learning how to create augmented reality (AR) apps for iOS through my development of [Juego de la Rana](github.com/radcli14/larana), one of the topics I'm constantly revisiting is how to import my own 3D content.
In that case, I have three unique objects that are included:

1. A frog statue, created using [Photogrammetry](https://www.dc-engineer.com/my-first-ar-app-on-ios-juego-de-la-rana/),
2. A table the statues sits upon, created in [Blender](https://www.blender.org/),
3. A city scene, also created in Blender.

The Juego de la Rana app is created in iOS-native Swift using the RealityKit framework, which uses a "Universal Scene Description" (`.usdz`) file format for importing 3D model files.
This is Apple's preferred format, long used my Pixar for rendering their own 3D content, however it is not especially common in other 3D modeling communities, in particular Blender users.
As such, my experience is that while you can _absolutely_ produce quality 3D content for RealityKit using Blender, the process is by no means seemless, and it took me a bit of trial and error to understand the workflow.

To help others adapt this workflow, I have created this example for creating content in Blender and exporting to RealityKit for AR apps on iOS and VisionOS.
Ultimately, while the process is not overwhelmingly cumbersome, however, understanding that Blender is free software and not optimized-for-Apple, its not necessarily easy or obvious either.
The guide that follows will go into detail into demonstrating how to transfer a fairly simple model from Blender into a working VisionOS and iOSP app, but if you were to skim over those details, a few points that I hope you will take away from this example are:

- The `.usdz` file format is supported by Blender, however, I find using this file _as-is_ will generally not work as-intended,
- Blender is typically better suited to exporting "Graphics Library Transmission Format Binary" (`.glb`) format, which is not natively imported into RealityKit,
- Apple's [Reality Converter](https://developer.apple.com/augmented-reality/tools/) tool can load `.glb` and convert to `.usdz` fairly reliably,
- Apple's [Reality Composer Pro](https://developer.apple.com/augmented-reality/tools/) tool can clean up the materials and lighting in the converted `.usdz` file.

## Building the Model in Blender

![Spinning Suzanne](videos/spinningSuzanne.gif)

| Default Cube                               | Resizing                               | Shifting Up                               |
|--------------------------------------------|----------------------------------------|-------------------------------------------|
| ![Default Cube](images/00_resizeCube0.png) | ![Resizing](images/00_resizeCube1.png) | ![Shifting Up](images/00_resizeCube2.png) |


### Creating the Baldosa Material

- With Node-wrangler, Control-Shift-T for "Principled Texture Setup", select all in folder

| Renaming material                                    | Base color texture                                       | Added albedo                                              |
|------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------------------|
| ![Renaming material](images/01_CubeMaterial0.png)    | ![Base color texture](images/01_CubeMaterial1.png)       | ![Base color texture](images/01_CubeMaterial2.png)        |
| Incorrect UV scaling                                 | Cube projection                                          | Better UV scaling                                         |
| ![Incorrect UV scaling](images/01_CubeMaterial3.png) | ![Cube projection](images/01_CubeMaterial4.png)          | ![Better UV scaling ](images/01_CubeMaterial5.png)        |
| UV repositioning                                     | Duplicating texture node                                 | Final material appearance                                 |
| ![UV repositioning](images/01_CubeMaterial6.png)     | ![Duplicating texture node](images/01_CubeMaterial7.png) | ![Final material appearance](images/01_CubeMaterial8.png) |


### Adding Suzanne

| Select the Monkey mesh                            | Scale and rotate                            |
|---------------------------------------------------|---------------------------------------------|
| ![Select the Monkey mesh](images/02_Suzanne0.png) | ![Scale and rotate](images/02_Suzanne0.png) |

| Add material slot                                    | Reduce alpha                                      |
|------------------------------------------------------|---------------------------------------------------|
| ![Add material slot](images/03_SuzanneMaterial0.png) | ![Add alpha](images/03_SuzanneMaterial1.png)      |
| Add emission                                         | Zero roughness                                    |
| ![Add emission](images/03_SuzanneMaterial2.png)      | ![Zero roughness](images/03_SuzanneMaterial3.png) |


### Animating

| | |
|---|---|
| ![](images/04_Animation0.png) | ![](images/04_Animation1.png) |
| | |
| ![](images/04_Animation2.png) | ![](images/04_Animation3.png) |
| | |
| ![](images/04_Animation4.png) | ![](images/04_Animation5.png) |
| | |
| ![](images/04_Animation6.png) | ![](images/04_Animation7.png) |


## Generating a `USDZ` formatted file

### Trying Blender's "Built-In" Export

| | |
|---|---|
| ![](images/05_exportUSDZ0.png) | ![](images/05_exportUSDZ1.png) |


### With Blender's `GLB` Export and Reality Converter

![](images/06_fullKeying.png)

## Building the RealityKit App

```swift
WindowGroup {
    ContentView()
        .environment(appModel)
}
.windowStyle(.volumetric)
.defaultSize(width: 2, height: 2, depth: 2, in: .meters)
```

In `ContentView.swift`
```swift
scene.availableAnimations.forEach { animation in
    scene.playAnimation(animation.repeat(duration: .infinity))
}
```
