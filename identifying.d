module identifying;

import arsd.simpledisplay : Color, Point, Rectangle, ScreenPainter, SimpleWindow, Size;
import std.conv : to;
import std.file : readText;
import training : netSum;

//this function calculates the match probability of a character 
char identifyCharacter(bool individual, bool[484] processedImage)
{
    char chosenOne = '?';
    real highest = -100.0L, result;
    real[484] weights;
    foreach (letter; "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        if (individual)
            foreach (i; 1 .. 26)
            {
                weights = to!(real[484])(readText(letter ~ "/" ~ letter ~ to!string(i) ~ "_weights.txt"));
                result = netSum(processedImage, weights);
                if (result > highest)
                    highest = result, chosenOne = letter;
            }
        else
        {
            weights = to!(real[484])(readText(letter ~ "/" ~ letter ~ "_weights.txt"));
            result = netSum(processedImage, weights);
            if (result > highest)
                highest = result, chosenOne = letter;
        }
    return chosenOne;
}

//this function allows you to visualize the way the weights are set by painting black the negative parts
void visualizing(char letter, int index = -1)
{
    real[484] weights;
    SimpleWindow window = new SimpleWindow(220, 220);
    if (index == -1)
        weights = to!(real[484])(readText(letter ~ "/" ~ letter ~ "_weights.txt"));
    else
        weights = to!(real[484])(readText(letter ~ "/" ~ letter ~ to!string(index) ~ "_weights.txt"));
    Rectangle[484] parts;
    foreach (y; 0 .. 22)
        foreach (x; 0 .. 22)
            parts[y * 22 + x] = Rectangle(Point(x * 10, y * 10), Size(10, 10));
    {ScreenPainter painter = window.draw();
    painter.clear(Color.black());
    painter.outlineColor = Color.green();
    foreach (i; 0 .. 484)
        painter.drawRectangle(parts[i].upperLeft(), Size(10, 10));
    foreach (i; 0 .. 484)
        if (weights[i] > 0.0L)
        {
            if (weights[i] >= 0.5L)
                painter.fillColor = Color.red();
            else if (weights[i] >= 0.4L)
                painter.fillColor = Color.yellow();
            else if (weights[i] >= 0.3L)
                painter.fillColor = Color.green();
            else
                painter.fillColor = Color.blue();
            painter.drawRectangle(parts[i].upperLeft(), Size(10, 10));
        }}
    window.eventLoop(0);
}
