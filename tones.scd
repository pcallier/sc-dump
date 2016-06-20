
// Summed sines
// the dev parameter controls
// the clean-ness of the harmonics
(
SynthDef(
  \noisyDeviantSines,
  {
    | freq=220, dev=0.03, amp=1.0 |
    var sig, sum, amps, num_waves=10, max_harmonic=5;
    amps={ 1.0.rand }!num_waves;
    amps=amps/amps.sum*amp;
    sum = 0;
    amps.do { |component_amp|
      sig = SinOsc.ar(
        freq * max_harmonic.rand * (1 + dev.rand2),
        1.0.rand,
        component_amp);
      sum = sum + sig;
    };
    Out.ar(0, sum!2);
  }
).add;
)

// Eli Fieldsteel Tutorial Random VarSaw
// slightly mismatched harmonics
// yield some depth in timbre
// Very Vangelis at low frequencies
// Amp control not great
SynthDef(\randVarSaw,
  { |freq=40, amp=0.8|
    var temp, sum, num_waves=10;
    sum=0;
    num_waves.do{
      temp = VarSaw.ar(
        freq: freq * Rand(0.99 * 1.02)!2,
        iphase: Rand(0, 1),
        width: 0.05);
      sum = sum + temp;
    };
    sum = sum * amp / (num_waves * 0.5);
    Out.ar(0, sum);
  }
).add;

// My own from-memory version of Eli's
// random variable-duty saw
SynthDef(\varSaw,
  {
    arg freq=60, amp=2.0, duty=0.5;
    var sig, sum, num_waves=10;
    sum = 0;
    num_waves.do{
      var detune=(freq/100).rand2, harm=rrand(1,5);
      "Harmonic: ".post; harm.postln;
      "Detune: ".post; detune.postln;
      sig = VarSaw.ar((freq+detune)*harm,
        1.0.rand,
        duty,
        amp/num_waves);
      sum=sum+sig;
    };
    Out.ar(0, sum!2)
  }
).add;

// singrain
// From i don't know where (some tutorial)
// Nice toy piano type sound
SynthDef(\singrain, { |freq = 440, amp = 0.2, sustain = 1|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.perc(0.01, sustain), doneAction: 2);
	Out.ar(0, sig ! 2);
}).add;

// boop
// Not enveloped. 8-bit, no harmonics, pulse wave
SynthDef(\boop,
{
    arg freq=220, amp=0.3;
    Out.ar(0, Pulse.ar(freq) * amp);
}).add;

// Slow build
// Xlinear increase in amp to end
(
{
  var duration = 4, sig, env, output;
  sig = Limiter.ar(
    level: 0.15,
    in: SinOsc.ar(
      freq: 220.0.exprand(600),
      mul: XLine.kr(
        0.01,
        0.15,
        dur: duration)));
  env = EnvGen.ar(Env.linen(
      attackTime:  0.01,
      sustainTime: duration,
      releaseTime: 0.01),
    );
  FreeSelfWhenDone.kr(env);
  output = sig * env;
  output
}.play;
)

// Build harmonics up over attack, to sustain
SynthDef.new(\sineAttack,
	{
		arg attack_speed = 0.1;
		var num_waves=8, wave_mix;
		wave_mix = Mix.fill(num_waves,
			{
				arg i;
				var delay_env;
				delay_env = Env.dadsr(i * attack_speed, 0.01, attack_speed, 1/num_waves, 0, 1/num_waves, -1);
				SinOsc.ar(Rand(220,880)) * delay_env.kr()});
		Out.ar([0,1], wave_mix);
}).add;