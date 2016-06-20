// I believe these are mostly from the book/tutorial
// Computer Music with Supercollider
// http://www.mat.ucsb.edu/275/CottleSC3.pdf
// David Michael Cottle

// Dust tone flash
// Also of uncertain provenance
(
{
var trigger, fund, flashInst;
flashInst = Array.fill(5,
{
    trigger = Dust.kr(3/7);
    fund = rrand(100, 400);
    Pan2.ar(
        Mix.ar(
           Array.fill(16,
           { |counter|
            var partial;
            partial = counter + 1;
            SinOsc.ar(fund*partial) *
              EnvGen.kr(
                Env.adsr(0,0,1.0,5.0),
                trigger, 1/partial) *
              max(0, LFNoise1.kr(
              rrand(5.0, 12.0)))
           })
        )*0.2,
    1.0.rand2)
});
Mix.ar(flashInst) * 0.6
}.play
)

// Mouse-controlled carnival organ (from the future)
(
{
  var harmonics = 16, fund, speeds;
  //speeds = ((1..11)/20);
  fund = (MouseX.kr(10, 30).round(5) +
    24).midicps;
  Mix.fill(harmonics,
    { |count|
      Pan2.ar(
        FSinOsc.ar(
          fund * (count + 1),
          mul: max(0, FSinOsc.kr(rrand(1,1/3),mul:20).softclip)),
        1.0.rand2)
    }
  ) / (2*harmonics)
}.play;
)

