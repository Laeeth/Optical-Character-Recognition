import identifying : visualizing;
import reading : readTextImage;
import std.stdio : writeln;

void main()
{
    bool individual = 0;
    writeln(readTextImage(individual, "alpha_Aakar.png"));
    writeln(readTextImage(individual, "alpha_LiberationSerif.png"));
    writeln(readTextImage(individual, "alpha_Loma.png"));
    writeln(readTextImage(individual, "example_Suruma.png"));
    writeln(readTextImage(individual, "example_Ubuntu.png"));
    foreach (i; 0 .. 25)
        visualizing(cast(char) ('A' + i));
}
