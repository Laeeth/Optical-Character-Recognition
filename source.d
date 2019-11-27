import identifying : visualizing;
import reading : readTextImage;
import std.conv : to;
import std.stdio : writeln;

void main()
{
    //all letters are all perfectly sized and read
    //letters A to I had its training set checked for inconsistencies, letters W to Z have perfect training sets created automatically
    //foreach (i; 1 .. 19)
        //readTextImage("I/" ~ to!string(i) ~ ".png");
    bool individual = false;
    writeln(readTextImage(individual, "alpha_Aakar.png"));
    writeln(readTextImage(individual, "alpha_LiberationSerif.png"));
    writeln(readTextImage(individual, "alpha_Loma.png"));
    foreach (i; 1 .. 19)
        visualizing('G', i);
}
