# art_ificial
:paintbrush: My explorations on generative art!

Here are some of the Processing sketches in this repo, with a comment on what I was trying to achieve and some technical details of the implementation.

- *arc_structures*

    Uses pygame to simulate how a BFS works;
    <p align="center"> <img src="https://i.imgur.com/k9OoRPO.gif/></p>

- *flower_bezier*

    Uses a random path particle simulation to create neural/root -like structures. Takes longer to construct the bigger the resolution is set in the code; (req. pygame)
    <p align="center"> <img src="multimedia/imgDemo/drunkenSailor.png"/></p>

- *flower_of_life*

    An experiment in pygame using text, mouse events, sprite and a timer;
    <p align="center"> <img src="multimedia/imgDemo/pygameSimple.png"/></p>

- *fractal_tree*

    Very simple ball physics test using the **pyglet** library. The green ball is in a simple harmonic oscillator movement, the red ball is in a movement with no acceleration, and the purple ball is in an accelerated movement.
    <p align="center"> <img src="multimedia/imgDemo/pygletAnim.png"/></p>

- *spiral*

    Uses the turtle module to create Koch fractals recursively with random colors in the form of a snowflake. The recursion level can be changed manually at the code (default: 3);
    <p align="center"> <img src="multimedia/imgDemo/turtleFractals.png"/></p>

- *squares_linked*

    Given a image (preferably simple), it prints out the list of (i, j) positions to "recreate" the image. You can see images generated with this type of approach at the "*imgDemo*" folder inside this directory. This application it's very useful in [this kind of program](https://github.com/robotenique/intermediateProgramming/tree/master/MAC0323/EP5);
    
    <p align="center"> <img src="multimedia/imgDemo/genTxt.png"/></p>