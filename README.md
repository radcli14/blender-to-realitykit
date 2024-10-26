# blender-to-realitykit
Example for creating content in Blender and exporting to RealityKit for AR apps on iOS and VisionOS

## Building the Model in Blender

![Spinning Suzanne](videos/spinningSuzanne.gif)

| Default Cube                               | Resizing                               | Shifting Up                               |
|--------------------------------------------|----------------------------------------|-------------------------------------------|
| ![Default Cube](images/00_resizeCube0.png) | ![Resizing](images/00_resizeCube1.png) | ![Shifting Up](images/00_resizeCube2.png) |


### Creating the Baldosa Material

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
