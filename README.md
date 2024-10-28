# blender-to-realitykit

![visionOSanimation](https://github.com/user-attachments/assets/ea994382-a7b7-477f-a4f7-4f45878bcb61)

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
- Apple's [Reality Composer Pro](https://developer.apple.com/augmented-reality/tools/) tool can clean up the materials and lighting in the converted `.usdz` file,
- `RealityView` in SwiftUI may be used for both VisionOS and iOS from iOS 18 and onward.

As an example, I'm going to create a fairly simple Blender model, but one that includes a couple features that tend to challenge the file export and conversion, namely materials, animations, and lights.
I will follow this up by creating an XCode project for an AR app, and show it being built in both VisionOS and iOS with our custom 3D model.
To a regular Blender user, I expect the first section to be fairly basic, as it solely is used to create the subject matter for the tutorial.
If you are primarily interested in how to add this content to RealityKit, you may prefer to skip to the second section discussing the model file exports.


## Building the Model in Blender

Our Blender model includes a single [_Baldosa de Bilbao_](https://es.wikipedia.org/wiki/Baldosa_de_Bilbao) tile, and a spinning head of the Blender mascot, Suzanne.
The Baldosa is created with an image texture containing albedo (color), roughness, normal, and displacement, with the UV's edited to center the pattern on the tile.
Suzanne is given a slightly translucent base color, and a bit of a green emissivity.
Suzanne's head is animated to rotate one full cycle every second, with the result looking like below.

![Spinning Suzanne](videos/spinningSuzanne.gif)

<!--
| Default Cube                               | Resizing                               | Shifting Up                               |
|--------------------------------------------|----------------------------------------|-------------------------------------------|
| ![Default Cube](images/00_resizeCube0.png) | ![Resizing](images/00_resizeCube1.png) | ![Shifting Up](images/00_resizeCube2.png) |
-->

### Creating the Baldosa Material

The Baldosa tile in the model is one meter square and two centimeters thick.
When starting the model, I could have used the default cube for this purpose, however, I ended up deleting that (as is tradition), and instead creating a 1 meter plane, and then extruding the two centimeter thickness.
For whatever reason, I found the textures and UV's to map a bit nicer onto the plane than on the cube; I have no reason for this, that just is what it is.

I use a physics-based rendering (PBR) texture set that I created on the [PolyCam website](https://poly.cam/) from a photograph that I took myself.
For those unfamiliar, this is a style of tile that is seen all throughout the city of Bilbao and surrounding towns, designed to be non-slip during the persistent _sirimiri_ (light rain) that is common here.
The PBR material contains albedo (base color), roughness, normal vectors encoded as red-green-blue (RGB) colors, and displacement maps, seen below.

| Albedo                               | Roughness                                  | Normal                               | Displacement                                    |
|--------------------------------------|--------------------------------------------|--------------------------------------|------------------------------------------------------|
| ![Albedo](blends/baldosa/albedo.png) | ![Roughness](blends/baldosa/roughness.png) | ![Normal](blends/baldosa/normal.png) | ![Displacement](blends/baldosa/displacement.png) |

In the "Object Mode" in the layout or modeling tab, I select the tile and open the "Material Properties" menu signified by the red circular icon on the right hand side of the window.
If there is not already a material slot for this object, we can create one by tapping the plus `+` symbol in the upper right, and then right click to rename this material "Baldosa."

When using a PBR material with multiple texture slots, the simplest way to add these properties is typically by switching to the "Shading" tab at the top of the window.
At this time, if you haven't already, you should install the [Node Wrangler](https://docs.blender.org/manual/en/latest/addons/node/node_wrangler.html) add-on, which you can access through "Edit -> Preferences -> Add-ons."
This will, among other things, enable keyboard shortcuts in the node editor, which is the diagram at the bottom of the screen.
To put this to use, now hover your mouse over the "Principled BSDF" block in the node editor, and press "Control-Shift-T."
A file browser will open up, in which you can select the `albedo.png`, `roughness.png`, `normal.png`, and `displacement.png` files that I referenced above, which are each located in the `blends/baldosa` folder of this project.
Once you click the "Principled Texture Setup" button with these selected, the material slots will be populated with those image files, with supporting blocks added to assure they map properly onto the object.
An incredible convenience provided by Node Wrangler compared to creating these blocks manually!

![Principled Texture Setup with Node Wrangler](images/01_CubeMaterial_Principled_Texture_Setup.png)

The image above shows what I would call the "final product" of the PBR material creation, however, there are a couple more steps I took to get there.
One of these steps is to propertly center the texture in the object's [UV map](https://docs.blender.org/manual/en/latest/modeling/meshes/uv/applying_image.html), which describes how the image texture wraps around the object.
In my example, I selected the four shorter corner edges, right-clicked and selected "mark seams," then  tapped the "A" key to select all faces, tapped the "U" key to open up unwrapping menu, then selected the "unwrap" option.
From here, I used the UV editor on the left hand side to scale and translate the faces until the textures lined up so that a single tile showed up on the top face, like what is seen in the image below.

![Manually centering the texture on the UV editing tab](images/01_CubeMaterial_UV_Setup.png)

Another last note is that the PBR material in Blender includes a displacement channel, which is handled in a bit of a unique way. This won't transfer nicely into RealityKit, but does make for a nice effect in the Blender rendering.
To enable displacement, I use the Cycles renderer, then add a "Subdivide Surface" modifier to the tile object, toggle "Simple" mode, and click the "Adaptive Subdivision" option.
With displacement turned on, I found the sides and bottom to look a bit weird, so I ended up assigning plain gray material (untextured) to these sides.

<!--
| Renaming material                                    | Base color texture                                       | Added albedo                                              |
|------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------------------|
| ![Renaming material](images/01_CubeMaterial0.png)    | ![Base color texture](images/01_CubeMaterial1.png)       | ![Base color texture](images/01_CubeMaterial2.png)        |
| Incorrect UV scaling                                 | Cube projection                                          | Better UV scaling                                         |
| ![Incorrect UV scaling](images/01_CubeMaterial3.png) | ![Cube projection](images/01_CubeMaterial4.png)          | ![Better UV scaling ](images/01_CubeMaterial5.png)        |
| UV repositioning                                     | Duplicating texture node                                 | Final material appearance                                 |
| ![UV repositioning](images/01_CubeMaterial6.png)     | ![Duplicating texture node](images/01_CubeMaterial7.png) | ![Final material appearance](images/01_CubeMaterial8.png) |
-->

### Adding Suzanne

The monkey head, named "Suzanne" by Blender users, is added by switching to the Layout or Modeling tab, making sure we are in object mode, clicking on the "Add" menu, "Mesh," and then "Monkey."
In the example, I have used the menu that appears in the bottom left to set the scale of the head to 0.9 meters, locate it 0.7 meters upward in the Z direction, and rotate it by 45 degrees around the Z axis, which looks nice relative to the size and location of the tile.
I used a much simpler material for Suzanne, where I set the roughness to zero to make her shiny, set transmission to 0.5 to make her translucent, and added a slight green emission, giving the appearance seen below.

![Material for Suzanne](images/03_SuzanneMaterial_Translucent.png)
<!--
| Select the Monkey mesh                            | Scale and rotate                            |
|---------------------------------------------------|---------------------------------------------|
| ![Select the Monkey mesh](images/02_Suzanne0.png) | ![Scale and rotate](images/02_Suzanne1.png) |

| Add material slot                                    | Reduce alpha                                      |
|------------------------------------------------------|---------------------------------------------------|
| ![Add material slot](images/03_SuzanneMaterial0.png) | ![Add alpha](images/03_SuzanneMaterial1.png)      |
| Add emission                                         | Zero roughness                                    |
| ![Add emission](images/03_SuzanneMaterial2.png)      | ![Zero roughness](images/03_SuzanneMaterial3.png) |
-->

### Animating

I wanted to include a simple animation, as I know this is one aspect that may not always be passed properly along with the file export and conversion.
In this case, I created a simple rotation about the vertical axis, which repeats on a one second loop.
I start by switching to the animation tab, selecting Suzanne, while hovering over her tapping the "I" key to bring up the keyframe menu, then selecting the rotation option.
This will create our first keyframe at frame 1, which will hold the initial rotation as already specified.
In the dope sheet at the bottom, now reposition to the fifth frame.
In the "Object Properties" menu on the right side, which is the orange square icon, change the Z axis rotation to 105 degrees. 
The color of the angle field will temporarily change to orange, which indicates a change from the current animation.
While hovering over this field, tap the "I" key again to create a new keyframe that holds this rotation.
Lastly, we want to interpolate linearly between the two keyframes we created, and extrapolate linearly for any frame after the second one we defined.
The linear interpolation option can be found by right-clicking inside the dope sheet at the bottom, while linear extrapolation can be found in the "Channel -> Extrapolation Mode" menu on the dope sheet.

| Creating first keyframe                                    | First keyframe in dope sheet                              |
|------------------------------------------------------------|-----------------------------------------------------------|
| ![Creating first keyframe](images/04_Animation0.png)       | ![First keyframe in dope sheet](images/04_Animation1.png) |
| Move to fifth frame                                        | Adding 60deg rotation                                     |
| ![Move to fifth frame](images/04_Animation2.png)           | ![Adding 60deg rotation ](images/04_Animation3.png)       |
| Keyframe added on fifth frame                              | Setting linear interpolation                              |
| ![Keyframe added on fifth frame](images/04_Animation4.png) | ![](images/04_Animation5.png)                             |
| Setting linear extrapolation                               | Setting an end frame                                      |
| ![Setting linear extrapolation](images/04_Animation6.png)  | ![Setting an end frame](images/04_Animation7.png)         |

Now, if we hit play, we should see Suzanne's head rotate continuously.
For sake of video and model export, and because all frame's after the first rotation are redundant, we can go into the "Output Properties" menu, signified by the printer icon on the right side, and set the "End" frame to 24, which is the last frame prior to completion of one full rotation.


## Generating a `USDZ` formatted file

In my experience, you can almost never get a "perfect" transfer of model data from Blender into other software; this includes RealityKit, but is also true of Unity and other applications I've tried.
This is attributed to some of the unique features of Blender, where they simply "do things differently" compared to other software.
Take the displacement that I defined above in the Baldosa material, where I used an adaptive subdivision modifier, that is really a "Blender-only" way of doing things.
Thats not to say that its the only software that will do a displacement map, just that it generally won't be passed along with the generic file exports.

Aside from aspects that are unique, however, there are also occasions where I simply see the Blender exports as being flawed.
Basically, areas where there are some unhandled edge cases in what are certainly very complex file format definitions, or features that the (mostly) volunteers who write the Blender software have not yet written.
My experience is that its hard to achieve a single solution that handles 100% of these cases, however, with a bit of extra effort, most of these can be fixed up after the fact to get a satisfactory `.usdz` file for RealityKit usage, following the methods I outline here.

### Trying Blender's "Built-In" Export

Of course, the "obvious" first guess for how to generate the `.usdz` file is to use the built-in method, which shows up in the "File -> Export" menu in Blender alongside the other common file types.
As I was writing this tutorial, this was the natural first option I tried, but not my final solution.
This section is included as a cautionary section, not as a recommendation (though, its worth a try, it may work better on your own setup).
Importantly though, I felt that many people may get frustrated and stop here when trying to export their own model, so I felt worth keeping it in so if somebody sees it, they know not to give up, as there is indeed another option, as I'll cover in the section to follow.

When the export dialog opens, a good first step is to make sure all the boxes on the right hand side are checked, to assure that the exported file packs all the materials and animations, and that the textures are "baked."
Without using this option, the PBR materials may show up as plain colors or empty when viewed in RealityKit.
After saving, you can double click the newly created `.usdz` file to view it in XCode, where it looks ... not good.
For whatever reason, there is a hard black line across one edge of the tile, indicating something is not right in the PBR material export.

| Enable materials, animations, & textures                                | Not a good USDZ export!                               |
|-------------------------------------------------------------------------|-------------------------------------------------------|
| ![Enable materials, animations, & textures ](images/05_exportUSDZ0.png) | ![Not a good USDZ export!](images/05_exportUSDZ1.png) |

My next step at this phase is to open the model in [Reality Converter](https://developer.apple.com/augmented-reality/tools/), which is typically my first pass at trying to fix up a model or diagnose problems.
When viewed in Reality Converter, as seen in the video below, the model looks, honestly, even worse, which surprises me as I would have thought both Apple software would use the same renderer.
Here, the scaling is all wrong, with the baldosa tile being tiny, and Suzanne's head looking kind of twisted and squashed.
At least the animation is working though!

![Not a good USDZ export, but at least the animation worked](videos/weirdBlenderBuiltInUSDZ.gif)

Looking on the right hand side, it appears the texture baking had some unintended side effects, as you can see the images don't exactly resemble what I included at the top of this post, and theres even a new ambient inclusion channel.
I tried turning off the baking, and found in that case the textures were simply not included at all.
One option would be to go back and add those textures manually, which can be done by clicking in the squares on the right.
Given the scaling issue already mentioned, and the general inconvenience, I find the next option to be greatly preferable.

### With Blender's `GLB` Export and Reality Converter

The `.glb` file format appears to be somewhat more common in web-based applications and elsewhere, and likewise support in Blender seems to be a bit better than `.usdz`.
Exporting to `.glb` is also very simple using the "File -> Export" menu.
In fact, I did not need to toggle any options in the export menu for `.glb`, all of the defaults seemed to work.
The one detail I would make sure is to export with the `.glb` extension, not `.gltf`, as we want the "binary" version where all of the textures come packed into a single file.

After exporting to `.glb` from  Blender, you will again need to open it Reality Converter to generate the `.usdz` file for RealityKit.
On my first attempt, the `.glb` formatted version of the model looks like the video below when viewed in Reality Converter.
This time, materials and scaling look good, but whats going on with the animation?

![Better textures and scaling, but missing the extrapolation](videos/weirdBlenderGLB.gif)

So what had happened was, when I created the animation I opted to use extrapolation off of the first and second keyframe, rather than defining the whole rotation manually.
This, evidently, is one of the uniquely-Blender features, and does not get passed along with the `.glb` file.
The fix for this, of course, is to go back into Blender and remove that extrapolation, and create new keyframes that cover the entire rotation and return to initial state.
That is what I've done in the image below.

![Created keying for a full rotation](images/06_fullKeying.png)

With the keying fixed, I once again export the `.glb` file from Blender, and open it in Reality Converter.
After the update, materials look good, scaling looks good, and the animation plays a complete rotation of Suzanne.

![Updated GLB export with fixed animation](videos/betterAnimationGLBexport.gif)

I hit "File -> Export" in Reality Converter to save my model file as `.usdz`.
At this stage, the model can actually be AirDrop-ed to your iPhone, and you can even visualize it using AR Quick-look.
Even without having built our app yet, we can see what our model looks like in our AR world.

![Good enough for AR Quick Look!](videos/blenderToARQuickLook.gif)

## Building the RealityKit App

![New RealityKit Project](images/07_newRealityKitProject2.png)

![Adding our model to the Reality Composer scene](images/08_exampleAddedIntoScene.png)

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

![Animated model in VisionOS](videos/visionOSanimation.gif)
