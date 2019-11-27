module identifying;

import arsd.simpledisplay : Color, Point, Rectangle, ScreenPainter, SimpleWindow, Size;
import std.algorithm.searching : canFind;
import std.conv : to;
import std.file : readText;
import training : netSum;

//this function calculates the match probability of a character 
char identifyCharacter(bool individual, bool[400] processedImage)
{
    char chosenOne = '?';
    int limit;
    real highest = -5.0L, result;
    real[400] weights;
    if (!canFind(processedImage[], false))
        return 'I';
    foreach (letter; "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    {
        if (individual)
        {
            limit = letter == 'I' ? 12 : 19;
            foreach (i; 1 .. limit)
            {
                weights = to!(real[400])(readText(letter ~ "/" ~ letter ~ to!string(i) ~ "_weights.txt"));
                result = netSum(processedImage, weights);
                if (result > highest)
                    highest = result, chosenOne = letter;
            }
        }
        else
        {
            weights = to!(real[400])(readText(letter ~ "/" ~ letter ~ "_weights.txt"));
            result = netSum(processedImage, weights);
            if (result > highest)
                highest = result, chosenOne = letter;
        }
    }
    return chosenOne;
}

//this function allows you to visualize the way the weights are set by painting black the negative parts
void visualizing(char letter, int index = -1)
{
    real[400] weights;
    SimpleWindow window = new SimpleWindow(200, 200);
    if (index == -1)
        weights = to!(real[400])(readText(letter ~ "/" ~ letter ~ "_weights.txt"));
    else
        weights = to!(real[400])(readText(letter ~ "/" ~ letter ~ to!string(index) ~ "_weights.txt"));
    Rectangle[400] parts;
    foreach (y; 0 .. 20)
        foreach (x; 0 .. 20)
            parts[y * 20 + x] = Rectangle(Point(x * 10, y * 10), Size(10, 10));
    {ScreenPainter painter = window.draw();
    painter.outlineColor = Color.green(), painter.fillColor = Color.transparent();
    foreach (i; 0 .. 400)
        painter.drawRectangle(parts[i].upperLeft(), 10, 10);
    painter.fillColor = Color.black();
    foreach (i; 0 .. 400)
        if (weights[i] <= -0.0L)
            painter.drawRectangle(parts[i].upperLeft(), 10, 10);}
    window.eventLoop(0);
}
