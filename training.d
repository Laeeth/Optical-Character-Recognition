module training;

import std.algorithm : sum;
import std.conv : to;
import std.file : readText, write;
import std.math : abs;
import std.stdio : writeln;

bool individual = 0, right = 0, trainIt = 1;

//This function trains it to adjust the weights
void train(bool individual, char inputFile)
{
    byte counter;
    real[484] weights = 0.0L;
    bool[484][] trainingSet = to!(bool[484][])(readText(inputFile ~ "/" ~ inputFile ~ "_trainingSet.txt"));
    if (individual)
        foreach (set; trainingSet)
        {
            growingSynapses(set, weights);
            for (real result = 100.0L - sum(weights[]); abs(result) > 0.001L; result = 100.0L - sum(weights[]))
                weightAdjustment(result, weights);
            foreach (ref w; weights)
                if (w == 0.0L)
                    w = -2.0L;
            write(inputFile ~ "/" ~ inputFile ~ to!string(++counter) ~ "_weights.txt", to!string(weights));
            weights = 0.0L;
        }
    else
    {
        foreach (set; trainingSet)
            growingSynapses(set, weights);
        for (real result = 100.0L - sum(weights[]); abs(result) > 0.001L; result = 100.0L - sum(weights[]))
            weightAdjustment(result, weights);
        foreach (ref w; weights)
            if (w == 0.0L)
                w = -2.0L;
        write(inputFile ~ "/" ~ inputFile ~ "_weights.txt", to!string(weights));
    }
    writeln("done training");
}

//this function tests the neural network against images on a file
void test(bool right, char inputFile)
{
    char letter = 'A';
    real[484] weights = to!(real[484])(readText(inputFile ~ "/" ~ inputFile ~ "_weights.txt"));
    bool[484][] testSet = void;
    testSet = right ? to!(bool[484][])(readText(inputFile ~ "/" ~ inputFile ~ "_trainingSet.txt")) : to!(bool[484][])(readText("alphabet_testSet.txt"));
    foreach (i; 0 .. testSet.length)
        writeln(letter++, ": ", netSum(testSet[i], weights));
    writeln("done testing");
}

//this function just maps the important parts, giving the highest value to the most important ones
void growingSynapses(bool[] set, real[] weights)
{
    foreach (i; 0 .. 484)
        if (set[i])
            weights[i] += 0.5L;
}

//this function adds all of the weights of the written parts to find the match probability
real netSum(bool[] processedImage, real[] weights)
{
    real result = 0.0L;
    foreach (i; 0 .. 484)
        if (processedImage[i])
            result += weights[i];
    return result;
}

//This function adjusts the weights by increasing/decreasing them by 0.1% until they produce the result of 100.0
void weightAdjustment(real result, real[] weights)
{
    real factor = result > 0.0L ? 1.001L : 0.999L;
    foreach (i; 0 .. 484)
        if (weights[i] > 0.0)
            weights[i] *= factor;
}
