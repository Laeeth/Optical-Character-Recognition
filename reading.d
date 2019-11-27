module reading;

import arsd.image : loadImageFromFile;
import arsd.simpledisplay : Color, Image, Key, KeyEvent, Point, Rectangle, ScreenPainter, SimpleWindow;
import identifying : identifyCharacter;
import std.conv : to;
import std.file : append;
import std.range : iota;

//this function reads text from an image file
string readTextImage(bool individual, string name)
{
    Image img = Image.fromMemoryImage(loadImageFromFile(name));
    SimpleWindow window = new SimpleWindow(img, "OCR simulation");
    //here we draw the image on the window
    window.draw().drawImage(Point(0, 0), img);
    mixin declare_necessary_variables_and_delegates;
    window.eventLoop(0,
    (KeyEvent event)
    {
        if (event.pressed && event.key == Key.Enter)
        {
            //this is tell if there is a space in between the letters
            spacing = firstX;
            detect_line_with_a_phrase;
            //that's what happens when it reaches the end of the document
            if (firstY == -1)
                window.close;
            else if (firstX != -1)
            {
                //that's what happens when there is a space
                if (!first && firstX - spacing >= firstLetterSize / 3)
                    text ~= ' ';
                else
                {
                    read_a_single_character;
                    slice_the_frame;
                    draw_the_frame;
                    count_the_written_parts;
                    //in case you need to store the mapped array of `true` and `false`
                    if (false)
                        append("testedSet.txt", to!string(writtenParts) ~ ", ");
                    text ~= identifyCharacter(individual, writtenParts);
                    first = false;
                }
            }
            //that's what happens when it reaches the end of the line
            else
                text ~= '\n', firstY = lastY + 1, firstX = firstLetterSize = 0, first = true;
        }
    });
    return text;
}

mixin template declare_necessary_variables_and_delegates()
{
    bool edge, first = true;
    byte colorSum = 50;
    int firstX, firstY, lastX = 1, lastY = 1, left, right, top, bottom, firstLetterSize, spacing;
    string text;
    Color pixel;
    Rectangle frame;
    bool[400] writtenParts = void;
    int[21] piecesH = void, piecesV = void;
    Rectangle[400] rectangularPieces = void;
    bool[Point] writtenPoints;

    //here we create a frame around the line with the phrase
    void detect_line_with_a_phrase()
    {
        firstY = sideNumberPhrase("top"),
        lastY = sideNumberPhrase("bottom"),
        firstX = sideNumberPhrase("left"),
        lastX = sideNumberPhrase("right");
        ScreenPainter painter = window.draw();
        painter.outlineColor = Color.green(), painter.fillColor = Color.transparent();
        //it needs to be incremented so it doesn't cover the pixels of the letters
        painter.drawRectangle(Point(firstX - 1, firstY - 1), Point(lastX + 1, lastY + 1));
    }

    //here we find the coordinates of the sides of the frame of a phrase in a text image
    int sideNumberPhrase(string side)
    {
        if (side == "top")
        {
            foreach (y; firstY .. img.height)
                foreach (x; 0 .. img.width)
                {
                    pixel = img.getPixel(x, y);
                    if (pixel.r + pixel.g + pixel.b <= colorSum)
                        return y;
                }
            return -1;
        }
        if (side == "bottom")
        {
            foreach (y; firstY .. img.height)
                foreach (x; 0 .. img.width)
                {
                    pixel = img.getPixel(x, y);
                    if (pixel.r + pixel.g + pixel.b <= colorSum)
                        break;
                    if (x == img.width - 1)
                        //it must be decremented so it returns the last pixel and not the next to last
                        return y - 1;
                }
            //in case the letter spans to the very bottom edge of the image
            return img.height - 1;
        }
        if (side == "left")
        {
            foreach (x; firstX .. img.width)
                foreach (y; firstY .. lastY + 1)
                {
                    pixel = img.getPixel(x, y);
                    if (pixel.r + pixel.g + pixel.b <= colorSum)
                        return x;
                }
            return -1;
        }
        if (side == "right")
        {
            foreach_reverse (x; firstX .. img.width)
                foreach (y; firstY .. lastY + 1)
                {
                    pixel = img.getPixel(x, y);
                    if (pixel.r + pixel.g + pixel.b <= colorSum)
                        return x;
                }
            return -1;
        }
        assert(false, "You wrote the wrong side name!");
    }

    //here we make the frame's rectangle around the single character
    void read_a_single_character()
    {
        left = firstX, top = firstY, bottom = lastY;
        //this loop finds the right side, it runs until it reaches the letter's end or the very right edge of the image
        do
        {
            edge = true;
            foreach (y; firstY .. lastY + 1)
            {
                pixel = img.getPixel(firstX, y);
                if (pixel.r + pixel.g + pixel.b <= colorSum)
                    writtenPoints[Point(firstX, y)] = true, edge = false;
            }
            firstX++;
            if (first)
                firstLetterSize++;
        }
        while (!edge && firstX <= img.width);
        //I need to remove the 2 extra increments that happen at the end
        right = firstX - 2;
        frame = Rectangle(left, top, right, bottom);
    }

    //here we slice the frame's rectangle in 400 pieces
    void slice_the_frame()
    {
        real xDist = frame.right - frame.left, yDist = frame.bottom - frame.top;
        auto rangeH = iota(frame.left, frame.right + 1, xDist / 20.0L),
             rangeV = iota(frame.top, frame.bottom + 1, yDist / 20.0L);
        foreach (i; 0 .. 21)
            piecesH[i] = cast(int) rangeH[i], piecesV[i] = cast(int) rangeV[i];
    }

    //here we draw all of the 400 divisions of the frame's rectangle
    void draw_the_frame()
    {
        ScreenPainter painter = window.draw();
        painter.outlineColor = Color.green(), painter.fillColor = Color.transparent();
        foreach (v; 0 .. 20)
            foreach (h; 0 .. 20)
                rectangularPieces[v * 20 + h] = Rectangle(Point(piecesH[h], piecesV[v]), Point(piecesH[h + 1], piecesV[v + 1]));
        foreach (piece; rectangularPieces)
            painter.drawRectangle(piece.upperLeft(), piece.lowerRight());
    }

    //here we assign `true` to all of the written parts in the frame
    void count_the_written_parts()
    {
        writtenParts = false;
        foreach (i; 0 .. 400)
            foreach (point; writtenPoints.byKey)
                if (rectangularPieces[i].contains(point))
                {
                    writtenParts[i] = writtenPoints.remove(point);
                    break;
                }
        writtenPoints.clear;
    }
}
