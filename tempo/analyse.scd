(
/// durées
a=r{ 
	var root=thisThread.beats;
	var onset={thisThread.beats};
	{
		var now=onset.value;
		(now-root).yield;
		root=now
	}.loop;
};
// rapports
b=r{
	arg inval; var mem;
	mem=inval;
	inval=0.yield;
	loop{ 
		var res=(inval/mem);
		mem=inval;
		inval=res.yield;
	}
};
/// convenience pour le tout
~varEv={
	r{
	a.reset;
	b.reset;
		loop{
			var dur=a.next;
			var variance=b.next(dur);
			(dur:dur, variance:variance).yield
	}
	}
};
"solfege.scd".loadRelative;
)

//// MIDI final
(
var f=~varEv.(); var g=~solf.();
var s=StaticText(nil, 300@300).front;
MIDIdef.noteOn(\dur, 
	{
		var res=f.next;
		g.next(res.variance).postln;
		defer{s.string_(res)}
	}
)

)

