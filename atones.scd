
// Enveloped noise
(
// ramp up to peak amp through
// first 3/4 of synth
SynthDef(\tsst,
  { | dur, amp |
    var sig, env;
    env = EnvGen.kr(
      Env.new(
        levels: [0, amp, 0],
        times:  [0.75 * dur, 0.25 * dur]));
    FreeSelfWhenDone.kr(env);
    sig = WhiteNoise.ar;
    Out.ar([0], sig * env);
  }
).add;

// like \tsst but adds amplitude modulation
// for a rasperry/rattlesnake/blinds opening-type effect
SynthDef(\tsst_blep,
  { | dur, amp, am_freq=30.0 |
    var sig, env, am_osc;
    env = EnvGen.kr(
      Env.new(
        levels: [0, amp, 0],
        times:  [0.75 * dur, 0.25 * dur]));
    FreeSelfWhenDone.kr(env);
    sig = WhiteNoise.ar;
    am_osc = LFTri.kr(am_freq) / 2.0 + 1.0;
    Out.ar([1], sig * env * am_osc);
  }
).add;
)

// Door "Creak"
(
{
  Blip.ar(freq: XLine.kr(start: 550, end: 150, dur: 0.9, doneAction: 2) +
	SinOsc.kr(freq: CombC.kr(WhiteNoise.ar(50), 0.02, Line.kr(50,80)), mul: 20)
) }.play;


s.freeAll;
)

// raygun (hit)
// Copied without attribution from somewhere  (sccode?)

(
SynthDef("raygun", {arg amp = 0.5, sinfreq = 1000, glissf = 0.001, att = 0.01, rel = 0.9;
    var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
    var snd = SinOsc.ar(gliss);
    var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);

    snd = snd * env * amp;
    Out.ar(0, snd);
}).add;
)
